### A Pluto.jl notebook ###
# v0.12.7

using Markdown
using InteractiveUtils

# ╔═╡ a8985a28-301a-11eb-13fb-3540d83641bb
using Plots

# ╔═╡ ae00d74a-30cb-11eb-3997-0f1a1c55a2ff
using Optim

# ╔═╡ 97ceb2ca-2f5a-11eb-2a7b-cd339b881ea1
md"## Exponential Smoothing"

# ╔═╡ f03467ca-2f5a-11eb-1d53-f3d95c4267db
function SES(time_serie, α)
	y_pred = 0
	N = length(time_serie)
	
	for i in 1:N
		y_pred += time_serie[N - (i - 1)] * (α * ((1-α)^(i-1)))
	end
	
	return y_pred
end	

# ╔═╡ bc7a1146-3010-11eb-1b31-d940642ff8aa
y_ =[445.36,453.20,454.41,422.38,456.04,440.39,425.19,486.21,500.43,521.28,508.95,488.89,509.87,456.72,473.82,525.95,549.83,542.34]

# ╔═╡ 2cc65384-3009-11eb-26f9-9f7c099e6114
SES(y_, 0.83)

# ╔═╡ d3b45e90-30e6-11eb-27f4-bd7ac92ef892
function SES_weight(α, l0, time_serie)
	N = length(time_serie)
	y_pred = 0
	pred = []
	
	for i in 1:(N)
		if i == 1
			y_pred = l0
		else
			y_pred = time_serie[i - 1] * α + y_pred * (1 - α)
		end
	
		push!(pred, y_pred)
		
	end
	
	return pred
end

# ╔═╡ 30dd4d7c-30e7-11eb-3480-d5721718f1b3
SES_weight(0.83, 446.57, y_)

# ╔═╡ 340dc8bc-3017-11eb-04ac-19fc0e45d6af
function SES_weight_loss(α, l0, time_serie=y_)
	loss = 0
	#time_serie_l0 = vcat([l0], time_serie)
	N = length(time_serie)
	y_pred = 0
	
	for i in 1:(N)
		if i == 1
			y_pred = l0
		else
			y_pred = time_serie[i - 1] * α + y_pred * (1 - α)
		end
	
		loss += (time_serie[i] - y_pred)^2
		
	end
	
	return loss
end
		

# ╔═╡ afda21c6-30c5-11eb-141a-bbc93204323b
function SES_loss_(params, time_serie=y_)
	return SES_weight_loss(params[1], params[2], time_serie)
end

# ╔═╡ 1ade257e-3019-11eb-1629-cb9a519f86fb
los= SES_weight_loss(0.833, 446.59)

# ╔═╡ 98ef988a-3019-11eb-1461-f38c5714521f
aplhas = collect(0:0.01:1)

# ╔═╡ acd8fb36-3019-11eb-2a51-d34ed19b2646
begin
	a = Array{Float64}(undef, length(aplhas))
for j in 1:length(aplhas)
	a[j] = SES_weight_loss(aplhas[j], 446.6)
end
end


# ╔═╡ a131db1a-301a-11eb-293b-e128292362f2
plot(0:0.01:1, a)

# ╔═╡ 3aa01418-30cc-11eb-3ada-ddca54664fb8
begin 
	lower = [0., 400.]
	upper = [1., 500.]
	initial_x = [0.6, 450.]
end

# ╔═╡ b4632228-30cb-11eb-0380-65d3a2da7975
res = optimize(SES_loss_,lower, upper, initial_x);

# ╔═╡ 4f10d0be-30e4-11eb-366c-9f9a574c70ce
optim = Optim.minimizer(res)

# ╔═╡ 4619edaa-30ea-11eb-3a4c-6721d7443aa0
pred = SES_weight(0.833, 446.573, y_)

# ╔═╡ e4a13032-30ea-11eb-2f28-672a793137f5
time = collect(1996:1:2013)

# ╔═╡ 118c8542-30b9-11eb-0e73-0f90ef1da61e
begin
	plot(time,y_, label="Serie")
	plot!(time,pred, legend=:topleft, label="Fitted")
end

# ╔═╡ 1cebcf7a-30ec-11eb-0697-f94fe4db2430
forecast = SES(y_, 0.83378)

