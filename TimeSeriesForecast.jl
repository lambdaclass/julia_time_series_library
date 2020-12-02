module TimeSeriesForecast
    using Optim
    
    function SES(time_serie, α)
        """Given a time serie and a value for alpha, returns the forecasted
        next point"""
        y_pred = 0
        N = length(time_serie)
        
        for i in 1:N
            y_pred += time_serie[N - (i - 1)] * (α * ((1-α)^(i-1)))
        end
        
        return y_pred
    end	

    function SES_weight(α, l0, time_serie)
        """Given a time serie, an alpha and a starting point, returns an array 
        with the predicted values of each point of the time serie"""
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

    function SES_weight_loss(α, l0, time_serie)
        """Given a time serie, an alpha and a starting point, calculates the predicted
        value of each point and calculate de error. Return the total error (loss)"""
        loss = 0
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

    