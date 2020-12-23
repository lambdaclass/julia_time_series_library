module HoltsLinearTrend

using Optim

mutable struct HLT
	α::Float64
	β::Float64
	l₀::Float64
	b₀::Float64

	HLT() = new(0, 0, 0, 0)
	HLT(α::Number, β::Number, l₀::Number, b₀::Number) = new(Float64(α), Float64(β),
		Float64(l₀), Float64(b₀))
end


function loss(model::HLT, time_series)
	α, β, l₀, b₀ = model.α, model.β, model.l₀, model.b₀

	N = length(time_series)

	l_t, l_t_, b_t = 0, 0, 0 # l_t_ is the variable to save l(t-1)
	loss = 0

	for t in 1:N
		if t == 1
			l_t = l₀
			b_t = b₀
		else
			l_t = time_series[t - 1] * α + (l_t + b_t) * (1 - α) #b_t is taking b(t-1) value
		end

		l_t_ = l_t
		y_pred = l_t + b_t
		loss += (time_series[t] - y_pred)^2
	end

	return loss
end


function fit(model::HLT, y)
	lower = [-Inf, -0.001, -Inf, -Inf]
	upper = [1., 1., Inf, Inf]
	initial = [model.α, model.β, model.l₀, model.b₀]

	function loss_(parameters::Array{Float64, 1})
		α, β, l₀, b₀ = parameters
		return loss(HLT(α, β, l₀, b₀), y)
	end
	res = Optim.optimize(loss_, lower, upper, initial)
	optimal = Optim.minimizer(res)
	return HLT(optimal[1], optimal[2], optimal[3], optimal[4])
end


function forecast(model::HLT, time_series, forecast_length)
	N = length(time_series)
	α, β, l₀, b₀ = model.α, model.β, model.l₀, model.b₀
	l_t, l_t_, b_t = 0, 0, 0
	pred = Array{Float64, 1}(undef, forecast_length)
    
    #go through the whole time series making the point by point estimate
	for t in 1:N
		if t == 1
			l_t = l₀
			b_t = b₀
		else
			l_t = time_series[t - 1] * α + (l_t + b_t) * (1 - α) #b_t "is" b(t-1)
			b_t = β * (l_t - l_t_) + (1 - β) * b_t
		end
		l_t_ = l_t
	end
    
    #The parameter´s values to make the forecast are those estimated in the last step of the time series
	l_t = time_series[end] * α + (l_t + b_t) * (1 - α)
	b_t = β * (l_t - l_t_) + (1 - β) * b_t
	
	for i in 1:forecast_length
		#y_pred = l_t + b_t * i
		#push!(pred, y_pred)
		pred[i] = l_t + b_t * i
	end
			
	return pred
end

end