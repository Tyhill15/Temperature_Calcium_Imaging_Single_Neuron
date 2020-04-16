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
    amps = nanmean(total_fret_amps)';
    data(b).geno = name(k+15:end-4);
    data(b).amps = amps;
    data(b).mean_amps = nanmean(amps);
    data(b).sem = nanstd(amps)/sqrt(length(amps));
    data(b).n = length(amps);
    b = b+1;
end
struct2cell(data)











