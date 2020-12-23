module HoltsLinearTrendTests

using Test

using TSeriesForecast.HoltsLinearTrend: HLT, loss, fit, forecast

ϵ = 0.1

### Data

observations = [17.5534, 21.8601, 23.8866, 26.9293, 26.8885, 28.8314, 30.0751, 30.9535, 30.1857, 31.5797, 32.577569, 33.477398, 
39.021581, 41.386432, 41.596552, 44.657324, 46.951775, 48.728837, 51.488427,50.026967, 60.640913, 63.3603103378, 
66.355274, 68.197955, 68.1232376693, 69.7793454797, 72.597700806]

### Parameters

α = 0.830216559778346
β = 0.000100014855685128
l₀ = 15.5715222051655
b₀ = 2.10171710376136
h = 5

### Expected values

y_expected = [74.6013036045367, 76.7030432818444, 78.8047829591522, 80.90652263646, 83.0082623137678]

### Tests

@testset "Holts Linear Trend" begin
    @testset "HLT struct" begin
        
        @testset "HLT default constructor" begin
            model = HLT()
            @test model.α ≈ 0
            @test model.β ≈ 0
            @test model.l₀ ≈ 0
            @test model.b₀ ≈ 0
        end

        @testset "HLT parametric constructor" begin
            α = 0.5
            β = 0.2
            l₀ = 130.9
            b₀ = 20.3
            model = HLT(α, β, l₀, b₀)
            @test model.α ≈ α
            @test model.β ≈ β
            @test model.l₀ ≈ l₀
            @test model.b₀ ≈ b₀
        end

        @testset "HLT parametric constructor takes any Number type" begin
            α = Float32(0.2341)
            β = BigFloat(0.1112)
            l₀ = 345
            b₀ = 54.
            model = HLT(α, β, l₀, b₀)
            @test model.α ≈ α
            @test model.β ≈ β
            @test model.l₀ ≈ l₀
            @test model.b₀ ≈ b₀
        end
    end

    @testset "loss" begin
        # taken from R
        expected_mse = 4.76261989118118
        model = HLT(α, β, l₀, b₀)
        @test isapprox(loss(model, observations)/length(observations), expected_mse; atol=ϵ)
    end

    @testset "fit" begin
        y = observations

        starting_point = HLT()
        optimal_model = fit(starting_point, y)

        @test isapprox(optimal_model.α, α; atol=0.1)
        @test isapprox(optimal_model.β, β; atol=1)
        @test isapprox(optimal_model.l₀, l₀; atol=1)
        @test isapprox(optimal_model.b₀, b₀; atol=0.1)
    end

    @testset "forecast" begin
        model = HLT(α, β, l₀, b₀)
        @testset "The forecast is correct" begin
            @test isapprox(forecast(model, observations, h), y_expected; atol=ϵ)
        end

        @testset "forecast returns an array of length `h`" begin
            @test length(forecast(model, observations, 5)) == 5
        end
    end
end

end