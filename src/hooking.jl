function breakpoint_hook(::typeof(JuliaInterpreter.breakpoint), bp)
    @debug "Breakpoint created" bp
    make_interpretted_mode_overdub(bp)
end

function breakpoint_hook(::typeof(JuliaInterpreter.remove), bp)
    @debug "Breakpoint Removed" bp
    remove_interpretted_mode_overdub(bp)
end

function breakpoint_hook(::typeof(JuliaInterpreter.update_states!), bp)
    is_enabled = bp.enabled[]
    @debug "Breakpoint update" bp is_enabled
    if is_enabled
        make_interpretted_mode_overdub(bp)
    else
        remove_interpretted_mode_overdub(bp)
    end
end