# ╔═╡ df699004-30d7-11eb-18e8-33dc21caf77a
md"### Holt’s linear trend method"

# ╔═╡ 2230b29c-30f0-11eb-2e02-197ad35d3100
function HLT_loss(time_serie, α, β, l0, b0)
	N = length(time_serie)
	l_t = 0
	b_t = 0
	l_t_ = 0 #Variable to save l(t-1)
	loss = 0
	
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
		
		loss += (time_serie[i] - y_pred)^2
		
	end
	
	return loss
end

# ╔═╡ ac0f3dfe-30f9-11eb-17b1-7729d039a6b9
data = [17.55,21.86,23.89,26.93,26.89,28.83,30.08,30.95,30.19,31.58,32.58,33.48,39.02,41.39,41.60, 44.66,46.95,48.73,51.49,50.03,60.64,63.36,66.36,68.20,68.12,69.78,72.60]

# ╔═╡ 1cd57bf6-3317-11eb-3b83-9f1872df41c9
time_ = collect(1990:2016)

# ╔═╡ fa5ffb46-3316-11eb-3d31-978b6c604077
plot(time_, data, legend=false)

# ╔═╡ 06993716-30fa-11eb-0e0a-1f84abee8bf6
function HLT_loss_(params, time_serie=data)
	return HLT_loss(time_serie, params[1], params[2], params[3], params[4])
end

# ╔═╡ 7674fda8-30fb-11eb-176b-e5999af211fe
begin 
	lower_ = [0., 0., 10., 1.]
	upper_ = [1., 1.,30., 5]
	initial_x_ = [0.5, 0.5, 15., 2.]
end

# ╔═╡ a71787f4-30fc-11eb-39db-e564e728c3db
res1 = optimize(HLT_loss_, lower_, upper_, initial_x_);

# ╔═╡ f9396bd8-30fc-11eb-2c96-f95f493a4270
optim1 = Optim.minimizer(res1)

# ╔═╡ a4c65e44-331d-11eb-1f52-77139935920a
HLT_loss(data, 0.8321, 0.0001, 15.57, 2.102)

# ╔═╡ e34f28a8-331d-11eb-398c-adc71cbd3cb5
HLT_loss(data, 0.8215406645869177, 3.933846947991096e-16, 15.847524289600578, 2.0981489347553435)

# ╔═╡ 63d6d0c4-331f-11eb-08b9-c90eb121d50d
function HLT(time_serie, α, β, l0, b0)
	N = length(time_serie)
	l_t = 0
	b_t = 0
	l_t_ = 0 
	pred = []
	
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
		
		push!(pred, y_pred)
	end
	
	return pred

end

# ╔═╡ 0ac392a0-3320-11eb-2488-eba0765eb0b6
fit = HLT(data, 0.8321, 0.0001, 15.57, 2.102)

# ╔═╡ 2f5dd4a4-3320-11eb-2de8-51e255bb5c9a
begin
plot(data, label="Data", legend=:topleft)
plot!(fit, label="Fitted")
end

# ╔═╡ cae17dee-3321-11eb-07b9-8f85a62c807f
function HLT_forecast(time_serie, α, β, l0, b0, n_pred)
	N = length(time_serie)
	l_t = 0
	b_t = 0
	l_t_ = 0 
	pred = []
	
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
	
	l_t = time_serie[end] * α + (l_t + b_t) * (1 - α)
	b_t = β * (l_t - l_t_) + (1 - β) * b_t
	
	for i in 1:n_pred
		y_pred = l_t + b_t * i
		push!(pred, y_pred)
	end
				
	return vcat(time_serie, pred)

end

# ╔═╡ 93203060-3326-11eb-23b5-794e82e57f95
data_forecasted = HLT_forecast(data, 0.8321, 0.0001, 15.57, 2.102, 15)

# ╔═╡ 2dab6d5c-3329-11eb-02b7-178ab2f62847
time_[end]

# ╔═╡ d79228f2-3328-11eb-3026-b3cafeaae72f
begin
plot(time_, data_forecasted[1:length(data)], label="Data", legend=:topleft)
	plot!(time_[end]:(time_[end]+15), data_forecasted[length(data):end], label="Forecast")
end

# ╔═╡ 4371b178-332b-11eb-0d12-4f1abd67c5ab
md"#### Holt’s linear damped trend method"

