clear all;
close all;
[file path] = uigetfile
load ([path file]) 

set(0,'DefaultFigurePosition',[100 100 1000 1000]);
fig  = plot(delta_F);
disp(file);
title(file,'Interpreter','none');
ax =gca;
axes(ax);
[blx bly] = getline(ax);
[ublx a b] = unique(blx);
ubly = bly(a);

bsl = interp1(ublx,ubly,1:length(delta_F));
bsl(isnan(bsl)) = 0;

close
blc_raw = (delta_F + abs(min(bly))) - (bsl +  abs(min(bly)));

figure;
hold on
plot(blc_raw,'r');
title('Corrected signal')
pause(2)
close

if exist('YFP')==1
    smooth_YFP = smooth(YFP, 20, 'loess');%%%%this part smooths CFP and YFP first and creates a new,
    smooth_CFP = smooth(CFP, 20, 'loess');  %%smoothed fret signal, del_F. This smooth signal fits
    FRET = smooth_CFP./smooth_YFP;            %%the raw signal very well. See end of script to compare
    del_F = ((FRET-baseline)/baseline)*100;   %%the two if you want.
    del_F = del_F';
    blc_clean = (del_F + abs(min(bly))) - (bsl +  abs(min(bly)));
    clean_CFP = smooth_CFP;
    clean_YFP = smooth_YFP;
    BLC_raw_delta_F = blc_raw;
    BLC_clean_delta_F = blc_clean;
    temp = Temperature;
else
    del_F = smooth(delta_F, 15, 'loess')';
    blc_clean = (del_F + abs(min(bly))) - (bsl +  abs(min(bly)));
    BLC_raw_delta_F = blc_raw;
    BLC_clean_delta_F = blc_clean;
    temp = Temperature;
end

kk = strfind(file, '.mat');
trial_num = file(kk-2:kk-1);
% k = strfind(pathname, '\');
% geno = pathname(k(end-1)+1:k(end)-1);
new_file = (['blcrrt_', trial_num]);
BLC_folder = mkdir(path,'BLC');
save([path, 'BLC/', new_file]);




