function HLT_forecast(time_serie, α, β, l0, b0, n_pred)
	N = length(time_serie)
	l_t = 0
	b_t = 0
	l_t_ = 0 
	pred = []
    
    #go through the whole time series making the point by point estimate
	for i in 1:(N)
		if i == 1
			l_t = l0
			b_t = b0
		else
			l_t = time_serie[i - 1] * α + (l_t + b_t) * (1 - α) #b_t "is" b(t-1)
			b_t = β * (l_t - l_t_) + (1 - β) * b_t
		end
		l_t_ = l_t
		
		y_pred = l_t + b_t	
	end
    
    #The parameter´s values to make the forecast are those estimated in the last step of the time series
	l_t = time_serie[end] * α + (l_t + b_t) * (1 - α)
	b_t = β * (l_t - l_t_) + (1 - β) * b_t
	
	for i in 1:n_pred
		y_pred = l_t + b_t * i
		push!(pred, y_pred)
	end
			
	return pred
end

