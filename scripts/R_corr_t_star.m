% clear all;
% close all;
% [file pathname] = uigetfile
% load ([pathname file]) 
samples = 1:length(delta_F);
del_F = smooth(delta_F, 25, 'loess')';
temp = smooth(Temperature, 25, 'loess')';
lagged_R = [];
lagged_P = [];
for i = 1:25
    pad = nan(1, i)
    padded_temp = [pad temp(1:end-length(pad))];
    [R,P]=corrcoef(padded_temp, del_F, 'rows', 'complete');
    lagged_R(end+1) = R(1,2);
    lagged_P(end+1) = P(1,2);
    
end
lag = find(lagged_R == max(lagged_R));
lag_pad = nan(1, lag);
corrected_del_F = [del_F(length(lag_pad)+1:end) lag_pad];

%plotyy(samples, temp, samples, corrected_del_F);
window_P = nan(1,9);
window_R = nan(1,9);
for j = 10:length(samples)-9
    [loop_R,loop_P] = corrcoef(temp(j-9:j+9), corrected_del_F(j-9:j+9));
    window_R(end+1) = loop_R(1,2);
    window_P(end+1) = loop_P(1,2);
  
end
window_R(end+84) = nan;
window_P(end+84) = nan;
smooth_window_R = smooth(window_R, 25, 'loess');
smooth_window_P = smooth(window_P, 25, 'loess');
smooth_window_R = [smooth_window_R' nan(1, 30)];
smooth_window_R(1:9) = nan;
smooth_window_P = [smooth_window_P' nan(1, 30)];
smooth_window_P(1:9) = nan;
plot(smooth_window_R)
is_response = nan(1, length(samples));
for k = 11:length(samples)
    if smooth_window_R(k) > 0.9
        is_response(k) = 1;
    end
    if mean(smooth_window_R(k:k+30)) > 0.65
        is_response(k) = is_response(k) + 1;
    end
    if nanmean(smooth_window_P(k:k+9)) < 0.05
        is_response(k) = is_response(k) + 1;
    end
    if max(smooth_window_R(k:k+75)) - min(smooth_window_R(k:k+30)) < 1
        is_response(k) = is_response(k) + 1;
    end
    if min(smooth_window_R(k:k+30)) > -0.2
        is_response(k) = is_response(k) + 1;
    end
    if abs(corrected_del_F(k)) > abs(3*mean(corrected_del_F(k-10:k)))
        is_response(k) = is_response(k) + 1;
    end
    %if 
end
T_set = find(is_response == 6);
T_star_time = T_set(1);
T_star_temp = Temperature(T_star_time)
figure(2)
h = plotyy(samples, temp, samples, corrected_del_F);
yL = get(gca,'YLim');
line([T_star_time T_star_time],yL,'Color','r');




