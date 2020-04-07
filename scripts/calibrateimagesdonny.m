function calibrateimages;
c = clock;
path = ['C:\ThermoAssays\' num2str(c(2)) '.' num2str(c(1)) filesep];
fn = 1;
while ~isequal(fn,0) % 0 = output value of uigetfile if user clicks "cancel"
    [fn,path]=uigetfile([path '*.*'],'Select image file and CLICK PLATE EDGES; or click "cancel"');
    if ~isequal(fn,0) % a file was chosen
        pic = imread([path filesep fn]); % read in chosen image


        imagesc(pic);                % display chosen image
        title(fn,'Interpreter','none');
        [x,y] = ginput(2);           % get edges of plate
        leftbound = min(x);
        rightbound = max(x);
        out = [leftbound, rightbound]; % output plate edges in correct order
        temprangechar = strfind(path,'@');
        if(~isempty(temprangechar))
            rangechar =  strfind(path(temprangechar:end),'-');
            lowtemp = str2double(path(temprangechar+1:temprangechar+rangechar-2));
            hitemp = str2double(path(temprangechar+rangechar:end-1));
            if(isequal(fn(end-3:end),'.jpg'))
                csvwrite([path filesep fn(1:end-9) 'cal.csv'],[out lowtemp hitemp]);
            else
                csvwrite([path filesep fn(1:end-5) 'cal.csv'],[out lowtemp hitemp]);
            end
        else
                        if(isequal(fn(end-3:end),'.jpg'))
                               csvwrite([path filesep fn(1:end-9) 'cal.csv'],out);
                        else
                            csvwrite([path filesep fn(1:end-5) 'cal.csv'],out); % write edges to comma separated value file
                        
                        end
                        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %ADD MIN/MAX Ts to cal file so that future scripts know
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    end; % if file was chosen
end; % user clicked cancel and finished choosing files
return;

