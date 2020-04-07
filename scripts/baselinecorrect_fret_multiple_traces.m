
clear all;
close all;
dir_of_files = uigetdir();
 D = dir(dir_of_files);
 c =1;
  for i = 1:length(D)
      if(length(D(i).name) >4 && isequal(D(i).name(end-3:end),'.mat') && ~isequal(D(i).name(1),'.') )

          load([dir_of_files filesep D(i).name]);  
          smooth_YFP = smooth(YFP, 20, 'loess');%%%%this part smooths CFP and YFP first and creates a new,
          smooth_CFP = smooth(CFP, 20, 'loess');  %%smoothed fret signal, del_F. This smooth signal fits 
          FRET = smooth_CFP./smooth_YFP;            %%the raw signal very well. See end of script to compare
          del_F = ((FRET-baseline)/baseline)*100;   %%the two if you want.
          del_F = del_F';
          scrsz = get(0,'ScreenSize');

          fig=figure('Position',[1 scrsz(4)./2 scrsz(3)./2 scrsz(4)./2],'Color',[1 1 1]);
          h  = plot(delta_F);
          disp(filename);
          title(filename,'Interpreter','none');
          ax =gca;
          axes(ax);
          [blx bly] = getline(ax);
          [ublx a b] = unique(blx);
          ubly = bly(a);

          bsl = interp1(ublx,ubly,1:length(delta_F));
          bsl(isnan(bsl)) = 0;


          
          close(fig)
          blc_raw = (delta_F + abs(min(bly))) - (bsl +  abs(min(bly)));
          blc_clean = (del_F + abs(min(bly))) - (bsl +  abs(min(bly)));%%%%end of section for smoothed signal
          figure;
          plot(blc_clean);
          hold on
          plot(blc_raw,'r');
          title('Corrected signals')
          pause(2)
          close
          
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%
          %scrsz = get(0,'ScreenSize');%%%%this section for correcting raw fret. 
                                        %%CFP and YFP not smoothed. Takes
                                        %%delta_F straight from
                                        %%FRET_Analysis script.
          %fig=figure('Position',[1 scrsz(4)./2 scrsz(3)./2 scrsz(4)./2],'Color',[1 1 1]);
          %h  = plot(delta_F);
          %disp(filename);
          %title(filename,'Interpreter','none');
          %ax =gca;
          %axes(ax);
          %[blx bly] = getline(ax);
          %[ublx a b] = unique(blx);
          %ubly = bly(a);%

          %bsl = interp1(ublx,ubly,1:length(delta_F));
          %bsl(isnan(bsl)) = 0;


          
          %close(fig)
          
          %blc_raw = (delta_F + abs(min(bly))) - (bsl +  abs(min(bly)));
          
          %figure;
          %plot(blc_raw);
          %title('Corrected signal')
          %pause(2)
          %close
          
          BLC(c).time = 1:length(Temperature);
          BLC(c).raw_del_F = blc_raw;
          BLC(c).del_F = blc_clean;
          BLC(c).CFP = smooth_CFP;
          BLC(c).YFP = smooth_YFP;
          BLC(c).temp = Temperature;
          BLC(c).baseline = baseline;
          
          c = c + 1;
      end
  end
  k = strfind(dir_of_files, '/');
  new_file = dir_of_files(k(end)+1:end);
  save([dir_of_files '/' new_file '_blcrrt'], 'BLC');