using Pkg: @pkg_str
pkg"activate ."

#---

using Cassette
using JuliaInterpreter: JuliaInterpreter, BreakpointSignature, BreakpointRef
using MagneticReadHead
using Debugger
using Dates

using JuliaInterpreter: Frame, enter_call, get_return
@inline function run_interpretted(f, args...; kwargs...)
    fr = enter_call(f, args...)
    cmd = :c
    while true
        ret = JuliaInterpreter.debug_command(JuliaInterpreter.finish_and_return!, fr, cmd)
        ret == nothing && break
        fr, pc = ret
    end
    return get_return(fr)
end

Cassette.@context MixModeDebugCtx

function setup_overdubs(breakpoints=JuliaInterpreter._breakpoints)
    for bp in breakpoints
        create_overdub(bp)
    end
end


function create_overdub(bp)
    ft = MagneticReadHead.functiontypeof(bp.f)
    #TODO: select based on all the method sig info, not just the function
    @eval @inline function Cassette.overdub(::MixModeDebugCtx, f::$ft, args...)
        run_interpretted(f, args...)
    end
end


function run_mixedmode(f, args)
    Cassette.recurse(MixModeDebugCtx(), f, args)
end
##############

using Base: gc_num, time_ns, GC_Diff, gc_alloc_count, time_print, show_unquoted
macro time_trial(expr)
    run = quote
        GC.gc()
        local stats = gc_num()
        local elapsedtime = time_ns()
        local val = $(esc(expr))
        elapsedtime = time_ns() - elapsedtime
        local diff = GC_Diff(gc_num(), stats)
        time_print(elapsedtime, diff.allocd, diff.total_time,
                   gc_alloc_count(diff))
        println()
    end

    show_op = :(println($(sprint(show_unquoted, expr))))

    return quote
        $show_op
        print(" - 1st Run: ")
        $run
        print(" - 2nd Run: ")
        $run
        print(" - 3nd Run: ")
        $run
        println()
    end
end

########################################

# Setup:
function resetup()
    # Reinclude so that it recompiles
    include("../test/demo_funs.jl")
    JuliaInterpreter.remove()
    @breakpoint exp(1.0)
    setup_overdubs()  # for MixedModeDebugger
end

const x = rand(1_000, 500)
# Timing
resetup()
@time_trial winter(x)
resetup()
@time_trial run_interpretted(winter, x)
resetup()
@time_trial run_mixedmode(winter, x)
