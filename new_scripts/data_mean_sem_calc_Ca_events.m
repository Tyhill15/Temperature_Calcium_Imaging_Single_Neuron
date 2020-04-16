
[filename pathname] = uigetfile
load ([pathname filename])

AMPS = catpad(2, events.amp)'

mean_AMPS = nanmean(AMPS)
std_AMPS = nanstd(AMPS)
sem_AMPS = nanstd(AMPS)/sqrt(length(AMPS))
n_AMPS = length(AMPS)

NUMBER = catpad(2, events.number)'

mean_NUMBER = nanmean(NUMBER)
std_NUMBER = nanstd(NUMBER)
sem_NUMBER = nanstd(NUMBER)/sqrt(length(NUMBER))
n_NUMBER = length(NUMBER)

FREQS = catpad(2, events.freq)'

mean_FREQS = nanmean(FREQS)
std_FREQS = nanstd(FREQS)
sem_FREQS = nanstd(FREQS)/sqrt(length(FREQS))
n_FREQS = length(FREQS)

TIME_ABOVE_BASELINE = catpad(2, events.time_above_baseline)'

mean_TIME_ABOVE_BASELINE = nanmean(TIME_ABOVE_BASELINE)
std_TIME_ABOVE_BASELINE = nanstd(TIME_ABOVE_BASELINE)
sem_TIME_ABOVE_BASELINE = nanstd(TIME_ABOVE_BASELINE)/sqrt(length(TIME_ABOVE_BASELINE))
n_TIME_ABOVE_BASELINE = length(TIME_ABOVE_BASELINE)

AREA_ABOVE_BASELINE = catpad(2, events.area_above_baseline)'

mean_AREA_ABOVE_BASELINE = nanmean(AREA_ABOVE_BASELINE)
std_AREA_ABOVE_BASELINE = nanstd(AREA_ABOVE_BASELINE)
sem_AREA_ABOVE_BASELINE = nanstd(AREA_ABOVE_BASELINE)/sqrt(length(AREA_ABOVE_BASELINE))
n_AREA_ABOVE_BASELINE = length(AREA_ABOVE_BASELINE)