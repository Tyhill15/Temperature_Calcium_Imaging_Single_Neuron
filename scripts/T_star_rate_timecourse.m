clear; close all
dir_of_files = uigetdir;
D = dir(dir_of_files);
s = what(dir_of_files);
files = s.mat;
b = 1;
for x = 1:numel(files)
    load([dir_of_files '/' char(files(x))]);
    name = char(files(x));
    k = strfind(name, 'T_star_numbers');
    data(b).geno = name(k+15:end-12);
    data(b).timepoint = str2num(name(end-10:end-7));
    data(b).T_star = mean(T_star_temps);
    data(b).sem = nanstd(T_star_temps)/sqrt(length(T_star_temps));
    data(b).n = length(T_star_temps);
    b = b+1;
end
rate_per_min = [];
rate_per_60min = [];
T = [data.T_star];
time_points = [data.timepoint]
for z = 2:length(T)
    rate_per_min(end+1) = (T(z)-T(z-1))/(time_points(z)-time_points(z-1));
    rate_per_60min(end+1) = (T(z)-T(z-1))/(time_points(z)-time_points(z-1))*60;
end

x = time_points';
y = T';
figure(1)
[fo1 go1] = fit(x,y,'exp1')%%%%%taken from cflibhelp/routed to doc from help
plot(fo1)
hold on
plot(x,y, 'o')

s2 = fitoptions('Method','NonlinearLeastSquares','StartPoint',[3 1 15 2 0.1]);
s1 = fitoptions('Method','NonlinearLeastSquares','StartPoint',[5 1 15]);


pmexp2 = fittype('a*(1-exp(-x/b))+c+d*(1-exp(-x/e))','options',s2);
pmexp1 = fittype('a*(1-exp(-x/b))+c','options',s1);

[fo2 go2] = fit(x,y,pmexp2)
plot(fo2)
hold on
plot(x,y, 'o')

figure(3)
[fo3 go3]  = fit(x,y,pmexp1)
plot(fo3,'g')
hold on
plot(x,y, 'o')



% xx = time_points(2:end)';
% yy = rate_per_60min';
% figure(2)
% [fo1 go1] = fit(xx,yy,'exp1')%%%%%taken from cflibhelp/routed to doc from help
% plot(fo1)
% hold on
% plot(xx,yy, 'o')
% figure(2)
% s2 = fitoptions('Method','NonlinearLeastSquares','StartPoint',[3 1 15 2 0.1]);
% s1 = fitoptions('Method','NonlinearLeastSquares','StartPoint',[5 1 15]);
% 
% pmexp2 = fittype('a*(1-exp(-x/b))+c+d*(1-exp(-x/e))','options',s2);
% pmexp1 = fittype('a*(1-exp(-x/b))+c','options',s1);
% 
% [fo2 go2] = fit(x,y,pmexp2)
% plot(fo2)
% hold on
% plot(x,y, 'o')
% 
% figure(3)
% [fo3 go3]  = fit(x,y,pmexp1)
% plot(fo3,'g')
% hold on
% plot(x,y, 'o')
% 
