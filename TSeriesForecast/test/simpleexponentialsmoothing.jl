module SimpleExponentialSmoothingTests

using Test

using TSeriesForecast.SimpleExponentialSmoothing: SES_weight

ϵ = 0.001

### Data

α = 0.8338901
l0 = 446.5867935
years = collect(1996:2013)
observations = [445.3641, 453.1950, 454.4096, 422.3789, 456.0371, 440.3866, 425.1944, 486.2052, 500.4291, 521.2759, 508.9476, 488.8889, 509.8706, 456.7229, 473.8166, 525.9509, 549.8338, 542.340]
y_pred = [446.5868, 445.5672, 451.9280, 453.9974, 427.6311, 451.3186, 442.2025, 428.0196, 476.5400, 496.4609, 517.1539, 510.3108, 492.4472, 506.9764, 465.0705, 472.3638, 517.0495, 544.3880]

### Tests

@testset "Simple Exponential Smoothing" begin

    @testset "SES_weight" begin
        @test isapprox(SES_weight(α, l0, observations), y_pred, atol=ϵ)
    end

end

end
