# MixedModeDebugger

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://oxinabox.github.io/MixedModeDebugger.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://oxinabox.github.io/MixedModeDebugger.jl/dev)
[![Build Status](https://travis-ci.com/oxinabox/MixedModeDebugger.jl.svg?branch=master)](https://travis-ci.com/oxinabox/MixedModeDebugger.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/oxinabox/MixedModeDebugger.jl?svg=true)](https://ci.appveyor.com/project/oxinabox/MixedModeDebugger-jl)
[![Codecov](https://codecov.io/gh/oxinabox/MixedModeDebugger.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/oxinabox/MixedModeDebugger.jl)
[![Coveralls](https://coveralls.io/repos/github/oxinabox/MixedModeDebugger.jl/badge.svg?branch=master)](https://coveralls.io/github/oxinabox/MixedModeDebugger.jl?branch=master)

[![Build Status](https://api.cirrus-ci.com/github/oxinabox/MixedModeDebugger.jl.svg)](https://cirrus-ci.com/github/oxinabox/MixedModeDebugger.jl)

## What is MixedModeDebugger?

MixedModeDebugger is a debugger that runs in a mixture of modes: both compiled and interpreted.
It aims to achieve the best of both worlds.
We can constrast this to [MagneticReadHead](https://github.com/oxinabox/MagneticReadHead.jl) which is purely compiled;
and against [JuliaInterpreter](https://github.com/JuliaDebug/JuliaInterpreter.jl) / [JuliaDebugger](https://github.com/JuliaDebug/Debugger.jl/), which is purely interpreted.


### How is it different from MagneticReadHead ?
MagneticReadHead is fully compiled.
The whole code being debugged is actually rewritten (at the IR level) to include the debugging functionality.
This allows it to be pretty fast, at runtime.
However, because of how extensive the code tranformation is, it can take an immense amount of time to compile.
Infact, it might take orders of magnitude comparable to the head death of the universe to compile.

MixedModeDebugger uses a far lighter transform during its compiled-mode,
just enough to check if a method being called is one with a breakpoint set on it.
So it doesn't introduce anywhere near as much overhead.

### How is it different from Debugger.jl ?

Debugger.jl is fully interpreted, when debugging.
What Debugger.jl calls "Compiled mode" is actually disabling all debugger functionality until one returns out.
In contrast MixedModeDebugger's Compiled-mode disables most debugger functionality, except one crucial thing:
the ability to hit a breakpoint, and thus then enable full debugger functionality.

Because Debugger.jl is always interpreted, it is much slower all the time.
Where as MixedModeDebugger.jl can run at compiled speeds, until it hits a breakpoint.

Under-the-hood: when MixedModeDebugger.jl switches to interpreted-mode it literally calls `Debugger.@run`.

### How it works:
 - Compiled-mode execution is done in a Cassette context
 - This context overdubs any function with a breakpoint set on/within them to tell it to switch to interpreted mode.
    - This happens purely on the Method, not on any run-time information, so the switch will also be made for conditional breakpoints.
 - Hooks on JuliaInterpreter breakpoint commands cause these overdubs to be created and deleted.
 - When in interpreted mode JuliaDebugger.jl is used to provide the actual functioning debugger.

## Installation and Usage:
### Installation:
This package is still experimental, and so is not registered.
It may even be upstreamed directly into JuliaDebugger at some point.

Installation is thus via:
```
pkg> add https://github.com/oxinabox/MixedModeDebugger.jl.git
```

Note: this package requires Julia 1.3+ as it relies on the fix to the #265 issue for Cassette.

### Usage:
Usage is as per [JuliaDebugger, so just refer to those docs](https://github.com/JuliaDebug/Debugger.jl/)

With the following notes/exceptions:
 - `breakon(:error)` and `breakon(:throw)` do not function in compiled mode.
     - They will work fine if in interpreted mode (i.e. deaper in the callstack than a breakpoint)
 - Rather than using `@run f(x)`, uses `@run_mixedmode f(x)`
 - There is no matching `@enter f(x)` as setting a breakpoint right at the start would switch to interpreted-mode straight away.
 - Entering compiled mode via entering `C` at the debug prompt will switch you to Debugger.jl's idea of compiled mode so breakpoints will not then be hit. [Issue [#1](#1)]

## Performance

<img src="https://user-images.githubusercontent.com/5127634/71474059-ac43e400-27d1-11ea-9f42-24d9cb43fe70.png" width="420"/>
<sub>
 <b>Figure:</b> Run-time performance of JuliaDebugger vs MagneticReadHead, vs Native on the `summer` benchmark.
With no breakpoints set.
Note that on this task MixedModeDebugger performs exactly the same as Native, as there are no breakpoints set.
</sub>

Full performance benchmarks [can be found here](https://github.com/JuliaDebug/JuliaInterpreter.jl/issues/306#issuecomment-536196825).
The take aways of those benchmarks are:
 - The compile-time overhead of MixedModeDebugger is the same order of magnitude as JuliaDebugger/JuliaInterpreter.
 - In normal use worst-case runtime performance is the same as JuliaDebugger/JuliaInterpreter, and the best is basically the same as running natively.
 - The exception to this is the pathelogical case where it is constantly flipping between compiled and interpreted modes.

#### More on that pathelogical case and conditional breakpoints.
The key case where this breaks down is for conditional breakpoints in tight inner loops.
There is some overhead for switching from compiled-mode to interpreted-mode.
Normally this doesn't matter for two reasons:
1. The switch happens on a breakpoint, and thus execution normally stops anyway
2. The time to switch, is much lower than the time it takes to run the breakpointed function in interpreted-mode.

However, if the breakpoint is conditional and the condition is not met then the first point doesn't apply.
If it also is within a function on a function that is very fast (tight), then the second doesn't apply either.
And if it (the call the the function is inside an
This case is fortunately fairly rare.

If you find youself in it, then there is a fairly easy work around:
place a breakpoint (even one with a condition that is always false) further up the callstack:
such as in the function with the loop that calls the function the conditional breakpoint.
This extra breakpoint (even if not triggered) will cause the function to switch to interpreted mode before the problematic breakpoint, and so you will not see the mode-switch overhead.