# ╔═╡ 54065c6c-332b-11eb-1f80-e78e7eb071a5
function Damped_HLT_loss(time_serie, α, β, l0, b0, ϕ)
	N = length(time_serie)
	l_t = 0
	b_t = 0
	l_t_ = 0 #Variable to save l(t-1)
	loss = 0
	
	for i in 1:(N)
		if i == 1
			l_t = l0
			b_t = b0
		else
			l_t = time_serie[i - 1] * α + (l_t + ϕ * b_t) * (1 - α) #b_t "is" b(t-1)
			b_t = β * (l_t - l_t_) + (1 - β) * ϕ * b_t
		end
		l_t_ = l_t
		
		y_pred = l_t + b_t * ϕ
		
		loss += (time_serie[i] - y_pred)^2
		
	end
	
	return loss
end

# ╔═╡ b77f61a4-332c-11eb-2750-9bff0be97c8c
function Damped_HLT_loss_(params, time_serie=data)
	return Damped_HLT_loss(time_serie, params[1], params[2], params[3], params[4], params[5])
end

# ╔═╡ e1bd2db4-332c-11eb-01d1-d371958e9a79
begin 
	low = [0., 0., 10., 1., 0.]
	up = [1., 1.,30., 5, 1.]
	initial = [0.5, 0.5, 15., 2., 0.5]
end

# ╔═╡ 047c6608-332d-11eb-037a-f7aa6a374cc1
res2 = optimize(Damped_HLT_loss_, low, up, initial);

# ╔═╡ 31d2a63a-332d-11eb-1f3d-5f1fcfb0cde1
optim__ = Optim.minimizer(res2)

# ╔═╡ 64450a86-332d-11eb-370a-19667407db8d
md"Values for phi near 1 converge to normal holt trend method"

# ╔═╡ 85639c14-332d-11eb-1044-73415337f39b
function Damped_HLT_forecast(time_serie, α, β, l0, b0, ϕ, n_pred)
	N = length(time_serie)
	l_t = 0
	b_t = 0
	l_t_ = 0 
	pred = []
	
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
	
	l_t = time_serie[end] * α + (l_t + b_t) * (1 - α)
	b_t = β * (l_t - l_t_) + (1 - β) * b_t
	
	phi = 0
	
	for i in 1:n_pred
		phi += ϕ^i
		y_pred = l_t + b_t * phi
		push!(pred, y_pred)
	end
				
	return vcat(time_serie, pred)

end

# ╔═╡ b90ce29a-332e-11eb-3e5f-b3d483b879c5
forecast_ = Damped_HLT_forecast(data, 0.8321, 0.0001, 15.57, 2.102, 0.96 , 15)

# ╔═╡ e6fc9c7c-332e-11eb-1510-b979481e089a
begin
plot(time_, forecast_[1:length(data)], label="Data", legend=:topleft)
plot!(time_[end]:(time_[end]+15), data_forecasted[length(data):end], label="Holt´s Forecast")
plot!(time_[end]:(time_[end]+15), forecast_[length(data):end], label="Damped Forecast")
end

# ╔═╡ d5db9dd0-3342-11eb-0745-87b8d80b885a
md"### Holt-Winters’ seasonal method

##### Additive method"

# ╔═╡ 0aa21d20-33f0-11eb-11b9-fb1ea9a9bcea
data_ = [42.20566, 24.64917, 32.66734, 37.25735, 45.24246, 29.35048, 36.34421, 41.78208, 49.27660, 31.27540, 37.85063, 38.83704, 51.23690, 31.83855, 41.32342, 42.79900, 55.70836, 33.40714, 42.31664, 45.15712, 59.57608, 34.83733, 44.84168, 46.97125, 60.01903, 38.37118, 46.97586, 50.73380, 61.64687, 39.29957, 52.67121, 54.33232, 66.83436, 40.87119, 51.82854, 57.49191, 65.25147, 43.06121, 54.76076, 59.83447, 73.25703, 47.69662, 61.09777, 66.05576]

# ╔═╡ 1c3c9a2e-33f0-11eb-361d-81717ef58687
plot(data_, legend=false)

