
"""
    qualify_calls!(expr::Expr, mod)

Qualifies all calls inside the `expr` expression to be realive to the module `mod`.
"""
qualify_calls!(x, mod) = x
qualify_calls!(expr, mod::Module) = qualify_calls!(expr, nameof(mod))
function qualify_calls!(expr::Expr, mod::Symbol)
    if Meta.isexpr(expr, :call)
        expr.args[1] = Expr(:., mod, expr.args[1])
    end
    qualify_calls!.(expr.args, mod)
    return expr
end
