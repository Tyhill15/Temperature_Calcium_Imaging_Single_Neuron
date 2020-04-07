
[filename pathname] = uigetfile
load ([pathname filename])

data = nanmean(total_fret_amps)'

mean_data = nanmean(data)
std_data = nanstd(data)
sem = nanstd(data)/sqrt(length(data))
n = length(data)
clear total_fret_amps