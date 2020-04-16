

[filename pathname] = uigetfile
load ([pathname filename])

T_STAR = T_star_temps'% all the T*s from that data set. 
                    
mean_T_STAR = mean(T_STAR)
std_T_STAR = std(T_STAR)
sem_T_STAR = std(T_STAR)/sqrt(length(T_STAR))
n_T_STAR = length(T_STAR)

if length(total_fret_amps(:,1))==1
    FRET_AMPS = total_fret_amps'
elseif length(total_fret_amps(:,1)) > 1
    FRET_AMPS = nanmean(total_fret_amps)' %%% This will give all the trial averages
end

%ALL_FRET_AMPS = total_fret_amps%%%every amp from every trial, in trial by column format
mean_FRET_AMPS = nanmean(FRET_AMPS)
std_FRET_AMPS = nanstd(FRET_AMPS)
sem_FRET_AMPS = nanstd(FRET_AMPS)/sqrt(length(FRET_AMPS))
n_FRET_AMPS = length(FRET_AMPS)


