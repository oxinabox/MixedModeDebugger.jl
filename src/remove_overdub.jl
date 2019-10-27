

function remove_interpretted_mode_overdub(primal_meth::Method)
    primal_sigp = parameter_typeof(meth.sig)

    overdub_args_sigt = Tuple{MixModeDebugCtx, primal_sigp...}
    overdub_method = only(methods(Cassette.overdub, overdub_args_sigt))
    return Base.delete_method(overdub_method)
end

function make_interpretted_mode_overdub(bp::BreakpointSignature)
    return make_interpretted_mode_overdub(bp.f)
end
