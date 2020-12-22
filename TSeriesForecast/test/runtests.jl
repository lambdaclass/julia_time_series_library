using TSeriesForecast
using Test

tests = [
    "simpleexponentialsmoothing",
    "holts_trend_method",
    "dampedtrend"
]

@testset "TSeriesForecast.jl" begin
    @info("Running tests:")

    for test ∈ tests
        @info("\t* $test ...")
        include("./$test.jl")
    end
end
