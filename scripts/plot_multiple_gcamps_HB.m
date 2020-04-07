clear; close all
dir_of_files = uigetdir;
D = dir(dir_of_files);
GC = [];
c = 1;
for i = 1:length(D)
   if(length(D(i).name) >4 && isequal(D(i).name(end-3:end),'.mat') )
    load([dir_of_files filesep D(i).name]);
    GC(c).blc = blc(1:600);
    GC(c).delta_F_mean = delta_F_mean(1:600);
    GC(c).resampletemp = resampletemp(1:600);
    c = c + 1;
   end
end

bc = zeros(length(GC),600);
for i = 1:length(GC)
        bc(i,:) = GC(i).blc;
end

%colormap('hot')
h = imagesc(bc,[0 50]);
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
