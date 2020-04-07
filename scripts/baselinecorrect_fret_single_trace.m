clear all;
close all;
[file pathname] = uigetfile
load ([pathname file]) 

smooth_YFP = smooth(YFP, 20, 'loess');%%%%this part smooths CFP and YFP first and creates a new,
smooth_CFP = smooth(CFP, 20, 'loess');  %%smoothed fret signal, del_F. This smooth signal fits
FRET = smooth_CFP./smooth_YFP;            %%the raw signal very well. See end of script to compare
del_F = ((FRET-baseline)/baseline)*100;   %%the two if you want.
del_F = del_F';
scrsz = get(0,'ScreenSize');

fig=figure('Position',[1 scrsz(4)./2 scrsz(3)./2 scrsz(4)./2],'Color',[1 1 1]);
h  = plot(delta_F);
disp(file);
title(file,'Interpreter','none');
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
title('Corrected signal')
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

BLC.time = 1:length(Temperature);
BLC.raw_del_F = blc_raw;
BLC.del_F = blc_clean;
BLC.CFP = smooth_CFP;
BLC.YFP = smooth_YFP;
BLC.temp = Temperature;
BLC.baseline = baseline;
orig.raw_del_F = delta_F;
orig.del_F = del_F;
orig.YFP = YFP;
orig.CFP = CFP;
orig.temp = Temperature;

kk = strfind(file, '.mat');
trial_num = file(kk-2:kk-1);
k = strfind(pathname, '\');
geno = pathname(k(end-1)+1:k(end)-1);
new_file = (['blcrrt_', geno, '_', trial_num]);
BLC_folder = mkdir(pathname,'BLC');
save([pathname, 'BLC/', new_file], 'BLC', 'orig');


