using MixedModeDebugger
using Test

@testset "MixedModeDebugger.jl" begin
    @testset "$file" for file in ("overdub.jl",)
        include(file)
    end
end
