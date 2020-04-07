function [delta_F avg_neuron avg_back] = analzye_two_cells
%
%
%
cm = 'default';
%cm = 'gray';
% load the image file
[fname,mypath]=uigetfile({'*.tif'},'Select the image file (tif) ...');

if(isequal(fname,0))
    return
end
stack=tiffread2([mypath fname]);
filename = find(mypath == filesep);

filename = mypath((filename(end-1))+1:(filename(end))-1);

Total_Data = struct2cell(stack);
Images = Total_Data(7,1,:);
m = cell2mat(Images);
m=double(m);
im1=squeeze(max(m,[],3));


f1 = figure('Color',[1 1 1]);
imagesc(im1);
colormap(cm);set(gca,'XTickLabel',[],'YTickLabel',[],'XTick',[],'YTick',[]);
z1 = zoom(f1);
set(z1,'Enable','on');
title('Zoom in to find NEURON region... select white cursor arrow.'); 
waitfor(z1,'Enable','off');
title('Select Region of Interest around cell.'); 
[n_x,n_y]=getline(get(f1,'CurrentAxes'),'closed');
%region1=double(roipoly(im1,n_x,n_y));
ZXlim = get(get(f1,'CurrentAxes'),'XLim');
ZYlim = get(get(f1,'CurrentAxes'),'YLim');
close(f1)

f1 = figure('Color',[1 1 1]);
imagesc(im1);
colormap(cm);set(gca,'XTickLabel',[],'YTickLabel',[],'XTick',[],'YTick',[]);
%z1 = zoom(f1);
%set(z1,'Enable','on');
title('Select background.'); 
%waitfor(z1,'Enable','off');
[b_x,b_y]=getline(get(f1,'CurrentAxes'),'closed');
%background1=double(roipoly(im1,b_x,b_y));
close(f1);

%f1 = figure('Color',[1 1 1]);
%imagesc(im1);
%colormap(cm);set(gca,'XTickLabel',[],'YTickLabel',[],'XTick',[],'YTick',[]);
%z1 = zoom(f1);
%set(z1,'Enable','on');
%title('choose Neuron outline (to determine neuron size'); 
%waitfor(z1,'Enable','off'); 
%[ns_x,ns_y]=getline(get(f1,'CurrentAxes'),'closed');
%neursize1=double(roipoly(im1,ns_x,ns_y));
%neuron_size=length(find(neursize1)); 
%close(f1); 


%Image_size=numel(im1);
%region1=reshape(region1,1,Image_size);
%background1=reshape(background1,1,Image_size);

%r1=find(double(region1));
%b1=find(double(background1));


ROI(length(stack)).neuronx = [];
ROI(length(stack)).neurony = [];
ROI(length(stack)).bckgrdx = [];
ROI(length(stack)).bckgrdy = [];


ROI(1).neuronx = n_x;
ROI(1).neurony = n_y;
ROI(1).bckgrdx = b_x;
ROI(1).bckgrdy = b_y;


f = figure('KeyPressFcn',@moveimage,'Color',[1 1 1]);
title({'Use < or > to step through stack','Press x to finish'});
imsc = imagesc(stack(1).data,'Parent',get(f,'CurrentAxes'),'ButtonDownFcn',@moveROI);
firstcdata = get(get(imsc,'Parent'),'CLim');
colormap(cm);set(get(f,'CurrentAxes'),'XTickLabel',[],'YTickLabel',[],'XTick',[],'YTick',[]);
set(get(f,'CurrentAxes'),'XLim',ZXlim,'YLim',ZYlim);
title({'Use < or > to step through stack','Press x to finish','click image to reset ROI'});
hold on
line(ROI(1).neuronx,ROI(1).neurony,'Color',[1 0 0 ],'Parent',get(f,'CurrentAxes'));
hold off

setappdata(f,'frame',1);
setappdata(f,'imgs',stack);
setappdata(f,'ROI',ROI);
setappdata(f,'ZXlim',ZXlim);
setappdata(f,'ZYlim',ZYlim);
setappdata(f,'cm',cm);
setappdata(f,'firstcdata',firstcdata);


waitfor(f);

avg_neuron = nan(1,length(stack));
avg_back = nan(1,length(stack));
for i = 1:length(stack)
  avg_neuron(i) = mean(stack(i).data(roipoly(stack(i).data,ROI(i).neuronx,ROI(i).neurony)));
  avg_back(i) = mean(stack(i).data(roipoly(stack(i).data,ROI(1).bckgrdx,ROI(1).bckgrdy)));
  
end

backgrdcrrt = avg_neuron-avg_back;
baselineF = mean(backgrdcrrt(1:10));
delta_F = ((backgrdcrrt - baselineF) ./ baselineF) * 100;
Delta_R_Figure = figure('Color',[1 1 1]);
plot(delta_F);
ylabel('\DeltaF/F (%)');
xlabel('Time ');

saveas(Delta_R_Figure,[mypath filesep 'Delta_F_Figure_' filename '.fig'],'fig');
saveas(Delta_R_Figure,[mypath filesep 'Delta_F_Figure_' filename '.jpg'],'jpg');
filename = ['GCAMP_Analysis_' filename '.mat'];
save ([mypath filename],'avg_neuron','avg_back','baselineF','delta_F');



function ROI = moveimage(snd,evnt)

if(isequal(evnt.Key,'x'))
    ROI = getappdata(snd,'ROI');
    assignin('caller','ROI',ROI);
    close(snd);return;
end


frame = getappdata(snd,'frame');
ROI = getappdata(snd,'ROI');
stack = getappdata(snd,'imgs');
ZXlim = getappdata(snd,'ZXlim');
ZYlim = getappdata(snd,'ZYlim');
cm = getappdata(snd,'cm');
firstcdata = getappdata(snd,'firstcdata');


if(isequal(evnt.Key,'period') && frame < length(stack))
    frame = frame + 1;
elseif(isequal(evnt.Key,'comma') && frame > 1)
    frame = frame - 1;
end

npoly = findobj('Tag','impoly');
if(isempty(npoly) && frame > 0)
    ROI(frame) = ROI(frame -1);
else
    api=iptgetapi(npoly(1));
    temp = api.getPosition();
    ROI(frame).neuronx = temp(:,1);
    ROI(frame).neurony = temp(:,2);
end

imagesc(stack(frame).data,'Parent',get(snd,'CurrentAxes'),'ButtonDownFcn',@moveROI);

colormap(cm);set(get(snd,'CurrentAxes'),'XTickLabel',[],'YTickLabel',[],'XTick',[],'YTick',[],'Clim',firstcdata);
set(get(snd,'CurrentAxes'),'XLim',ZXlim,'YLim',ZYlim);
title({'Use < or > to step through stack','Press x to finish','click image to reset ROI'});
hold on
line(ROI(frame).neuronx,ROI(frame).neurony,'Color',[1 0 0 ],'Parent',get(snd,'CurrentAxes'));
hold off

if(isequal(frame,length(stack)))
   set(snd,'Color',[1 0 0]);
  title({[num2str(frame) ' / ' num2str(length(stack))],'Press X to finish'});
end

setappdata(snd,'frame',frame);
setappdata(snd,'ROI',ROI);

function moveROI(snd,~)

frame = getappdata(get(get(snd,'Parent'),'Parent'),'frame');
ROI = getappdata(get(get(snd,'Parent'),'Parent'),'ROI');
delete(findobj('Color','r'))
npoly = impoly(get(snd,'Parent'),[ROI(frame).neuronx ROI(frame).neurony],'Closed','true');
setColor(npoly,'red'); 

