using Pkg: @pkg_str
pkg"activate ."

#---

using Cassette
using JuliaInterpreter: JuliaInterpreter, BreakpointSignature
using MagneticReadHead
using Debugger

#---

function eg1()
    println("1a")
    eg2()
    println("1b")
end
function eg2()
    println("  2a")
    eg3()
    println("  2b")
end
function eg3()
    x=1+1+1
    print("    ")
    println(x)
end
eg1()


#---

Cassette.@context MixModeDebugCtx

function setup_overdubs(breakpoints=JuliaInterpreter._breakpoints)
    for bp in breakpoints
        create_overdub(bp)
    end
end

function create_overdub(bp)
    ft = MagneticReadHead.functiontypeof(bp.f)
    #TODO: select based on all the method sig info, not just the function
    @eval function Cassette.overdub(::MixModeDebugCtx, f::$ft, args...)
        Core.println("-- begin interpretting")
        try
            # We wrap the call in a thunk before invoking it so that Debugger.jl
            # can break on the call itself, if required.
            # If we knew for sure would break then could use @enter
            # TODO: remove this, but accessing Debugger internals for doing this
            thunk() = f(args...)
            Debugger.@run thunk()
        finally
            Core.println("-- end interpretting")
        end
    end
end

methodswith(typeof(eg3))

bp = @breakpoint eg3()
setup_overdubs()
Cassette.recurse(MixModeDebugCtx(), eg1)

##############

function summer(A)
   s = zero(eltype(A))
   for a in A
       s += a
   end
   return s
end

function run_mm(f, args)
    setup_overdubs()
    Cassette.recurse(MixModeDebugCtx(), f, args)
end
const x=rand(10_000)
@time summer(x)
@time summer(x)

@time Debugger.@run summer(x)
@time Debugger.@run summer(x)

@time MagneticReadHead.@run summer(x)
@time MagneticReadHead.@run summer(x)

@time run_mm(summer, x)
@time run_mm(summer, x)
