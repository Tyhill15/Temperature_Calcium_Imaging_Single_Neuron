clear; close all
dir_of_files = uigetdir;
D = dir(dir_of_files);
s = what(dir_of_files);
files = s.mat;
c = 1;
lengths =[];
for m = 1:numel(files)
    load([dir_of_files '/' char(files(m))]);
    filename = char(files(m));
    lengths(end+1) = length(BLC.raw_del_F);
    display(c).raw_delta_F = BLC.raw_del_F;
    display(c).temps = BLC.temp;
    c = c+1;
end

min_length = min(lengths);
samples = min_length;

for j = 1:length(display)
        display(j).temps = display(j).temps(1:min_length);
        display(j).raw_delta_F = display(j).raw_delta_F(1:min_length);
end

raw_deltafs = vertcat(display.raw_delta_F);

temps = vertcat(display.temps);

avgdeltafs = mean(raw_deltafs);
semdeltafs = nanstd(raw_deltafs) ./ sqrt(size(raw_deltafs,1));
avgtemps = mean(temps);

hold on
[AX,H1,H2] = plotyy(1:samples,avgdeltafs,1:samples,avgtemps);
set(AX(1),'XLim',[0 samples ],'YLim',[-10 ((max(avgdeltafs))+10)], 'ytick',[-10 0 10 20 30 40 50 60 70], 'LineWidth', 2, 'FontSize', 13);
set(AX(2),'XLim',[0 samples ],'YLim',[(min(avgtemps)-1) (max(avgtemps)+1)], 'ytick',[15 16 17 18 19 20 21 22 23],'LineWidth', 2, 'FontSize', 13);
set(AX(1),'Box','off')
set(H1, 'LineWidth', 2)
set(H1, 'LineWidth', 2)

line( [(1:samples); (1:samples)], [(avgdeltafs - semdeltafs); (avgdeltafs + semdeltafs)],'Parent', AX(1),'Color', [.8 .8 1]);
%line( [(1:samples); (1:samples)], [(avgtemp - semtemps); (avgtemp + ...
% semtemps)],'Parent', AX(2),'Color', [.8 1 .8])
%uistack(H2,'top')
%uistack(H1,'top')