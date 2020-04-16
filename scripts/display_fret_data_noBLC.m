clear; close all

 dir_of_files = uigetdir();
 D = dir(dir_of_files);
 c =1;
  for i = 3:length(D)
      if(length(D(i).name) >4 && isequal(D(i).name(end-3:end),'.mat') && ~isequal(D(i).name(1),'.') )

          load([dir_of_files '/' D(i).name]);  %load analzyed
%vars fro mat file
          GC(c).time = Image_Time;
          GC(c).delta_F_mean = delta_F;  % store delta R  here
          GC(c).T = Temperature; % store temp here
          c = c + 1;
      end
  end

samples = 601;

deltafs = nan(length(GC),samples );
temps  = nan(length(GC),samples );

%put it in an array and interpolate missing values
for i = 1:length(GC)
    deltafs(i,GC(i).time) =  GC(i).delta_F_mean;
    
    if (length(GC(i).time) > length(GC(i).T))
        my_temps = [];
        replc = randi(samples,[1 length(GC(i).time) - length(GC(i).T)]);
        start = 1;
        for r = 1:samples
            if(any(r == replc))
                my_temps(r) = NaN;
            else
                my_temps(r) = GC(i).T(start);
                start = start +1;
            end
        end
        
        GC(i).T = my_temps;
        temps(i,GC(i).time) =  GC(i).T ;

    else
        temps(i,GC(i).time) =  GC(i).T ;
    end
 
    

 %interpolate missing nan
    missingvals = find(isnan(deltafs(i,:)));  %find missing values
    deltafs(i,missingvals ) = interp1(GC(i).time,GC(i).delta_F_mean,missingvals);   %interpolate Delta F
    
    temps(i,missingvals ) = interp1(GC(i).time,GC(i).T, missingvals);
 %interpolate Temp


end


avgdeltafs = nanmean(deltafs,1);
avgtemp = nanmean(temps,1);

semdeltafs = nanstd(deltafs) ./ sqrt(size(deltafs,1));
semtemps = nanstd(temps) ./ sqrt(size(temps,1));

[AX,H1,H2] = plotyy(1:samples,avgdeltafs,1:samples,avgtemp);
set(AX(1),'XLim',[0 360 ], 'YLim',[-20 20],'ytick',[(-80:20:80)],'LineWidth',2);
set(AX(2),'XLim',[0 360 ],'LineWidth',2);
set(AX(2), 'FontSize', 20)
set(AX(1),'Box','off')
set(H1, 'LineWidth', 2)
set(H2, 'LineWidth', 2)

line( [(1:samples); (1:samples)], [(avgdeltafs - semdeltafs); (avgdeltafs + semdeltafs)],'Parent', AX(1),'Color', [.8 .8 1]);

ylabel(AX(1), '%R/R');
ylabel(AX(2), 'Temperature');
set(AX,'FontSize',20)
