clear; close all
dir_of_files = uigetdir();
[a filename] = fileparts(dir_of_files);

D = dir(dir_of_files);
GC = [];
c = 1;
for i = 1:length(D)
   if(length(D(i).name) >4 && isequal(D(i).name(end-3:end),'.mat') )
    load([dir_of_files filesep D(i).name]);
    GC(c).blc = blc;
    GC(c).delta_F_mean = delta_F_mean;
    GC(c).resampletemp = resampletemp;
    GC(c).name = D(i).name;
    c = c + 1;
   end
end

bc = zeros(length(GC),1801);
for i = 1:length(GC)
   bc(i,:) = GC(i).blc(1:1801);
end

if(0)
subplot(8,1,[1 2 3])
plot(bc(1,:))
subplot(8,1,[ 5 6 7 8])
end
h = imagesc(bc,[0 80]);
xax = get(gca,'XTick');
rt = xax / 2;
set(gca,'XTicklabel',rt)
set(gca,'YTickLabel',[])
set(get(gca,'Xlabel'),'String', 'Time (s)');
%set(get(gca,'Ylabel'),'String', 'Animal');

cb = colorbar;
set(get(cb,'Ylabel'),'String','\DeltaF/F %')

date_proc = datevec(now);
%save([dir_of_files filesep filename '_' num2str(date_proc(2)) '_' num2str(date_proc(3)) ...
%       '_' num2str(date_proc(1)) '_' num2str(date_proc(4))  num2str(date_proc(5))  '.mat']);
saveas(gcf,[dir_of_files filesep filename  '.fig']);
saveas(gcf,[dir_of_files filesep filename '.jpg'],'jpg')