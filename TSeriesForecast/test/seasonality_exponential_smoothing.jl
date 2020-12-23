module seasonality_exponential_smoothingTests

using Test

using TSeriesForecast.seasonality_exponential_smoothing: HW, loss, fit, forecast

ϵ = 0.1

### Data

data = [42.2056638559382, 24.6491713296294, 32.6673351386246, 37.2573540134764, 45.2424602720635, 29.3504812742718, 36.3442072775119, 41.7820813647366, 49.2765984345619, 31.2754013898459, 37.8506254947152, 38.83704413019, 51.236900336137, 31.8385516171558, 41.3234212576972, 42.7990033724349, 55.708358364385, 33.4071449171312, 42.3166379718116, 45.1571225674731, 59.5760799633937, 34.8373301595328, 44.8416807241332, 46.971249602779, 60.0190309438716, 38.3711785132276, 46.9758641283558, 50.7337964560878, 61.6468731860574, 39.2995693656296, 52.6712090814052, 54.3323168946667, 66.834358381339, 40.8711884667851, 51.8285357927739, 57.4919099342262, 65.2514698518726, 43.0612082202828, 54.7607571288007, 59.8344749355003, 73.2570274672009, 47.6966237298, 61.0977680206996, 66.0557612187001 ]
α = 0.306342956680807
β = 0.000100001296624933
γ = 0.426290711530531
l0 = 32.2596735425297
b0 = 0.701381297812788
h = 8
m = 4
s0 = [9.6962, -9.31324086158846, -1.6935401189679, 1.31060178041439]

expected_mse = 3.10924508566665 #mse = loss/length(time_serie)
y_expected_fitted = [ 42.6572340404844, 24.21081477348, 32.6661829360246, 36.3720578962127, 45.5378079931788, 27.5187168280733, 36.2148118182051, 40.3371306494425, 49.171340569086, 32.1820914045507, 39.3136533640888, 43.5088715586704, 49.8974573204696, 32.8543378844383, 39.7147361880909, 43.4827966071507, 53.6557621665274, 35.8272959907684, 43.3763205153963, 45.3494719969994, 56.8393233421518, 37.3136607326191, 45.4253309990936, 47.9139961056344, 60.4224926964744, 37.7121150317104, 47.5909961330668, 49.9168074175707, 63.1943244235032, 40.5863696216504, 49.3257081290391, 53.4754641480289, 65.7573910045542, 44.0649207101445, 54.1949995740771, 55.5336851714369, 68.2465899064367, 43.4854450109548, 54.8162133971451, 58.7062827647439, 69.0531133095763, 47.5937707433477, 59.24375503884, 64.2240841042244 ]
y_expected_forecast = [76.0983732770355, 51.6033257926593, 63.9686736144129, 68.3717004584965, 78.9040413079506, 54.4089938235743, 66.7743416453279, 71.1773684894116 ]

model = HW(m, α, β, γ, l0, b0, s0)

### Tests

@testset "Seasonality Exponential Smoothing" begin

    @testset "HW Seasonal struct" begin

        @testset "HW default constructor" begin
            model = HW(4)
            @test model.α ≈ 0
            @test model.β ≈ 0
            @test model.γ ≈ 0
            @test model.l0 ≈ 0
            @test model.b0 ≈ 0
            @test model.m ≈ 4
            @test model.s0 ≈ [0, 0, 0, 0]
        end

        @testset "HW parametric constructor" begin
            α = 0.8
            β = 0.001
            γ = 0.42
            l0 = 42.0
            b0 = 2.3
            m = 4
            s0 = [-9.31, 9.32, -1.24, 1.26]
            model = HW(m, α, β, γ, l0, b0, s0)
            @test model.α ≈ α
            @test model.β ≈ β
            @test model.γ ≈ γ
            @test model.l0 ≈ l0
            @test model.b0 ≈ b0
            @test model.m ≈ m
            @test model.s0 ≈ s0
        end

        @testset "HW parametric constructor takes any Number type" begin
            α = Float32(0.8)
            β = Float16(0.001)
            γ = 0.42
            l0 = 42
            b0 = 2.3
            m = 4
            s0 = [-9.31, 9.32, -1.24, 1.26]
            model = HW(m, α, β, γ, l0, b0, s0)
            @test model.α ≈ α
            @test model.β ≈ β
            @test model.γ ≈ γ
            @test model.l0 ≈ l0
            @test model.b0 ≈ b0
            @test model.m ≈ m
            @test model.s0 ≈ s0
        end

        @testset "Length(S0) == to m" begin
            α = Float32(0.8)
            β = Float16(0.001)
            γ = 0.42
            l0 = 42
            b0 = 2.3
            m = 3
            s0 = [-9.31, 9.32, -1.24, 1.26]
            @test_throws ErrorException model = HW(m, α, β, γ, l0, b0, s0)
        end

    end

    @testset "loss" begin
        @test isapprox(loss(model, data)/length(data), expected_mse, atol=ϵ)
    end

    @testset "fit" begin
        starting_point = HW(4)
        optimal_model = fit(starting_point, data)

        @test isapprox(optimal_model.α, α, atol=0.1)
        @test isapprox(optimal_model.β, β, atol=0.1)
        @test isapprox(optimal_model.γ, γ, atol=0.1)
        @test isapprox(optimal_model.l0, l0, atol=4)
        @test isapprox(optimal_model.b0, b0, atol=2)
        @test isapprox(optimal_model.s0, s0, atol=4)
    end

    @testset "forecast" begin
        @test isapprox(forecast(model, data, h), y_expected_forecast, atol=ϵ)
        @test length(forecast(model, data, h)) == h
    end

end

end