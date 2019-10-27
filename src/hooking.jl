function breakpoint_hook(f, bp)
    @info "Unhandled Hook, ignored" f bp
end

function breakpoint_hook(::typeof(JuliaInterpreter.breakpoint), bp::BreakpointSignature)
    @debug "Breakpoint created" bp
    make_interpretted_mode_overdub(bp)
end

function breakpoint_hook(::typeof(JuliaInterpreter.remove), bp::BreakpointSignature)
    @debug "Breakpoint Removed" bp
    remove_interpretted_mode_overdub(bp)
end

function breakpoint_hook(::typeof(JuliaInterpreter.update_states!), bp::BreakpointSignature)
    is_enabled = bp.enabled[]
    @debug "Breakpoint update" is_enabled
    if is_enabled
        make_interpretted_mode_overdub(bp)
    else
        remove_interpretted_mode_overdub(bp)
    end
end
