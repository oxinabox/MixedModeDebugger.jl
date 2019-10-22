function breakpoint_hook(f, bp)
    @info "Unhandled Hook, ignored" f bp
end


function breakpoint_hook(::typeof(JuliaInterpreter.breakpoint), bp::BreakpointSignature)
    @debug "Breakpoint created" bp
    make_interpretted_mode_overdub(bp)
end
