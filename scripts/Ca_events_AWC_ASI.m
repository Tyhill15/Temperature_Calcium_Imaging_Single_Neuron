%smooths raw AWC/ASI data and pulls out calcium events meeting certain
%threshhold, = 10. Also creates arrays for event amplitdes, times, number
%of events for each trial, and intervals between events for all trials
%combined. This script is meant to run on ONE GENOTYPE'S DATA at a time. 
clear all
close all
dir_of_files = uigetdir();%% prompt for directory choice
 D = dir(dir_of_files);
 c =1;
 total_events = [];
 for i = 1:length(D)
     if(length(D(i).name) >4 && isequal(D(i).name(end-3:end),'.mat') && ~isequal(D(i).name(1),'.') )
          load([dir_of_files filesep D(i).name]);%% pulls out .mat files
        
        figure
        plot(blc, 'b')
        title('Click on each peak, then double click on white space')
        h = gca
        [locs, pks] = getpts(h)
        close
        events(c).blc = blc;
        events(c).amp = pks(1:end-1);
        events(c).time = locs(1:end-1);
        events(c).number = length(events(c).time);%% a struct for each blc file is created with the fields amp, number, time
        c = c+1;
     end
 end
 total_amps = catpad(1, events.amp)%% puts totals for each struct field in a 
                                   %% matrix
 total_times = catpad(1, events.time);
 
 total_numbers = catpad(1,events.number);
 
 intervals = [];
 intervals(1) = nan;
 for i = 2:length(total_events.time)
     intervals(i) = total_events.time(i) - total_events.time(i-1);
     if intervals(i) < 0,
        intervals(i) = nan;
     end
 end
 k = strfind(dir_of_files, 'Tc20');
 filename = (['Ca_Events_', dir_of_files(k:end)]);
 filename = strrep(filename, '/', '_');%% the '/' would be a '\' in windows! annoying
 save([dir_of_files '/' filename])
 
  