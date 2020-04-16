clear all 
close all
filename = '/Volumes/chinhome/hbell/imaging/Sonny/AFD/srtx-1p_YC360/Figures/upshift_cmk1'

[num,txt,raw] = xlsread(filename)

N2_data = [];
oy21_data = [];
N2_sems = [];
N2_stds = [];
oy21_sems = [];
oy21_stds = [];

for i = 1:length(num)
    loop_data = num(3:end,i);
    data_length = sum(~isnan(loop_data(:)));
    if num(1,i) == 2
        oy21_data(end+1) = nanmean(loop_data);
        oy21_stds(end+1) = nanstd(loop_data);
        oy21_sems(end+1) = nanstd(loop_data)/sqrt(data_length);
    elseif num(1,i) == 1
        N2_data(end+1) = nanmean(loop_data);
        N2_stds(end+1) = nanstd(loop_data);
        N2_sems(end+1) = nanstd(loop_data)/sqrt(data_length);
    end
end

y_N2 = N2_data';
y_oy21= oy21_data';
x = unique(num(2,:))'

% lower_bound = [-7 150 15 -10 10]
% upper_bound = [-3 500 25 0 20]
exp1_lower = [0 0 -inf];
exp1_upper = [1 inf inf];

s2_N2 = fitoptions('Method','NonlinearLeastSquares','StartPoint',[3 1 15 2 0.1], 'Weights', N2_stds)
s2_oy21 = fitoptions('Method','NonlinearLeastSquares','StartPoint',[3 1 15 2 0.1], 'Weights', oy21_stds)
s1_N2 = fitoptions('Method','NonlinearLeastSquares','StartPoint',[3 1 15], 'Lower', exp1_lower, 'Upper', [inf inf inf], 'Weights', N2_stds);
s1_oy21 = fitoptions('Method','NonlinearLeastSquares','StartPoint',[3 1 15], 'Lower', exp1_lower, 'Upper', [inf inf inf], 'Weights', oy21_stds);

pmexp2_N2 = fittype('a*(1-exp(-x/b))+c+d*(1-exp(-x/e))','options',s2_N2);
pmexp2_oy21 = fittype('a*(1-exp(-x/b))+c+d*(1-exp(-x/e))','options',s2_oy21);

pmexp1_N2 = fittype('a*exp(-x/b)+c','options',s1_N2);
pmexp1_oy21 = fittype('a*exp(-x/b)+c','options',s1_oy21);
% figure(1)
% [fo1 go1] = fit(x,y_1,'exp2')%%%%%taken from cflibhelp/routed to doc from help
% plot(fo1)
% hold on
% plot(x,y_1, 'o')

position = [200 200 1000 800]
set(0, 'DefaultFigurePosition', position);


figure(1)
[fo1_N2 go1_N2] = fit(x,y_N2,pmexp1_N2)
[fo1_oy21 go1_oy21] = fit(x,y_oy21,pmexp1_oy21)
H1 = plot(fo1_N2)
set(H1, 'LineWidth', 2, 'Color', 'k')
hold on
H2 = plot(fo1_oy21)
set(H2, 'LineWidth', 2, 'Color', 'r')
hold on
h = errorbar(x, y_N2, N2_sems, 'o','MarkerFaceColor', 'k')
set(h,'color','k')
hold on
h1 = errorbar(x, y_oy21, oy21_sems, 'o','MarkerFaceColor', 'r')
set(h1,'color','r')
hleg1 = legend('N2','oy21');
set(hleg1,'FontSize',16)
xlabel('Time(min)', 'FontSize', 30)
ylabel('Temperature(C)', 'FontSize', 30)


figure(2)
[fo2_N2 go2_N2] = fit(x,y_N2,pmexp2_N2)
[fo2_oy21 go2_oy21] = fit(x,y_oy21,pmexp2_oy21)
H1 = plot(fo2_N2)
set(H1, 'LineWidth', 2, 'Color', 'k')
hold on
H2 = plot(fo2_oy21)
set(H2, 'LineWidth', 2, 'Color', 'r')
hold on
h = errorbar(x, y_N2, N2_sems, 'o','MarkerFaceColor', 'k')
set(h,'color','k')
hold on
h1 = errorbar(x, y_oy21, oy21_sems, 'o','MarkerFaceColor', 'r')
set(h1,'color','r')
hleg2 = legend('N2','oy21');
xlabel('Time(min)', 'FontSize', 20)
ylabel('Temperature(C)', 'FontSize', 20)


    
    
    
    
    
    
    