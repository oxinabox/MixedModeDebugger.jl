
macro run_mixedmode(expr)
    #qualify_calls!(expr, __module__)  # TODO Fix this
    quote
        thunk()=$(expr)
        Cassette.recurse(MixModeDebugCtx(), thunk)
    end
end
