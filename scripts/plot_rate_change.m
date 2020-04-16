clear all; close all
dir_of_files = uigetdir;
D = dir(dir_of_files);
s = what(dir_of_files);
files = s.mat;
b = 1;
for x = 1:numel(files)
    load([dir_of_files '/' char(files(x))]);
    name = char(files(x));
    k = strfind(name, 'permin');
    rate(b).geno = name(k+7:end-4);
    rate(b).time_points = time_points;
    rate(b).rate_per_1min = rate_per_min;
    rate(b).rate_per_10min = rate_per_10min;
    rate(b).rate_per_60min = rate_per_60min;
    b = b+1;
end
C = {'b','r','k','g','y'};
genos = {rate.geno};
figure(1)
for i = 1:length(rate)
    plot(rate(i).time_points(2:5), rate(i).rate_per_1min(1:4), C{i}, 'LineWidth', 2)
    hold on
end
title('Rate of slope change per min')
h = legend(genos)
psn=get(h,'Position');
psn(3:4)=1.5*psn(3:4);
set(h,'position',psn);
set(h,'FontSize',14)
% figure(2)
% for j = 1:length(rate)
%     plot(rate(j).time_points(2:10), rate(j).rate_per_10min(1:9), C{j}, 'LineWidth', 2)
%     hold on
% end
% title('Rate of slope change per 10min')
% legend(genos)
% figure(3)
% for k = 1:length(rate)
%     plot(rate(k).time_points(2:end-1), rate(k).rate_per_60min(1:end-1), C{k}, 'LineWidth', 2)
%     hold on
% end
% title('Rate of slope change per 60min')
% legend(genos)

    
    
    
    