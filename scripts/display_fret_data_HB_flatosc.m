clear all;
close all;
[filename pathname] = uigetfile
load ([pathname filename])

for i = 2:length(BLC)
    if BLC(i).temp > BLC(i-1).temp
        BLC(i).temp = BLC(i).temp(1:length(BLC(i-1).temp));
    end
end
samples = length(1:length(BLC(1).temp))
for i = 2:length(BLC)
    if BLC(i).raw_del_F > BLC(i-1).raw_del_F
        BLC(i).raw_del_F = BLC(i).raw_del_F(1:length(BLC(i-1).raw_del_F));
    end
end

raw_deltafs = BLC(1).raw_del_F

for i = 2:length(BLC)
    raw_deltaf = BLC(i).raw_del_F;
    raw_deltafs = vertcat(raw_deltafs, raw_deltaf);
end

temps = BLC(1).temp
for i = 2:length(BLC)
    temp = BLC(i).temp;
    temps = vertcat(temps, temp);
end
avgdeltafs = mean(raw_deltafs);
semdeltafs = nanstd(raw_deltafs) ./ sqrt(size(raw_deltafs,1));
avgtemps = mean(temps);

hold on
[AX,H1,H2] = plotyy(1:samples,avgdeltafs,1:samples,Temperature);
set(AX(1),'XLim',[0 121 ],'YLim',[-10 50], 'ytick',[-10 0 10 20 30 40 50], 'LineWidth',2);
set(AX(2),'XLim',[0 121 ],'YLim',[(min(Temperature)-1) (max(Temperature)+1)], 'ytick',[14 14.5 15 15.5 16],'LineWidth',2);
set(AX(1),'Box','off')
set(H1, 'LineWidth', 2)
set(H1, 'LineWidth', 2)

line( [(1:samples); (1:samples)], [(avgdeltafs - semdeltafs); (avgdeltafs + semdeltafs)],'Parent', AX(1),'Color', [.8 .8 1]);
%line( [(1:samples); (1:samples)], [(avgtemp - semtemps); (avgtemp + ...
% semtemps)],'Parent', AX(2),'Color', [.8 1 .8])
%uistack(H2,'top')
%uistack(H1,'top')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[AX,H1,H2] = plotyy(1:samples,avgdeltafs,1:samples,Temperature);
set(AX(1),'XLim',[0 121 ],'YLim',[-10 50], 'ytick',[-10 0 10 20 30 40 50], 'LineWidth',2);
set(AX(2),'XLim',[0 121 ],'YLim',[(min(Temperature)-1) (max(Temperature)+1)], 'ytick',[14 14.5 15 15.5 16],'LineWidth',2);


line( [(1:samples); (1:samples)], [(avgdeltafs - semdeltafs); (avgdeltafs + semdeltafs)],'Parent', AX(1),'Color', [.8 .8 1]);
%line( [(1:samples); (1:samples)], [(avgtemp - semtemps); (avgtemp + ...
% semtemps)],'Parent', AX(2),'Color', [.8 1 .8])
uistack(H2,'top')
uistack(H1,'top')