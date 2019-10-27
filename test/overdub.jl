using Cassette
using InteractiveUtils
using MixedModeDebugger
using Test

using MixedModeDebugger: make_interpretted_mode_overdub, remove_interpretted_mode_overdub
@testset "make_interpretted_mode_overdub" begin
    @testset "Happy path" begin
        # these should not error.
        @testset "+(1)" begin
            overdubs_before = methods(Cassette.overdub)
            @test make_interpretted_mode_overdub(@which +(1)) isa Any
            @test methods(Cassette.overdub) != overdubs_before
            @test remove_interpretted_mode_overdub(@which +(1)) isa Any
            @test_broken methods(Cassette.overdub) == overdubs_before
        end

        @testset "+(1, 2)" begin
            overdubs_before = methods(Cassette.overdub)
            @test make_interpretted_mode_overdub(@which +(1, 2)) isa Any
            @test methods(Cassette.overdub) != overdubs_before
            @test remove_interpretted_mode_overdub(@which +(1, 2)) isa Any
            @test_broken methods(Cassette.overdub) == overdubs_before
        end

        @testset "rand(1)" begin
            overdubs_before = methods(Cassette.overdub)
            @test make_interpretted_mode_overdub(@which rand(1)) isa Any
            @test methods(Cassette.overdub) != overdubs_before
            @test remove_interpretted_mode_overdub(@which rand(1)) isa Any
            @test_broken methods(Cassette.overdub) == overdubs_before
        end

        @testset "rand(1:10, (10,20))" begin
            overdubs_before = methods(Cassette.overdub)
            @test make_interpretted_mode_overdub(@which rand(1:10, (10,20))) isa Any
            @test methods(Cassette.overdub) != overdubs_before
            @test remove_interpretted_mode_overdub(@which rand(1:10, (10,20))) isa Any
            @test_broken methods(Cassette.overdub) == overdubs_before
        end
    end
end
