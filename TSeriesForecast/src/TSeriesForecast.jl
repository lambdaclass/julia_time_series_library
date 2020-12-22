module TSeriesForecast


submodules = [
    "simpleexponentialsmoothing",
    "holts_trend_method",
    "dampedtrend"
]

for sm ∈ submodules
    include("./$sm.jl")
end

end
