

function remove_interpretted_mode_overdub(primal_meth::Method)
    primal_sigp = parameter_typeof(primal_meth.sig)

    overdub_args_sigt = Tuple{MixModeDebugCtx, primal_sigp...}
    overdub_meth = only(methods(Cassette.overdub, overdub_args_sigt))
    return Base.delete_method(overdub_meth)
end

function remove_interpretted_mode_overdub(bp::BreakpointSignature)
    return make_interpretted_mode_overdub(bp.f)
end
