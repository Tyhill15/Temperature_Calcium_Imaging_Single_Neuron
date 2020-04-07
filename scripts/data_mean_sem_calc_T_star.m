

[filename pathname] = uigetfile
load ([pathname filename])

data = T_star_temps'% change this assigment if you want to compute for 
                    % something else
mean_data = mean(data)
std_data = std(data)
sem = std(data)/sqrt(length(data))
n = length(data)
clear T_star_temps
