module SimpleExponentialSmoothing

export SES_weight

function SES_weight(α, l0, time_series)
    N = length(time_series)
    y_pred = 0
    pred = []

    for i in 1:(N)
        if i == 1
            y_pred = l0
        else
            y_pred = time_series[i - 1] * α + y_pred * (1 - α)
        end

        push!(pred, y_pred)
    end

    return pred
end

end
