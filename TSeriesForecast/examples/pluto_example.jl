### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ aaabfda4-61a4-11eb-0b5a-9bb0c44620be
begin
	using TSeriesForecast: SES, HLT, HW, fit, forecast
	using Plots
end

# ╔═╡ 4b665fac-61a8-11eb-3e58-77f064b6dbbf
md"
## **TSeriesForecast.jl**: Package demonstration

First, we import the functions we are going to use in the demostration, and the Plots.jl library for plotting.
"

# ╔═╡ a216a1ae-61a8-11eb-2b11-d5f6d5cec96a
md"
---
#### Holt's Linear Trend (HLT) method
We load some example time series to perform a forecast. The **Holt's Linear Trend method** will be applied.
"

# ╔═╡ 18c2c746-61a5-11eb-246a-b3962375d7db
data_1 = [17.5534, 21.8601, 23.8866, 26.9293, 26.8885, 28.8314, 30.0751, 30.9535, 	30.1857, 31.5797, 32.577569, 33.477398, 39.021581, 41.386432, 41.596552, 			 44.657324, 46.951775, 48.728837,51.488427,50.026967, 60.640913,63.3603103378, 66.355274, 68.197955, 68.1232376693, 69.7793454797, 72.597700806]

# ╔═╡ bd0beaca-61ab-11eb-12de-554a102bae37
md"
We first instantiate the model class (or struct) corresponding to Holt's Linear Method, with ```HLT()```. If no arguments are passed, all initial model parameters are initialized at $0$.

The ```fit()``` method is applied to the instantiated model and the data to find the optimal values of the model parameters. With these, we then proceed to make our prediction with the ```forecast()```function, specifying how many steps into the future we want the prediction to be made.
"

# ╔═╡ 06d4cba0-61a6-11eb-1dea-2dcb6fafca3b
begin
	model_1 = HLT()
	model_1 = fit(model_1, data_1)
	predicted_1 = forecast(model_1, data_1, 5)
end

# ╔═╡ 4ada8b1e-61a6-11eb-0760-458e2ae3dadf
begin
	plot(vcat(data_1, predicted_1), legend=false, lw=3, arrow=true, title="Holt's Linear Trend method forecast")
	vline!([length(data_1)], lw=2, alpha=0.7)
	xlabel!("Time (days)")
	ylabel!("Some quantity (ua)")
end

# ╔═╡ 56d06ac4-61b0-11eb-0f0b-e5dbba35822b
md"
---
#### Simple Exponential Smoothing (SES) method
Following the same schema, we now load some other data. In this example, wi will use **Simple Exponential Smoothing method**.
"

# ╔═╡ a5a100a0-61a6-11eb-29c1-b1de684332db
data_2 = [445.364098092, 453.195010427, 454.409641012, 422.378905779, 456.037121728, 440.386604674, 425.194372519, 486.20517351, 500.429086073, 521.27590917, 508.947617045, 488.888857729, 509.870574978, 456.722912348, 473.816602915, 
525.950870565, 549.833807597, 542.340469826]

# ╔═╡ 7dc66732-61b0-11eb-3082-cf2c7a7af91b
md"
The SES model makes flat forecasts. This means that all the forecasted values are equal to the first forecasted value. These forecasts will only be suitable if the time series has no trend or seasonal component.
"

# ╔═╡ c4e51172-61a6-11eb-1bb9-3bd8a3489eb5
begin
	model_2 = SES()
	model_2 = fit(model_2, data_2)
	predicted_2 = forecast(model_2, data_2, 10)
end

# ╔═╡ d4ebc5de-61a6-11eb-109f-8dedb6b87aca
begin
	plot(vcat(data_2, predicted_2), label=false, lw=3, title="Simple Exponential Smoothing method forecast")
	vline!([length(data_2)], label=false, lw=2, alpha=0.7)
	xlabel!("Time (days)")
	ylabel!("Some quantity (ua)")
end

