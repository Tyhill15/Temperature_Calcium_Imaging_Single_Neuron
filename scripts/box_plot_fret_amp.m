clear all
close all
disp('Select a directory with only T_star_numbers.....mat files to analyze')
pause(2)
dir_of_file = uigetdir;%% prompt for directory choice
Dir = dir(dir_of_file);
c =1;
for x = 3:(length(Dir))
     if(isequal(Dir(x).name(end-3:end),'.mat'))
          load([dir_of_file filesep Dir(x).name]);%% pulls out .mat files
          k = strfind(Dir(x).name, 'numbers');
          fig(x).name = Dir(x).name(k+8:end-4);
          fig(x).data = total_fret_amps;
     end
end
fig_names = {fig(3).name};
for k = 4:length(fig)
    fig_k = {fig(k).name};
    fig_names = vertcat(fig_names, fig_k); %% puts the names from each file in a group for the boxplot
end
fig_data = fig(3).data';
for z = 4:length(fig)
    fig_data = catpad(2, fig_data, fig(z).data');%% concatenates the data into a matrix. Each column is one strain's data
end
boxplot(fig_data,fig_names, 'notch', 'on')
