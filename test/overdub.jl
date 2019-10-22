using InteractiveUtils
using MixedModeDebugger
using Test

using MixedModeDebugger: make_interpretted_mode_overdub
@testset "make_interpretted_mode_overdub" begin
    @testset "Happy path" begin
        # these should not error.
        @test make_interpretted_mode_overdub(@which +(1)) isa Any
        @test make_interpretted_mode_overdub(@which +(1,2)) isa Any
    end
end
