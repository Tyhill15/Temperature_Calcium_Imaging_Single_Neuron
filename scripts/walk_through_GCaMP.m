function [delta_F avg_neuron avg_back] = walk_through_GCaMP
%walk_through_GCaMP allows user to use keyboard to specify neurons 
%expressing GCaMP for analysis of fluorescence changes.
%   
%   This function asks for a tif image stack. Then asks for the user to
%   select the neuron of interest in image then background. This will 
%   present each frame of the stack. To move throught the stack use the '>'
%   key to advance the frames and the '<' key to reverse frames. If the
%   neuron moves out of the region of interest then click the image. This 
%   will change the ROI to a moveable object to reposition it within the
%   frame. After repositioning the ROI advance the frame to save the new 
%   location.
%
%   This function saves three files in the same directory as the tif file.
%   A jpg, a matlab fig file, and a matlab mat file which contains the
%   delta_F values, background, and unscaled background values.
%
%   To run this script:
%
%       [delta_F avg_neuron avg_back] = walk_through_GCaMP
%
%   delta_F is a vector of the calculated DF/F
%   avg_neuron is a vector of average pixel intensities for the neuron
%   avg_back is a vector of average pixel intensities for the background


cm = 'default'; % default Blue red colormap
%cm = 'gray'; % black and white colormap

% load the image file
[fname,mypath]=uigetfile({'*.tif'},'Select the image file (tif) ...');

if(isequal(fname,0)) %if user doesnt select image
    return
end
stack=tiffread2([mypath fname]); %load the file

filename = find(mypath == filesep);% find all file seperators and extract actual tif file name
filename = mypath((filename(end-1))+1:(filename(end))-1);

Total_Data = struct2cell(stack); % extract data from struct 
Images = Total_Data(7,1,:);
m = cell2mat(Images);
m=double(m);
im1=squeeze(max(m,[],3)); % create projection through stack


f1 = figure('Color',[1 1 1]); % start dialog to request neuron selection
imagesc(stack(1).data);
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

f1 = figure('Color',[1 1 1]);% start dialog to request background selection
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


ROI(length(stack)).neuronx = []; % make room in memory the ROI stack  
ROI(length(stack)).neurony = [];
ROI(length(stack)).bckgrdx = [];
ROI(length(stack)).bckgrdy = [];


ROI(1).neuronx = n_x; % initilize ROI stack with first frame of stack
ROI(1).neurony = n_y;
ROI(1).bckgrdx = b_x;
ROI(1).bckgrdy = b_y;


f = figure('KeyPressFcn',@moveimage,'Color',[1 1 1]); % start dialog for interactive selection
imsc = imagesc(stack(1).data,'ButtonDownFcn',@moveROI);
firstcdata = get(get(imsc,'Parent'),'CLim'); % get color scale values of first frame 
colormap(cm);set(get(f,'CurrentAxes'),'XTickLabel',[],'YTickLabel',[],'XTick',[],'YTick',[]);
set(get(f,'CurrentAxes'),'XLim',ZXlim,'YLim',ZYlim);
title({'Use < or > to step through stack','Press x to finish','click image to reset ROI'});
hold on
line(ROI(1).neuronx,ROI(1).neurony,'Color',[1 0 0 ],'Parent',get(f,'CurrentAxes')); % draw ROI as a line
hold off

setappdata(f,'frame',1); % save the data in figure for dynamic interaction
setappdata(f,'imgs',stack);
setappdata(f,'ROI',ROI);
setappdata(f,'ZXlim',ZXlim);
setappdata(f,'ZYlim',ZYlim);
setappdata(f,'cm',cm);
setappdata(f,'firstcdata',firstcdata);


waitfor(f); % wait for user to finish going through stack

avg_neuron = nan(1,length(stack)); % extract mean pixel values for neuron/background
avg_back = nan(1,length(stack));
for i = 1:length(stack)
  avg_neuron(i) = mean(stack(i).data(roipoly(stack(i).data,ROI(i).neuronx,ROI(i).neurony)));
  avg_back(i) = mean(stack(i).data(roipoly(stack(i).data,ROI(1).bckgrdx,ROI(1).bckgrdy)));
