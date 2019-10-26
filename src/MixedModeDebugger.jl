module MixedModeDebugger

using Cassette
using JuliaInterpreter: JuliaInterpreter, BreakpointSignature, BreakpointRef
using JuliaInterpreter: Frame, enter_call, get_return

# we use Mocking for `combine_def` (which is better than the one in MacroTools.jl)
# https://github.com/invenia/Mocking.jl/blob/master/src/expr.jl
using Mocking

#using MagneticReadHead
using Debugger

#=============== Exports ==================================================#
export @run_mixedmode

# reexport some useful things from JuliaInterpreter
using JuliaInterpreter: @bp, @breakpoint, breakpoint
export @breakpoint, breakpoint
#==========================================================================#

function __init__()
    push!(JuliaInterpreter.breakpoint_update_hooks, breakpoint_hook)
end

Cassette.@context MixModeDebugCtx
include("reflection_utils.jl")
include("run.jl")
include("overdub.jl")
include("hooking.jl")
end # module
