
"""
    make_overdub(make_body, ::Type{Ctx}, f::F, sig::Tuple)

    - `make_body` is a function that gets as inputs the symbols for all the
      functions inputs, and must return an `Expr` for its body
"""
function make_overdub(make_body, ::Type{Ctx}, f::F, sig::Tuple) where {Ctx, F}
    sig_exs = Expr[]
    sig_names = []

    foreach(sig) do T
        T_uw = Base.unwrap_unionall(T)

        name = gensym()
        if T_uw isa TypeVar
            T = T_uw
        elseif T_uw.name.name === :Vararg
            if T isa UnionAll && T.body isa UnionAll  # Vararg{T, N} where {T, N}.
                T = Vararg{Any}
            end
            if T isa UnionAll  # Vararg{T, N} where N.
                push!(sig_exs, :($name::$(T_uw.parameters[1])...))
                push!(sig_names, :($name...))
            else  # Vararg{T, N}.
                foreach(1:T.parameters[2]) do _i
                    push!(sig_exs, :($name::$(T.parameters[1])))
                    push!(sig_names, name)
                    name = gensym()
                end
            end
        else
            push!(sig_exs, :($name::$T))
            push!(sig_names, name)
        end
    end

    overdub_code = quote
        function Cassette.overdub(ctx::$Ctx, f::$F, $(sig_exs...))
            $(make_body(sig_names...))
        end
    end
    #@show overdub_code
    eval(overdub_code)
end


function make_interpretted_mode_overdub(f, sig::Tuple)
    make_overdub(MixModeDebugCtx, f, sig) do args...
        quote
            thunk = ()->(println($args); f($(args...)))
            Debugger.@run(thunk())
        end
    end
end

function make_interpretted_mode_overdub(meth::Method)
    sigp = parameter_typeof(meth.sig)
    func_t = first(sigp)
    func = func_t.instance
    arg_sig = Tuple(sigp[2:end])
    return make_interpretted_mode_overdub(func, arg_sig)
end

function make_interpretted_mode_overdub(bp::BreakpointSignature)
    return make_interpretted_mode_overdub(bp.f)
end