end

backgrdcrrt = avg_neuron-avg_back; % subtract background
baselineF = mean(backgrdcrrt(1:10)); % take first 10 frames as baseline fluorescence
delta_F = ((backgrdcrrt - baselineF) ./ baselineF) * 100; % calculate DF/F
Delta_R_Figure = figure('Color',[1 1 1]);
plot(delta_F); % plot DF/F
ylabel('\DeltaF/F (%)');
xlabel('Time ');

saveas(Delta_R_Figure,[mypath filesep 'Delta_F_Figure_' filename '.fig'],'fig'); % save this plot as fig
saveas(Delta_R_Figure,[mypath filesep 'Delta_F_Figure_' filename '.jpg'],'jpg'); % save this plot as jpeg
filename = ['GCAMP_Analysis_' filename '.mat'];
save ([mypath filename],'avg_neuron','avg_back','baselineF','delta_F'); % save actual numerical vals in Mat file



function moveimage(snd,evnt)
% accessory function to advance,reverse frames and to exit analysis
if(isequal(evnt.Key,'x'))
    ROI = getappdata(snd,'ROI');
    assignin('caller','ROI',ROI); % save user defined ROI values to workspace
    close(snd);return;
end


frame = getappdata(snd,'frame'); % collect app data from figure (snd)
ROI = getappdata(snd,'ROI');
stack = getappdata(snd,'imgs');
ZXlim = getappdata(snd,'ZXlim'); 
ZYlim = getappdata(snd,'ZYlim');
cm = getappdata(snd,'cm');
firstcdata = getappdata(snd,'firstcdata');


if(isequal(evnt.Key,'period') && frame < length(stack))
    frame = frame + 1; % advance
elseif(isequal(evnt.Key,'comma') && frame > 1)
    frame = frame - 1; % reverse
end

npoly = findobj('Tag','impoly'); % if user clicked image find its modified ROI encoded as impoly function
if(isempty(npoly) && frame > 0)
    ROI(frame) = ROI(frame -1); % if ROI is same update same position for this frame
else
    api=iptgetapi(npoly(1)); % save new position of altered ROI
    temp = api.getPosition();
    ROI(frame).neuronx = temp(:,1);
    ROI(frame).neurony = temp(:,2);
end

imagesc(stack(frame).data,'Parent',get(snd,'CurrentAxes'),'ButtonDownFcn',@moveROI); % redraw new frame in figure

colormap(cm);set(get(snd,'CurrentAxes'),'XTickLabel',[],'YTickLabel',[],'XTick',[],'YTick',[],'Clim',firstcdata);
set(get(snd,'CurrentAxes'),'XLim',ZXlim,'YLim',ZYlim);
title({'Use < or > to step through stack, Press x to finish','click image to reset ROI',[num2str(frame) ' / ' num2str(length(stack))]});
hold on
line(ROI(frame).neuronx,ROI(frame).neurony,'Color',[1 0 0 ],'Parent',get(snd,'CurrentAxes'));
hold off

if(isequal(frame,length(stack))) % let user know they reached the end of the stack
   set(snd,'Color',[1 0 0]);
  title({[num2str(frame) ' / ' num2str(length(stack))],'Press X to finish'});
end

setappdata(snd,'frame',frame); % save frame data and ROI data to figure data
setappdata(snd,'ROI',ROI);

function moveROI(snd,~)
%accessory function to modify ROI in case neuron moves 
frame = getappdata(get(get(snd,'Parent'),'Parent'),'frame');
ROI = getappdata(get(get(snd,'Parent'),'Parent'),'ROI');
delete(findobj('Color','r')) % remove line where previous ROI was
npoly = impoly(get(snd,'Parent'),[ROI(frame).neuronx ROI(frame).neurony],'Closed','true'); %make a changable object 
setColor(npoly,'red'); 

