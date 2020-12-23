module TSeriesForecast


submodules = [
    "simpleexponentialsmoothing",
    "holts_trend_method",
    "seasonality_exponential_smoothing"
]

for sm ∈ submodules
    include("./$sm.jl")
end

end
