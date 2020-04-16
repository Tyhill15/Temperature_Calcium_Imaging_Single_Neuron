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
    track(i).run_indx = data_summary.tr(i).run_indx + data_summary.tr(i).f(1);
    track(i).run_dx = data_summary.tr(i).run_dx;
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

time_start = 300; %%%change this if desired
time = time_start:2099;
samples = length(time);
mean_temp = nanmean(stacked_temps);
mean_temp_plot = mean_temp(time_start:end);
sem_temp = nanstd(stacked_temps);
sem_temp_plot = sem_temp(time_start:end);

time_down = zeros(length(track), length(stacked_frames));
time_up = zeros(length(track), length(stacked_frames));

for m = 1:length(track)
    for z = 1:length(track(m).run_indx(:,1))
        time_point = track(m).run_indx(z,2);
        run_time = track(m).run_indx(z,2) - track(m).run_indx(z,1);
        if run_time < 6
            run_time = 0;
        end
        
        if track(m).run_dx(z) < 0
            time_down(m, time_point) = time_down(m, time_point) + run_time;
        elseif track(m).run_dx(z) > 0
            time_up(m, time_point) = time_down(m, time_point) + run_time;
        end
    end
end

sum_time_down = sum(time_down);
sum_time_up = sum(time_up);
total_time = sum_time_down + sum_time_up;

neg_therm_index = [];

for b = 1:length(total_time)
    neg_therm_index(b) = sum((sum_time_down(1:b) - sum_time_up(1:b))) ./ sum(total_time(1:b));
end
plot(neg_therm_index)
    









% figure(1);
% hold on;
% line( [(time); (time)], [(mean_temp_plot - sem_temp_plot); (mean_temp_plot + sem_temp_plot)], 'Color', [.8 .8 1]);
% hold on;
% H1 = plot(time, mean_temp_plot);
% set(H1, 'LineWidth', 5);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% movie_file = 'timecourse.avi';
% 
% 
% mov = avifile([pathname movie_file])
% 
% figure(2);
% 
% for m = 300:3:length(stacked_frames(1,:))
%    clf
% %     for k = 300:length(stacked_frames(:,1))
%    scatter(stacked_temps(:,m), stacked_y(:,m),'o');
%    axis([18 23 0 450])
%    pause(0.01)    
% %     end
% %     F=getframe;
% %     mov=addframe(mov, F);
%    
% end
% mov=close(mov);
% bins = 50;
% figure(3)
% for b = 300:length(stacked_temps)
%     clf
%     hist(stacked_temps(:,b), bins)
%     pause(0.01)
% end
% 
%     