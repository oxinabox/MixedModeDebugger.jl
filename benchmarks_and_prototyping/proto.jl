using Pkg
pkg"activate ."

using JuliaInterpreter

@breakpoint sum((1,2,3))

push!(
JuliaInterpreter.breakpoint_update_hooks


JuliaInterpreter.breakpoint_update_hooks
