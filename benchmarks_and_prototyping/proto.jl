using MixedModeDebugger

function foo(x)
    z = 0
    for ii in 1:10
        z+=ii
    end
    y = sum((x, z, 11))
    return y
end
@breakpoint sum((1,2,3))
@run_mixedmode(Main.foo(10))
