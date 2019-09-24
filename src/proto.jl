using Pkg: @pkg_str
pkg"activate ."

#---

using Cassette
#using JuliaInterpreter
#using MagneticReadHead
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
function Cassette.overdub(::MixModeDebugCtx, ::typeof(eg2))
    Core.println("-- begin interpretting")
    try
        Debugger.@run eg2()
    finally
        Core.println("-- end interpretting")
    end
end

#---

bp = @breakpoint eg3()

Cassette.recurse(MixModeDebugCtx(), eg1)
