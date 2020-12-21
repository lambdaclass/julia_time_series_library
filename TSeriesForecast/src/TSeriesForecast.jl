module TSeriesForecast

submodules = [
    "simpleexponentialsmoothing"
]

for sm ∈ submodules
    include("./$sm.jl")
end

end
