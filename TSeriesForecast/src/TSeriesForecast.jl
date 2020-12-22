module TSeriesForecast


submodules = [
    "simpleexponentialsmoothing"
    "holts_trend_method"
]

for sm ∈ submodules
    include("./$sm.jl")
end

end
