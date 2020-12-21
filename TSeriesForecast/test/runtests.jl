using TSeriesForecast
using Test

tests = [
    "simpleexponentialsmoothing"
]

@testset "TSeriesForecast.jl" begin
    @info("Running tests:")

    for test ∈ tests
        @info("\t* $test ...")
        include("./$test.jl")
    end
end