# ╔═╡ 45de8cd6-61b1-11eb-2b05-bb35b78757ff
md"
---
#### Holt-Winters' (HW) seasonal method
We follow an analogous methodology to the others examples, for the **Holt-Winters' method**. In this particular case, we will instantiate the ```HW()``` model class with some parameters, hence, the ```fit()``` method won't be necessary.
"

# ╔═╡ f5f950d4-61a6-11eb-0fc6-e924ca85d1dc
data_3 = [42.2056638559382, 24.6491713296294, 32.6673351386246, 37.2573540134764, 45.2424602720635, 29.3504812742718, 36.3442072775119, 41.7820813647366, 49.2765984345619, 31.2754013898459, 37.8506254947152, 38.83704413019, 51.236900336137, 31.8385516171558, 41.3234212576972, 42.7990033724349, 55.708358364385, 33.4071449171312, 42.3166379718116, 45.1571225674731, 59.5760799633937, 34.8373301595328, 44.8416807241332, 46.971249602779, 60.0190309438716, 38.3711785132276, 46.9758641283558, 50.7337964560878, 61.6468731860574, 39.2995693656296, 52.6712090814052, 54.3323168946667, 66.834358381339, 40.8711884667851, 51.8285357927739, 57.4919099342262, 65.2514698518726, 43.0612082202828, 54.7607571288007, 59.8344749355003, 73.2570274672009, 47.6966237298, 61.0977680206996, 66.0557612187001]

# ╔═╡ 94dd9624-61a7-11eb-314e-63f1553ba664
begin
	model_3 = HW(4, 0.306, 0.0003, 0.426, 32.26, 0.70, [9.7, -9.31, -1.69, 1.31])
	predicted_3 = forecast(model_3, data_3, 5)
end

# ╔═╡ 1025c720-61a8-11eb-3460-2ddbd4092a61
begin
	plot(vcat(data_3, predicted_3), label=false, lw=3, title="Holt-Winters' seasonality method", arrow=true)
	vline!([length(data_3)], label=false, lw=2, alpha=0.7)
	xlabel!("Time (days)")
	ylabel!("Some quantity (ua)")
end

# ╔═╡ 2438daea-61a8-11eb-0852-25ac9ab6d0e4
md"
---
##### Summing up:
```julia
model = XXX() # This can be any forecasting model
model = fit(model, data)
predicted = forecast(model, data, 5)
```
"

# ╔═╡ 05ef4782-61ac-11eb-3772-efd50f0108e2
md"
### References
* [Forecasting: Principles and Practice](https://otexts.com/fpp2/ses.html)
"

# ╔═╡ Cell order:
# ╟─4b665fac-61a8-11eb-3e58-77f064b6dbbf
# ╠═aaabfda4-61a4-11eb-0b5a-9bb0c44620be
# ╟─a216a1ae-61a8-11eb-2b11-d5f6d5cec96a
# ╠═18c2c746-61a5-11eb-246a-b3962375d7db
# ╟─bd0beaca-61ab-11eb-12de-554a102bae37
# ╠═06d4cba0-61a6-11eb-1dea-2dcb6fafca3b
# ╠═4ada8b1e-61a6-11eb-0760-458e2ae3dadf
# ╟─56d06ac4-61b0-11eb-0f0b-e5dbba35822b
# ╠═a5a100a0-61a6-11eb-29c1-b1de684332db
# ╟─7dc66732-61b0-11eb-3082-cf2c7a7af91b
# ╠═c4e51172-61a6-11eb-1bb9-3bd8a3489eb5
# ╠═d4ebc5de-61a6-11eb-109f-8dedb6b87aca
# ╟─45de8cd6-61b1-11eb-2b05-bb35b78757ff
# ╠═f5f950d4-61a6-11eb-0fc6-e924ca85d1dc
# ╠═94dd9624-61a7-11eb-314e-63f1553ba664
# ╠═1025c720-61a8-11eb-3460-2ddbd4092a61
# ╟─2438daea-61a8-11eb-0852-25ac9ab6d0e4
# ╟─05ef4782-61ac-11eb-3772-efd50f0108e2