# ╔═╡ 22fa37de-3343-11eb-39fe-c36faf16be1a
function HW_Seasonal_loss(time_serie, α, β, γ, l0, b0, s0, s1, s2, s3, m)
	N = length(time_serie)
	l_t = 0
	b_t = 0
	l_t_ = 0 #Variable to save l(t-1)
	b_t_ = 0 #Variable to save b(t-1)
	s_ = 0
	s = [s0, s1, s2, s3]
	
	loss = 0
	
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
		
		s[i%m + 1] = γ * (time_serie[i + 1] - l_t_ - b_t_) + (1 - γ) * s[i%m + 1]
		
		loss += (time_serie[i + 1] - y_pred)^2
		
	end
	
	return loss
end

# ╔═╡ 99ced330-33f5-11eb-0f66-bb2df596d736
Se = HW_Seasonal_loss(data_, 0.306, 0.0003, 0.426, 32.26, 0.70, 9.7, -9.31, -1.69, 1.31, 4)

# ╔═╡ cf5e6740-33f5-11eb-254f-533e6d15c6e5
rmse = sqrt(Se/44)

# ╔═╡ efe28838-33f1-11eb-37bd-fb8b43f8a9f5
function HW_Seasonal_loss_(params, time_serie=data_, m=4)
	return HW_Seasonal_loss(time_serie, params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8], params[9], 4)
end

# ╔═╡ 53b6dd82-33f2-11eb-044e-79a9055fc266
begin 
	low_ = [0., 0., 0., 25., 0., -10., -10., -10., -10.]
	up_ = [1., 1., 1., 40., 2, 10., 10., 10., 10.]
	initial_ = [0.5, 0.5, 0.5, 30., 1., 0., 0., 0., 0.]
end

# ╔═╡ d5348b3e-33f2-11eb-253e-79347d718fc4
res3 = optimize(HW_Seasonal_loss_, low_, up_, initial_);

# ╔═╡ 472c3aa6-34c6-11eb-023b-5b9e3267260e
optim3 = Optim.minimizer(res3)

# ╔═╡ 87c684b8-34c6-11eb-25b8-1f844bc80186
Se1 = HW_Seasonal_loss(data_, 0.2621981690589494, 2.4570483628963607e-15, 0.454665414630332, 32.49060505282863, 0.70109, 9.20323170365988, -9.188859536627708, -2.1398065690342136, 1.3591682337058317, 4)

# ╔═╡ 763818e8-33ee-11eb-004c-e73e58a5c17c
function HW_Seasonal(time_serie, α, β, γ, l0, b0, s0, m)
	N = length(time_serie)
	l_t = 0
	b_t = 0
	l_t_ = 0 #Variable to save l(t-1)
	b_t_ = 0 #Variable to save b(t-1)
	s_ = 0
	s = s0
	
	pred = []
	l_ = []

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
		push!(l_, l_t)
		
		s[i%m + 1] = γ * (time_serie[i + 1] - l_t_ - b_t_) + (1 - γ) * s[i%m + 1]
		
	end
	
	return pred, l_
end

# ╔═╡ 36163518-33f0-11eb-0ac9-356554e76ca4
season, l = HW_Seasonal(data_, 0.306, 0.0003, 0.426, 32.26, 0.70, [9.7, -9.31, -1.69, 1.31], 4)

# ╔═╡ 751b946e-33f1-11eb-1f8e-c1d5ae4e6a4f
begin
plot(season, label = "fitted")
plot!(data_, label = "data", legend=:topleft)
end

# ╔═╡ 37e19ba6-34c7-11eb-230f-171e09e872d7
md""

