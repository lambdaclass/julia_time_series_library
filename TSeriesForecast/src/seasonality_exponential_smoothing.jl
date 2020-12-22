module seasonality_exponential_smoothing

struct HW
    α::Float64
    β::Float64
    γ::Float64
    l0::Float64
    b0::Float64
    m::Int64
    s0::Vector{Float64}

    HW() = new(0, 0, 0, 0, 0, 1, [0])
    HW(α::Number, β::Number, γ::Number, l0::Number, b0::Number, m::Int64, s0::Vector{Number}(undef, m)) = new(Float64(α), Float64(β), Float64(γ), Float64(l0), Float64(b0), Float64.(s0))
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