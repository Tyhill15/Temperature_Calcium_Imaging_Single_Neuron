clear all; close all
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
rate_per_10min = [];
rate_per_60min = [];
T = [data.T_star];
time_points = [data.timepoint];
for z = 2:length(T)
    rate_per_min(end+1) = (T(z)-T(z-1))/(time_points(z)-time_points(z-1));
    rate_per_10min(end+1) = (T(z)-T(z-1))/(time_points(z)-time_points(z-1))*10;
    rate_per_60min(end+1) = (T(z)-T(z-1))/(time_points(z)-time_points(z-1))*60;
end

k = strfind(dir_of_files, 'stats');
file_to_save = (['Rate_change_permin_', dir_of_files(k+6:end)]);
save([dir_of_files '/' file_to_save], 'data', 'rate_per_min', 'rate_per_10min', 'rate_per_60min', 'time_points');

%plot(time_points(2:end), rate) 
    
    
    
    
