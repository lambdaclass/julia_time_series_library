module holts_trend_methodTests

using Test

using TSeriesForecast.holts_trend_method: HLT_forecast

ϵ = 0.01

### Data


data = [17.55340, 21.86010, 23.88660, 26.92930, 26.88850, 28.83140, 30.07510, 30.95350, 30.18570, 31.57970, 32.57757, 
33.47740, 39.02158, 41.38643, 41.59655, 44.65732, 46.95177, 48.72884, 51.48843, 50.02697, 60.64091, 63.36031, 
66.35527, 68.19795, 68.12324, 69.77935, 72.59770]
α = 0.832166
β = 0.000149
l0 = 15.57152
b0 = 2.101717
h = 5
y_expected = [74.60130, 76.70304, 78.80478, 80.90652, 83.00826]
### Tests



@testset "Holts trend method" begin

    @testset "Holts linear method work" begin
        @test isapprox(HLT_forecast(data, α, β, l0, b0, h), y_expected; atol=ϵ)

    end
end

end