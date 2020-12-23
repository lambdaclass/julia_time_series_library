# TSeriesForecast

## Introduction
TSeriesForecast.jl is a library for analysis and forecasting of time series data. The forecasting functions implemented to this moment are:

* Simple exponential smoothing.
* Holt's linear trend method.
* Damped Holt's linear trend method.
* Seasonality Holt's-Winter method. 

## Installation

FIXME

## Usage
Each method can be instantiated and fitted to the data for making a forecast. 

### Model instantiation
```julia
julia> model = SES()
julia> model = HLT()
julia> model = HW(m=4)
```
It is also possible to especify the parameters values to build a especific model instance.

Notice that m denote the seasonality´s frequency, so is always needed to build the Holt´s-Winter model.

```julia
julia> model = SES(⍺ = 0.8, l0=30)
julia> model = HLT(⍺ = 0.8, β = 0.01, l0 = 10.2, b0 = 2)
julia> model = HW(m = 4, ⍺ = 0.8, β = 0.01, l0 = 10.2,
                  b0 = 2, s0 = [-9.3, 9.5, -2.1, 1.9])
```
Also note that length(s0) must be equal to m

This will assign all parameters of HLT method to 0.

### loss
This function returns the Residual Sum Squares for some model instance and the time series we have.
Is the function that the *fit* function minimize, obtaining the optimal parameters.
```julia
julia> loss = loss(model, time_series)
```


### fit
This function optimizes the parameters for a given _model_.

```Julia
julia> fit(SES(), y)
SES(0.9999999998344521, 1.0000000001822997)
```

### forecast
Once the model is fitted to the data, we make a forecast for N time steps in the future like so:
```julia
julia> forecast(model, time_series, N)
```


## Contributing

- [Repository at GitHub](https://github.com/lambdaclass/julia_time_series_library)
- [Tickets at Clickup](https://app.clickup.com/3019765/v/b/li/11462219)
- [Tests with Drone-CI](https://github-drone.lambdaclass.com/lambdaclass/julia_time_series_library/)


## License

TSeriesForecast is licensed under the [MIT License](https://github.com/lambdaclass/julia_time_series_library/blob/main/TSeriesForecast/LICENSE).