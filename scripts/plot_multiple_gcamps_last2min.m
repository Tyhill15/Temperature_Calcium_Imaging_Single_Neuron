clear; close all
dir_of_files = uigetdir;
D = dir(dir_of_files);
s = what(dir_of_files);
files = s.mat;
GC = [];
c = 1;
filename = 'heatmap'
for i = 1:numel(files)
    load([dir_of_files '/' char(files(i))]);
    GC(c).blc = blc(1:480);
    GC(c).delta_F_mean = delta_F_mean(1:480);
    GC(c).resampletemp = resampletemp(1:480);
    c = c + 1;
end

bc = zeros(length(GC),480);
for i = 1:length(GC)
        bc(i,:) = GC(i).blc;
end

%colormap('hot')
h = imagesc(bc(:,241:end),[0 50]);
xax = get(gca,'XTick');
rt = xax / 2;
set(gca,'XTicklabel',rt)
set(gca,'YTickLabel',[])
set(gca,'XTickLabel',[])

%set(get(gca,'Xlabel'),'String', 'Time (s)');
%set(get(gca,'Ylabel'),'String', 'Animal');

cb = colorbar;
%set(get(cb,'Ylabel'),'String','\DeltaF/F %')

date_proc = datevec(now);
%save([dir_of_files filesep filename '_' num2str(date_proc(2)) '_' num2str(date_proc(3)) ...
%       '_' num2str(date_proc(1)) '_' num2str(date_proc(4))  num2str(date_proc(5))  '.mat']);
saveas(gcf,[dir_of_files filesep filename  '.fig']);
saveas(gcf,[dir_of_files filesep filename '.jpg'],'jpg')
print(gcf,[dir_of_files filesep filename '.eps'],'-depsc2')

close all;
