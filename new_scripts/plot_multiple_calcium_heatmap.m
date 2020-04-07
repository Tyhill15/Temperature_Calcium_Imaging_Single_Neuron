% This script will plot a heatmap from any group of blccrt or GCaMP_Analysis
% or FRET_Analysis files. It will prompt you for how long your plot should be, in frames.
% FRAMES, NOT SECONDS. Enter the number of frames you want plotted and a
% heat map of that length will be plotted. It does some minor smoothing for
% prettiness.
clear; close all
dir_of_files = uigetdir;
D = dir(dir_of_files);
s = what(dir_of_files);
files = s.mat;
GC = [];
c = 1;
prompt = 'How long is your experiment(in frames)?';
exp_length = input(prompt)

filename = 'heatmap'
for i = 1:numel(files)
    load([dir_of_files '/' char(files(i))]);
    if exist('BLC_delta_F')==1
        GC(c).delta_F = smooth(BLC_raw_delta_F(1:exp_length), 10, 'loess')';
        GC(c).temp = temp(1:exp_length);
    elseif exist('blc')==1
        GC(c).delta_F = smooth(blc(1:exp_length), 10, 'loess')';
        GC(c).temp = resampletemp(1:exp_length);
    else    
        GC(c).delta_F = smooth(delta_F(1:exp_length), 10, 'loess')';
        GC(c).temp = Temperature(1:exp_length);
    end
    c = c + 1;
end

all_traces = vertcat(GC.delta_F);

%colormap('hot')
h = imagesc(all_traces,[0 max(max(all_traces))]);
xax = get(gca,'XTick');
rt = xax / 2;
set(gca,'XTicklabel',rt)
set(gca,'YTickLabel',[])
set(gca,'XTickLabel',[])
cb = colorbar;
date_proc = datevec(now);

saveas(gcf,[dir_of_files filesep filename  '.fig']);
saveas(gcf,[dir_of_files filesep filename '.jpg'],'jpg')
print(gcf,[dir_of_files filesep filename '.eps'],'-depsc2')

