function [estimates, model] = fitCurveA(xdata, ydata, p)
% Call fminsearch with a random starting point.
% Call fminsearch with a random starting point.
start_point = [50];
model = @expfun;
estimates = fminsearch(model, start_point);
estimates = fminsearch(model, estimates);
% expfun accepts curve parameters as inputs, and outputs sse,
% the sum of squares error for (A*exp(-lambda * xdata)) - ydata, 
% and the FittedCurve. FMINSEARCH only needs sse, but we want to 
% plot the FittedCurve at the end.
    function [sse, FittedCurve] = expfun(A)
        FittedCurve = A .* exp(-p * xdata); 
        ErrorVector = FittedCurve - ydata;
        sse = sum(ErrorVector .^ 2);
    end
end