# ╔═╡ Cell order:
# ╟─97ceb2ca-2f5a-11eb-2a7b-cd339b881ea1
# ╠═f03467ca-2f5a-11eb-1d53-f3d95c4267db
# ╠═2cc65384-3009-11eb-26f9-9f7c099e6114
# ╠═bc7a1146-3010-11eb-1b31-d940642ff8aa
# ╠═d3b45e90-30e6-11eb-27f4-bd7ac92ef892
# ╠═30dd4d7c-30e7-11eb-3480-d5721718f1b3
# ╠═340dc8bc-3017-11eb-04ac-19fc0e45d6af
# ╠═afda21c6-30c5-11eb-141a-bbc93204323b
# ╠═1ade257e-3019-11eb-1629-cb9a519f86fb
# ╠═98ef988a-3019-11eb-1461-f38c5714521f
# ╠═acd8fb36-3019-11eb-2a51-d34ed19b2646
# ╠═a8985a28-301a-11eb-13fb-3540d83641bb
# ╠═a131db1a-301a-11eb-293b-e128292362f2
# ╠═ae00d74a-30cb-11eb-3997-0f1a1c55a2ff
# ╠═3aa01418-30cc-11eb-3ada-ddca54664fb8
# ╠═b4632228-30cb-11eb-0380-65d3a2da7975
# ╠═4f10d0be-30e4-11eb-366c-9f9a574c70ce
# ╠═4619edaa-30ea-11eb-3a4c-6721d7443aa0
# ╠═e4a13032-30ea-11eb-2f28-672a793137f5
# ╠═118c8542-30b9-11eb-0e73-0f90ef1da61e
# ╠═1cebcf7a-30ec-11eb-0697-f94fe4db2430
# ╟─df699004-30d7-11eb-18e8-33dc21caf77a
# ╠═2230b29c-30f0-11eb-2e02-197ad35d3100
# ╠═ac0f3dfe-30f9-11eb-17b1-7729d039a6b9
# ╠═1cd57bf6-3317-11eb-3b83-9f1872df41c9
# ╠═fa5ffb46-3316-11eb-3d31-978b6c604077
# ╠═06993716-30fa-11eb-0e0a-1f84abee8bf6
# ╠═7674fda8-30fb-11eb-176b-e5999af211fe
# ╠═a71787f4-30fc-11eb-39db-e564e728c3db
# ╠═f9396bd8-30fc-11eb-2c96-f95f493a4270
# ╠═a4c65e44-331d-11eb-1f52-77139935920a
# ╠═e34f28a8-331d-11eb-398c-adc71cbd3cb5
# ╠═63d6d0c4-331f-11eb-08b9-c90eb121d50d
# ╠═0ac392a0-3320-11eb-2488-eba0765eb0b6
# ╠═2f5dd4a4-3320-11eb-2de8-51e255bb5c9a
# ╠═cae17dee-3321-11eb-07b9-8f85a62c807f
# ╠═93203060-3326-11eb-23b5-794e82e57f95
# ╠═2dab6d5c-3329-11eb-02b7-178ab2f62847
# ╠═d79228f2-3328-11eb-3026-b3cafeaae72f
# ╟─4371b178-332b-11eb-0d12-4f1abd67c5ab
# ╠═54065c6c-332b-11eb-1f80-e78e7eb071a5
# ╠═b77f61a4-332c-11eb-2750-9bff0be97c8c
# ╠═e1bd2db4-332c-11eb-01d1-d371958e9a79
# ╠═047c6608-332d-11eb-037a-f7aa6a374cc1
# ╠═31d2a63a-332d-11eb-1f3d-5f1fcfb0cde1
# ╟─64450a86-332d-11eb-370a-19667407db8d
# ╠═85639c14-332d-11eb-1044-73415337f39b
# ╠═b90ce29a-332e-11eb-3e5f-b3d483b879c5
# ╠═e6fc9c7c-332e-11eb-1510-b979481e089a
# ╟─d5db9dd0-3342-11eb-0745-87b8d80b885a
# ╠═0aa21d20-33f0-11eb-11b9-fb1ea9a9bcea
# ╠═1c3c9a2e-33f0-11eb-361d-81717ef58687
# ╠═22fa37de-3343-11eb-39fe-c36faf16be1a
# ╠═99ced330-33f5-11eb-0f66-bb2df596d736
# ╠═cf5e6740-33f5-11eb-254f-533e6d15c6e5
# ╠═efe28838-33f1-11eb-37bd-fb8b43f8a9f5
# ╠═53b6dd82-33f2-11eb-044e-79a9055fc266
# ╠═d5348b3e-33f2-11eb-253e-79347d718fc4
# ╠═472c3aa6-34c6-11eb-023b-5b9e3267260e
# ╠═87c684b8-34c6-11eb-25b8-1f844bc80186
# ╠═763818e8-33ee-11eb-004c-e73e58a5c17c
# ╠═36163518-33f0-11eb-0ac9-356554e76ca4
# ╠═751b946e-33f1-11eb-1f8e-c1d5ae4e6a4f
# ╠═37e19ba6-34c7-11eb-230f-171e09e872d7
