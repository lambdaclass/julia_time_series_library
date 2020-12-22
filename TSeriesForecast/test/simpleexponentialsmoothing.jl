module SimpleExponentialSmoothingTests

using Test

using TSeriesForecast.SimpleExponentialSmoothing: loss, forecast, SES, fit

ϵ = 1.0e-6

### Data

α = 0.83389014338874
l0 = 446.586793455216
years = collect(1996:2013)
observations = [445.364098092, 453.195010427, 454.409641012, 422.378905779, 456.037121728, 440.386604674, 425.194372519, 486.20517351, 500.429086073, 521.27590917, 508.947617045, 488.888857729, 509.870574978, 456.722912348, 473.816602915, 525.950870565, 549.833807597, 542.340469826]
y_pred = [446.586793455216, 445.567199843463, 451.927955904711, 453.997408654674, 427.631050757941, 451.318593352274, 442.202515745824, 428.019592751632, 476.539975033385, 496.460869263639, 517.153886449352, 510.31075927907, 492.447246723823, 506.976388420008, 465.070510052539, 472.363790683708, 517.049528409702, 544.388015682095]

y_forecast = [542.6805873746]

model = SES(α, l0)

### Tests

@testset "Simple Exponential Smoothing" begin
    @testset "SES struct" begin

        @testset "SES default constructor" begin
            model = SES()
            @test model.α ≈ 0
            @test model.l0 ≈ 0
        end

        @testset "SES parametric constructor" begin
            α = 3.14
            l0 = 42.0
            model = SES(α, l0)
            @test model.α ≈ α
            @test model.l0 ≈ l0
        end

        @testset "SES parametric constructor takes any Number type" begin
            α = 42
            l0 = Float32(3.1415)
            model = SES(α, l0)
            @test model.α ≈ α
            @test model.l0 ≈ l0
        end
    end

    @testset "loss" begin
        y = observations
        expected_loss = sum((y - y_pred) .^ 2)

        @test isapprox(loss(model, y), expected_loss)
    end

    @testset "fit" begin
        y = observations

        starting_point = SES()
        optimal_model = fit(starting_point, y)

        @test isapprox(optimal_model.α, α, atol=ϵ)
        @test isapprox(optimal_model.l0, l0, atol=ϵ)
    end

    @testset "forecast" begin
        @testset "The forecast is correct" begin
            @test forecast(model, observations, 1) ≈ y_forecast
        end

        @testset "forecast returns an array of length `h`" begin
            @test length(forecast(model, observations, 1)) == 1
        end

        @testset "The forecast vector repeats the same value" begin
            @test forecast(model, observations, 42) ≈ repeat(y_forecast, 42)
        end
    end

end

end
