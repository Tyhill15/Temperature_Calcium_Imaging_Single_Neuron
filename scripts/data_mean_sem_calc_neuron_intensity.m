clear all
[filename pathname] = uigetfile
load ([pathname filename])
format long g
data = [cell.intensity]'% just change this assigment if you want to compute for 
                    % something else, total_fret_amps, for example.
mean_data = mean(data)
std_data = std(data)
sem_data = std_data/sqrt(length(data))
n = length(data)
