%clear all; close all; clc;
%[filename pathname] = uigetfile(['/Volumes/home/bev/img/ASI_hold_20' filesep '*.mat']);
%load([pathname, filename], '-mat','delta_F_mean','resampletemp');
close all;
scrsz = get(0,'ScreenSize');

fig=figure('Position',[1 scrsz(4)./2 scrsz(3)./2 scrsz(4)./2],'Color',[1 1 1]);
h  = plot(delta_F_mean);
disp(filename);
title(filename,'Interpreter','none');
ax =gca;
axes(ax);
[blx bly] = getline(ax);
[ublx a b] = unique(blx);
ubly = bly(a);

bsl = interp1(ublx,ubly,1:length(delta_F_mean));
bsl(isnan(bsl)) = 0;


%bsl = zeros(1,length(delta_F_mean));
%for i = 1:length(blx)-1
% bsl(round(blx(i)):round(blx(i+1))) = interp1(blx(i:i+1),bly(i:i+1),round(blx(i)):round(blx(i+1)));
%end
close(fig)
blc = (delta_F_mean + abs(min(bly))) - (bsl +  abs(min(bly)));
figure;
plot(blc);save([pathname 'blcrrt_'   filename(1:end-4) '.mat'],'blc','delta_F_mean','resampletemp');
