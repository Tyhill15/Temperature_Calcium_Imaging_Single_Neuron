clear; close all
dir_of_files = uigetdir;
D = dir(dir_of_files);
s = what(dir_of_files);
files = s.mat;
c = 1;

for b = 1:numel(files)
    load([dir_of_files '/' char(files(b))]);
    data(c).delta_F = delta_F;
    data(c).temp = Temperature;
    c = c+1;
end

stacked_delta_F = catpad(1, data.delta_F)
h = imagesc(stacked_delta_F,[0 max(stacked_delta_F)]);
