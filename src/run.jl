
macro run_mixedmode(expr)
    quote
        thunk()=$(esc(expr))
        Cassette.recurse(MixModeDebugCtx(), thunk)
    end
end
