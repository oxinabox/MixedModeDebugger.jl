module MixedModeDebugger

using Compat
using Cassette
using JuliaInterpreter: JuliaInterpreter, BreakpointSignature, BreakpointRef, on_breakpoints_updated
using JuliaInterpreter: Frame, enter_call, get_return

using Debugger

#=============== Exports ==================================================#
export @run_mixedmode

# reexport some useful things from JuliaInterpreter
using JuliaInterpreter: @bp, @breakpoint, breakpoint
export @breakpoint, breakpoint
#==========================================================================#

Cassette.@context MixModeDebugCtx
include("reflection_utils.jl")
include("run.jl")
include("make_overdub.jl")
include("remove_overdub.jl")
include("hooking.jl")

#==========================================================================#
function __init__()
    # Get any breakpoints that were already defined.
    for bp in JuliaInterpreter._breakpoints
        make_interpretted_mode_overdub(bp)
    end

    # Add hook to get any that will be defined later
    on_breakpoints_updated(breakpoint_hook)
end

end # module
