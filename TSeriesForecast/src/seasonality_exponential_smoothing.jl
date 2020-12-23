module seasonality_exponential_smoothing

using Optim

struct HW
	m::Int64
    α::Float64
    β::Float64
    γ::Float64
    l0::Float64
    b0::Float64
    s0::Array{Float64, 1}

    HW(m::Int64) = new(m, 0, 0, 0, 0, 0, repeat([0], m))
	HW(m::Int64, α::Number, β::Number, γ::Number, l0::Number, b0::Number, s0::Array{Float64, 1}) = 
		m == length(s0) ? new(m, Float64(α), Float64(β), Float64(γ), Float64(l0), Float64(b0), 
		Float64.(s0)) : error("length(s0) must be equal to m")
end

function loss(model::HW, time_series)
	α = model.α
	β = model.β
	γ = model.γ
	l0 = model.l0
	b0 = model.b0
	m = model.m
	s = model.s0

	N = length(time_series)
	l_t = 0
	b_t = 0
	l_t_ = 0 #Variable to save l(t-1)
	b_t_ = 0 #Variable to save b(t-1)
	s_ = 0
	
	loss = 0
	
	for i in 0:(N - 1)
		if i == 0
			l_t = l0
			b_t = b0
		else
			l_t = (time_series[i] - s_) * α + (l_t_ + b_t_) * (1 - α) 
			b_t = β * (l_t - l_t_) + (1 - β) * b_t_
		end
		l_t_ = l_t
		b_t_ = b_t
		s_ = s[i%m + 1]
		
		y_pred = l_t + b_t + s[i%m + 1]
		
		s[i%m + 1] = γ * (time_series[i + 1] - l_t_ - b_t_) + (1 - γ) * s[i%m + 1]
		
		loss += (time_series[i + 1] - y_pred)^2	
	end

	return loss
end

function fit(model::HW, time_series)
	lower = vcat([0, 0, 0, time_series[1]*0.5, 0], repeat([-30], model.m))
	upper = vcat([1, 1, 1, time_series[1]*1.5, 10], repeat([30], model.m))
	initial = [0.5, 0.5, 0.5, time_series[1], 1, model.s0...]

	function loss_(parameters::Array{Float64})
		α = parameters[1]
		β = parameters[2]
		γ = parameters[3]
		l0 = parameters[4]
		b0 = parameters[5]
		s0 = parameters[6:end]
		return loss(HW(model.m, α, β, γ, l0, b0, s0), time_series)
	end

	res = Optim.optimize(loss_, lower, upper, initial)
	optimal = Optim.minimizer(res)
	return HW(model.m, optimal[1], optimal[2], optimal[3], optimal[4], optimal[5], optimal[6:end])
end

function forecast(model::HW, time_serie, n_pred)
	α = model.α
	β = model.β
	γ = model.γ
	l0 = model.l0
	b0 = model.b0
	m = model.m
	s = model.s0
	
	N = length(time_serie)
	l_t = 0
	b_t = 0
	l_t_ = 0 #Variable to save l(t-1)
	b_t_ = 0 #Variable to save b(t-1)
	s_ = 0
	
	pred = []

	for i in 0:(N - 1)
		if i == 0
			l_t = l0
			b_t = b0
		else
			l_t = (time_serie[i] - s_) * α + (l_t_ + b_t_) * (1 - α) 
			b_t = β * (l_t - l_t_) + (1 - β) * b_t_
		end
		l_t_ = l_t
		b_t_ = b_t
		s_ = s[i%m + 1]
		
		s[i%m + 1] = γ * (time_serie[i + 1] - l_t_ - b_t_) + (1 - γ) * s[i%m + 1]	
	end
	
	l_t = (time_serie[end] - s_) * α + (l_t + b_t) * (1 - α)
	b_t = β * (l_t - l_t_) + (1 - β) * b_t_
	
	for i in N:(N+n_pred - 1) 
		y_pred = l_t + b_t*(i-N+1) + s[i%m + 1] 
		#The trend has to be added as many times as periods we want to forecast.
		push!(pred, y_pred)
	end	
	
	return pred
end

function HW_Seasonal(time_serie, α, β, γ, l0, b0, s0, m)
	N = length(time_serie)
	l_t = 0
	b_t = 0
	l_t_ = 0 #Variable to save l(t-1)
	b_t_ = 0 #Variable to save b(t-1)
	s_ = 0
	s = s0
	
	pred = []

	for i in 0:(N - 1)
		if i == 0
			l_t = l0
			b_t = b0
		else
			l_t = (time_serie[i] - s_) * α + (l_t_ + b_t_) * (1 - α) 
			b_t = β * (l_t - l_t_) + (1 - β) * b_t_
		end
		l_t_ = l_t
		b_t_ = b_t
		s_ = s[i%m + 1]
		
		y_pred = l_t + b_t + s[i%m + 1]
		push!(pred, y_pred)
		s[i%m + 1] = γ * (time_serie[i + 1] - l_t_ - b_t_) + (1 - γ) * s[i%m + 1]
	end
	return pred
end

function HW_Seasonal_forecast(time_serie, α, β, γ, l0, b0, s0, m, n_pred)
	N = length(time_serie)
	l_t = 0
	b_t = 0
	l_t_ = 0 #Variable to save l(t-1)
	b_t_ = 0 #Variable to save b(t-1)
	s_ = 0
	s = s0
	
	pred = []

	for i in 0:(N - 1)
		if i == 0
			l_t = l0
			b_t = b0
		else
			l_t = (time_serie[i] - s_) * α + (l_t_ + b_t_) * (1 - α) 
			b_t = β * (l_t - l_t_) + (1 - β) * b_t_
		end
		l_t_ = l_t
		b_t_ = b_t
		s_ = s[i%m + 1]
		
		s[i%m + 1] = γ * (time_serie[i + 1] - l_t_ - b_t_) + (1 - γ) * s[i%m + 1]	
    end
    
    l_t = (time_serie[end] - s_) * α + (l_t + b_t) * (1 - α)
	b_t = β * (l_t - l_t_) + (1 - β) * b_t_
	
	for i in N:(N+n_pred - 1)
		y_pred = l_t + b_t*(i-N+1) + s[i%m + 1] 
		#The trend has to be added as many times as periods we want to forecast.
		push!(pred, y_pred)
	end	
	return pred
end

end