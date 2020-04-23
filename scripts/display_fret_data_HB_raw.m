% clear all;
% close all;
[filename pathname] = uigetfile
load ([pathname filename])


lengths =[];
for i = 1:length(BLC)
    lengths(end+1) = length(BLC(i).raw_del_F);
end

min_length = min(lengths);

for j = 1:length(BLC)
    BLC(j).temp = BLC(j).temp(1:min_length);
    BLC(j).raw_del_F = BLC(j).raw_del_F(1:min_length);
end


samples = min_length;

raw_deltafs = BLC(1).raw_del_F;
for i = 2:length(BLC)
    raw_deltaf = BLC(i).raw_del_F;
    raw_deltafs = vertcat(raw_deltafs, raw_deltaf);
end

temps = BLC(1).temp;
for i = 2:length(BLC)
    temp = BLC(i).temp;
    temps = vertcat(temps, temp);
end

avgdeltafs = mean(raw_deltafs);
semdeltafs = nanstd(raw_deltafs) ./ sqrt(size(raw_deltafs,1));
avgtemps = mean(temps);



hold on

E1 = line( [(1:samples); (1:samples)], [(avgdeltafs - semdeltafs); (avgdeltafs + semdeltafs)],'Color', [.8 .8 .8]);

[AX,H1,H2] = plotyy(1:samples,avgdeltafs,1:samples,avgtemps);
set(AX(1),'XLim',[0 samples ],'YLim',[-10 100], 'ytick',[(-10:10:100)], 'LineWidth', 2, 'FontSize', 13);
%set(AX(2),'XLim',[0 samples ],'YLim',[(min(avgtemps)-1) (max(avgtemps)+1)], 'ytick',[13:1:35],'LineWidth', 2, 'FontSize', 13);
set(AX(1),'Box','off')
set(H1, 'LineWidth', 2)
set(H2, 'LineWidth', 2)

set(AX,'FontSize',20)
%H1 = plot(avgdeltafs);
% set(H1, 'LineWidth', 2)


%line( [(1:samples); (1:samples)], [(avgdeltafs - semdeltafs); (avgdeltafs + semdeltafs)],'Parent', AX(1),'Color', [.8 .8 1], 'LineWidth', 2);
%line( [(1:samples); (1:samples)], [(avgtemp - semtemps); (avgtemp + ...
% semtemps)],'Parent', AX(2),'Color', [.8 1 .8])
%uistack(H2,'top')
%uistack(H1,'top')




%for error bar coloring, [.8 .8 1] for blue,
%[1 .8 .8] for red, [.8 .8 .8] for black