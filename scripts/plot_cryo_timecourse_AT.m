% clear all;
% close all;
% [filename pathname] = uigetfile
% load ([pathname filename]) 
POI = 300;% make this whichever time point(frame) you want to see%


for i = 1:length(data_summary.tr)
    track(i).frames = data_summary.tr(i).f;
    track(i).start = data_summary.tr(i).f(1);
    track(i).end = data_summary.tr(i).f(end);
    track(i).x = data_summary.tr(i).x;
    track(i).y = data_summary.tr(i).y;
    track(i).temps = interp1(linspace(data_summary.tr(i).min_edge,data_summary.tr(i).max_edge),linspace(data_summary.tr(i).min_T,data_summary.tr(i).max_T),data_summary.tr(i).x);
end

for j = 1:length(track)
    starting_frame = track(j).start;
    ending_frame = track(j).end;
    start_pad = nan(1, starting_frame-1);
    end_pad = nan(1, 2099-(ending_frame));
    track(j).frames = [start_pad track(j).frames' end_pad];
    track(j).x = [start_pad track(j).x' end_pad];
    track(j).y = [start_pad track(j).y' end_pad];
    track(j).temps = [start_pad track(j).temps' end_pad];
end

track_plot_y = [];
track_plot_temps = [];
for k = 1:length(track)
    track_plot_y(end+1) = track(k).y(POI);
    track_plot_temps(end+1) = track(k).temps(POI);
end
figure();
for j = 1:length(track)
    scatter(track_plot_temps(j), track_plot_y(j), 'o');
    hold on
    if j == 1
        set(gca, 'XLim', [23.5 28.5])
    end
        
end
    