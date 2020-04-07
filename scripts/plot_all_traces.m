clear; close all
dir_of_files = uigetdir;
D = dir(dir_of_files);
s = what(dir_of_files);
files = s.mat;
c = 1;

for m = 1:numel(files)
    load([dir_of_files '/' char(files(m))]);
    filename = char(files(m));
    subplot(3, 2, m)
    plot(delta_F)
end
