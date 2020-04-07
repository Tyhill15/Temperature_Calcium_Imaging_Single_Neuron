clear all;
close all;
[filename pathname] = uigetfile
load ([pathname filename])


lengths =[];
for i = 1:length(BLC)
    lengths(end+1) = length(BLC(i).del_F);
end

min_length = min(lengths);

for j = 1:length(BLC)
    BLC(j).temp = BLC(j).temp(1:min_length);
    BLC(j).del_F = BLC(j).del_F(1:min_length);
end


samples = min_length;

deltafs = BLC(1).del_F
for i = 2:length(BLC)
    deltaf = BLC(i).del_F;
    deltafs = vertcat(deltafs, deltaf);
end

temps = BLC(1).temp
for i = 2:length(BLC)
    temp = BLC(i).temp;
    temps = vertcat(temps, temp);
end
avgdeltafs = mean(deltafs);
semdeltafs = nanstd(deltafs) ./ sqrt(size(deltafs,1));
avgtemps = mean(temps);

hold on
[AX,H1,H2] = plotyy(1:samples,avgdeltafs,1:samples,avgtemps);
set(AX(1),'XLim',[0 samples ],'YLim',[-10 60], 'ytick',[-10 0 10 20 30 40 50 60 70], 'LineWidth', 2, 'FontSize', 13);
set(AX(2),'XLim',[0 samples ],'YLim',[(min(avgtemps)-1) (max(avgtemps)+1)], 'ytick',[15 16 17 18 19 20 21 22 23],'LineWidth', 2, 'FontSize', 13);
set(AX(1),'Box','off')
set(H1, 'LineWidth', 2)
set(H1, 'LineWidth', 2)

line( [(1:samples); (1:samples)], [(avgdeltafs - semdeltafs); (avgdeltafs + semdeltafs)],'Parent', AX(1),'Color', [.8 .8 1]);
%line( [(1:samples); (1:samples)], [(avgtemp - semtemps); (avgtemp + ...
% semtemps)],'Parent', AX(2),'Color', [.8 1 .8])
%uistack(H2,'top')
%uistack(H1,'top')