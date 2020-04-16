clear all;
close all;
[filename pathname] = uigetfile
load ([pathname filename]) 
c = 1;

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

stacked_frames = vertcat(track.frames);
stacked_x = vertcat(track.x);
stacked_y = vertcat(track.y);
stacked_temps = vertcat(track.temps);

time_start = 300;
time = time_start:2099;
samples = length(time);
mean_temp = nanmean(stacked_temps);
mean_temp_plot = mean_temp(time_start:end);
sem_temp = nanstd(stacked_temps);
sem_temp_plot = sem_temp(time_start:end);

% figure(1);
% hold on;
% line( [(time); (time)], [(mean_temp_plot - sem_temp_plot); (mean_temp_plot + sem_temp_plot)], 'Color', [.8 .8 1]);
% hold on;
% H1 = plot(time, mean_temp_plot);
% set(H1, 'LineWidth', 5);
movie_file = 'timecourse.avi';


mov = avifile([pathname movie_file])


for m = 300:7:length(stacked_frames(1,:))
    figure(1);
    clf
    for k = 1:length(stacked_frames(:,1))
        ax2 = scatter(stacked_temps(k,m), stacked_y(k,m),'o');
        hold on
        if k == 1
        set(gca,'XLim',[23.5 28.5], 'YLim', [0 450]);
        end
        
    end
    F=getframe;
    mov=addframe(mov, F);
   
end
mov=close(mov);




    

    