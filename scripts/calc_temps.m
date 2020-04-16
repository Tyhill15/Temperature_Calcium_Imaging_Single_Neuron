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
    temps = T_star_temps';
    data(b).geno = name(k+15:end-4);
    data(b).temps = temps;
    data(b).mean_temps = nanmean(temps);
    data(b).sem = nanstd(temps)/sqrt(length(temps));
    data(b).n = length(temps);
    b = b+1;
end
{data.geno}
all_data = catpad(2, data.temps)
struct2cell(data)





