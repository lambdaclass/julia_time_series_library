module DampedTrend

function Damped_HLT_forecast(time_serie, α, β, l0, b0, ϕ, n_pred)
	N = length(time_serie)
	l_t = 0
	b_t = 0
	l_t_ = 0 
	pred = Array{Float64}(undef, n_pred)
	
	for i in 1:(N)
		if i == 1
			l_t = l0
			b_t = b0
		else
			l_t = time_serie[i - 1] * α + (l_t + b_t) * (1 - α) #b_t "is" b(t-1)
			b_t = β * (l_t - l_t_) + (1 - β) * b_t 
		end
		l_t_ = l_t
	end
	
	l_t = time_serie[end] * α + (l_t + ϕ * b_t) * (1 - α)
	b_t = β * (l_t - l_t_) + (1 - β) * ϕ * b_t
	
	phi = 0
	
	for i in 1:n_pred
		phi += ϕ^i
		#y_pred = l_t + b_t * phi
        #push!(pred, y_pred)
        pred[i] = l_t + b_t * phi
	end
				
	return pred

end

end