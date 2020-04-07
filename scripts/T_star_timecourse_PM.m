clear; close all
dir_of_files = uigetdir;
D = dir(dir_of_files);
s = what(dir_of_files);
files = s.mat;
GC = [];
c = 1;
for m = 1:numel(files)
    load([dir_of_files '/' char(files(m))]);
    name = char(files(m));
    k = strfind(name, 'min');
    
    T_star(c).temps = T_star_temps;
    T_star(c).mean = mean(T_star_temps);
    T_star(c).sem = nanstd(T_star_temps) ./ sqrt(size(T_star_temps,1));
    T_star(c).times = str2num(name(k-4:k-1));
    T_star(c).geno = name(k-7:k-6);
    c = c+1;
end
T_star_times = [T_star.times];
T_star_mean = [T_star.mean];
T_star_sem = [T_star.sem];

x = T_star_times';
y = T_star_mean';
figure(1)
[fo1 go1] = fit(x,y,'exp1')%%%%%taken from cflibhelp/routed to doc from help
plot(fo1)
hold on
plot(x,y, 'o')

figure(2)
s2 = fitoptions('Method','NonlinearLeastSquares','StartPoint',[3 1 15 2 0.1]);
s1 = fitoptions('Method','NonlinearLeastSquares','StartPoint',[5 1 15]);

pmexp2 = fittype('a*(1-exp(-x/b))+c+d*(1-exp(-x/e))','options',s2);
pmexp1 = fittype('a*(1-exp(-x/b))+c','options',s1);

[fo2 go2] = fit(x,y,pmexp1)
plot(fo2)
hold on
plot(x,y, 'o')

figure(3)
[fo3 go3]  = fit(x,y,pmexp1)
plot(fo3,'g')
hold on
plot(x,y, 'o')
