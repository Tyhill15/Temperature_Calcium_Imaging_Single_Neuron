close all
rate_per_min_N2 = [];
rate_per_min_oy21 = [];


for i = 1:length(N2)-1
    rate_per_min_N2(end+1) = (N2(i+1) - N2(i))/(time(i+1)-time(i))*60;
    rate_per_min_oy21(end+1) = (oy21(i+1) - oy21(i))/(time(i+1)-time(i))*60;
end
plot(time(2:end), rate_per_min_N2, 'k', 'LineWidth', 2)
hold on
plot(time(2:end), rate_per_min_oy21, 'r', 'LineWidth', 2)