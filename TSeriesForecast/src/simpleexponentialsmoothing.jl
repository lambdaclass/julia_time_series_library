module SimpleExponentialSmoothing

export SES, loss, forecast

struct SES
    α::Float64
    l0::Float64

    SES() = new(0, 0)
    SES(α::Number, l0::Number) = new(Float64(α), Float64(l0))
end

function loss(model::SES, time_series)
    α = model.α
    l0 = model.l0

    loss = 0
    N = length(time_series)
    y_pred = 0

    for i in 1:(N)
        if i == 1
            y_pred = l0
        else
            y_pred = time_series[i - 1] * α + y_pred * (1 - α)
        end

        loss += (time_series[i] - y_pred)^2
    end

    return loss
end

function loss(parameters::Array{Float64}, y)
    α = parameters[1]
    l0 = parameters[2]
    return loss(SES(α, l0), y)
end

function forecast(model, time_series, forecast_length)
    α = model.α
    l0 = model.l0

    N = length(time_series)
    y_pred = 0
    pred = []

    for i in 1:(N)
        if i == 1
            y_pred = l0
        else
            y_pred = time_series[i - 1] * α + y_pred * (1 - α)
        end
    end

    y_pred = time_series[N] * α + y_pred * (1 - α)

    for j in 1:forecast_length
        push!(pred, y_pred)
    end

    return pred
end

end
