clear; close all
dir_of_files = uigetdir;
D = dir(dir_of_files);
s = what(dir_of_files);
files = s.mat;
c = 1;

%amplitudes = [];
for m = 1:numel(files)
    load([dir_of_files '/' char(files(m))]);
    filename = char(files(m));
    total(c).del_F = delta_F;
    total(c).temps = Temperature;
%     plot(delta_F)
%     h = gca;
%     [locs, pks] = getpts(h);
%     amplitudes(end+1) = pks(2)-pks(1);
    c = c + 1;
end
close;

% amplitude_mean = mean(amplitudes);
% amplitude_sem = std(amplitudes') ./ sqrt(length(amplitudes));
% amplitude_std = std(amplitudes);

temps = vertcat(total.temps);
raw_deltafs = vertcat(total.del_F);
avgdeltafs = mean(raw_deltafs);
semdeltafs = nanstd(raw_deltafs) ./ sqrt(size(raw_deltafs,1));
avgtemps = mean(temps);
samples = length(avgdeltafs);

[AX,H1,H2] = plotyy(1:samples,avgdeltafs,1:samples,avgtemps);
set(AX(1),'XLim',[0 samples ],'YLim',[-10 130], 'ytick',[-10:10:130], 'LineWidth', 2, 'FontSize', 13);
set(AX(2),'XLim',[0 samples ],'YLim',[(min(avgtemps)-1) (max(avgtemps)+1)], 'ytick',[round((min(avgtemps)-1)):1:round((max(avgtemps)+1))],'LineWidth', 2, 'FontSize', 13);
E1 = line( [(1:samples); (1:samples)], [(avgdeltafs - semdeltafs); (avgdeltafs + semdeltafs)],'Color', [.8 .8 .8]);
set(AX(1),'Box','off')
set(H1, 'LineWidth', 2)
set(H2, 'LineWidth', 2)

set(AX,'FontSize',20)