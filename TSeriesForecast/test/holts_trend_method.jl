module holts_trend_methodTests

using Test

using TSeriesForecast.holts_trend_method: HLT_forecast, HLT, HLT_loss

ϵ = 0.1

### Data

data = [17.55340, 21.86010, 23.88660, 26.92930, 26.88850, 28.83140, 30.07510, 30.95350, 30.18570, 31.57970, 32.57757, 33.47740, 39.02158, 41.38643, 41.59655, 44.65732, 46.95177, 48.72884, 51.48843, 50.02697, 60.64091, 63.36031, 66.35527, 68.19795, 68.12324, 69.77935, 72.59770]
α = 0.832166
β = 0.000149
l0 = 15.57152
b0 = 2.101717
h = 5
y_expected_loss = 4.76262
y_expected_fitted = [17.67324, 19.67545, 23.59111, 25.93838, 28.86311, 29.32561, 31.01711, 32.33675, 33.28993, 32.81401, 33.89040, 34.90147, 35.82005, 40.57920, 43.35064, 43.99546, 46.64611, 49.00107, 50.87622, 53.48571, 52.71508, 61.39691, 65.12882, 68.24903, 70.30861, 70.59604, 72.01969]
y_expected_forecasted = [74.60130, 76.70304, 78.80478, 80.90652, 83.00826]

### Tests

@testset "Holts trend method" begin

    @testset "Holts loss function work" begin
        @test isapprox(HLT_loss(data, α, β, l0, b0), y_expected_loss; atol=ϵ)

    end

    @testset "Holts fitting process work" begin
        @test isapprox(HLT(data, α, β, l0, b0), y_expected_fitted; atol=ϵ)

    end

    @testset "Holts forecast work" begin
        @test isapprox(HLT_forecast(data, α, β, l0, b0, h), y_expected_forecasted; atol=ϵ)

    end

end

end