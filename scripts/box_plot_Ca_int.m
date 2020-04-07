clear all
close all
disp('Select a directory with only Ca_Events_.....mat files to analyze')
pause(2)
dir_of_file = uigetdir;%% prompt for directory choice
Dir = dir(dir_of_file);
c =1;
for j = 1:(length(Dir))
     if(length(Dir(j).name) >4 && isequal(Dir(j).name(end-3:end),'.mat') && ~isequal(Dir(j).name(1),'.') )
          load([dir_of_file filesep Dir(j).name]);%% pulls out .mat files
          k = strfind(Dir(j).name, 'Th');
          plot(j).name = Dir(j).name(k+5:end-4);
          plot(j).data = intervals;
     end
end
plot_names = {plot(3).name};
for k = 4:length(plot)
    plot_k = {plot(k).name};
    plot_names = vertcat(plot_names, plot_k); %% puts the names from each file in a group for the boxplot
end
plot_data = plot(3).data';
for z = 4:length(plot)
    plot_data = catpad(2, plot_data, plot(z).data');%% concatenates the data into a matrix. Each column is one strain's data
end
boxplot(plot_data,plot_names, 'notch', 'on')