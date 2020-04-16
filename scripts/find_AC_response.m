function find_AC_response(full_path_to_datafile, varargin) 
% pass in the full path to a data file, and this will determine the
% response of [file].FRET to the oscillating signal in [file].T
% 
    
    % turn on this flag to generate plots
    if nargin>1
        PLOTTING = varargin{1};
    else
        PLOTTING = true;
    end
    
    % getting the period exactly right isn't essential, but it does
    % increase the quality of the lock-in measurement
    PERIOD_FUDGE_FACTOR = 1.12;
    
    % load data
    data = load(full_path_to_datafile);
    
    
    temperature = data.Temperature;
    CFP = data.CFP;
    YFP = data.YFP;
    time = 1:length(temperature); %unit: sampling time
    
    % only keep times for which we have valid data
    selection = ~isnan(temperature) & ...
                ~isnan(CFP) & ...
                ~isnan(YFP);
            
    
    CFP = CFP(selection);
    YFP = YFP(selection);
    FRET = CFP./YFP;
    temperature = temperature(selection);
    time = time(selection);
   
    if ~isempty(find(diff(time)-mean(diff(time)), 1))
        error('valid data is not uniformly sampled in time');
    end
    
    % find the period of the temperature oscillations, make reference
    % oscillators
    periods = periodogram(diff(smooth(temperature)));
    period = find(periods == max(periods))*PERIOD_FUDGE_FACTOR;
    oscillator_x = cos(2*pi/period*time);
    oscillator_y = sin(2*pi/period*time);
   
        
    % now that we have the period, we can do one-period smoothing to
    % eliminate the DC temperature signal.  The DC temperature should be a
    % linear ramp and the AC temperature should be the oscillatory
    % component.
    temperature_DC = smooth(temperature,round(period));
    temperature_AC = temperature' - temperature_DC;

    
    

    CFP_DC = smooth(CFP,round(period));
    CFP_AC = CFP' - CFP_DC;
    
    YFP_DC = smooth(YFP,round(period));
    YFP_AC = YFP' - YFP_DC;
       
    FRET_AC = CFP_AC - YFP_AC;
    
    % Multiplex
    FRET_x = smooth(FRET_AC.*oscillator_x',round(period));
    FRET_y = smooth(FRET_AC.*oscillator_y',round(period));
    FRET_mag = FRET_x.^2 + FRET_y.^2;
    
    temperature_x = smooth(temperature_AC.*oscillator_x',round(period));
    temperature_y = smooth(temperature_AC.*oscillator_y',round(period));
    temperature_mag = temperature_x.^2 + temperature_y.^2;
    
    
    if PLOTTING
      figure(2315);
      subplot(221);
      plot(time,temperature,...
           time,temperature_AC,...
           time,temperature_DC);
      title('Breaking temperature signal into AC and DC components')
      xlabel('time');
      ylabel('temperature')
      
      subplot(222);
      plot(time, smooth(FRET_AC/max(FRET_AC)));
      title('FRET signal');
      
      subplot(223); 
      plot(time, temperature_AC*5, time, oscillator_y)
      title('these two signals should have about the same period')
      
      subplot(224);
      plot(temperature_DC, FRET_mag);
      xlabel('DC Temperature');
      ylabel('AC FRET signal');
    end
    
    data.FRET_AC = FRET_AC;
    save(full_path_to_datafile,'-struct','data');
end