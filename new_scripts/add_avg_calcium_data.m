% This script will add an average trace of the BLC_raw_delta_F or delta_F
% from a group of files, blcrrt, GCaMP_Analysis or FRET_Analysis to an existing graph. It also 
% plots the error bars. 

dir_of_files = uigetdir;
D = dir(dir_of_files);
s = what(dir_of_files);
files = s.mat;
c = 1;
lengths =[];
display2 = [];

for m = 1:numel(files)
    load([dir_of_files '/' char(files(m))]);
    filename = char(files(m));
    if exist('BLC_raw_delta_F')==1
        lengths(end+1) = length(BLC_raw_delta_F);
        display2(c).raw_delta_F = BLC_raw_delta_F;
        display2(c).temps = temp;
    elseif exist('blc')==1
        lengths(end+1) = length(blc);
        display2(c).raw_delta_F = blc;
        display2(c).temps = resampletemp;
    else
        lengths(end+1) = length(delta_F);
        display2(c).raw_delta_F = delta_F;
        display2(c).temps = Temperature;
    end
    c = c+1;
end

min_length = min(lengths);
samples = min_length;

for j = 1:length(display2)
        display2(j).temps = display2(j).temps(1:min_length);
        display2(j).raw_delta_F = display2(j).raw_delta_F(1:min_length);
end

raw_deltafs2 = vertcat(display2.raw_delta_F);

temps2 = vertcat(display2.temps);

if length(display2)==1
    avgdeltafs2 = display2.raw_delta_F;
    avgtemps2 = display2.temps;
    semdeltafs2 = zeros(1, length(display2.raw_delta_F));
elseif length(display) > 1
    avgdeltafs2 = mean(raw_deltafs2);
    semdeltafs2 = nanstd(raw_deltafs2) ./ sqrt(size(raw_deltafs2,1));
    avgtemps2 = nanmean(temps2);
end

hold on

if exist('HL9')==1
    HL10 = shadedErrorBar([1:samples], [avgdeltafs2], [semdeltafs2], {'-g', 'Linewidth', 1.5}, 1);    
elseif exist('HL8')==1
    HL9 = shadedErrorBar([1:samples], [avgdeltafs2], [semdeltafs2], {'-g', 'Linewidth', 1.5}, 1);
elseif exist('HL7')==1
    HL8 = shadedErrorBar([1:samples], [avgdeltafs2], [semdeltafs2], {'-g', 'Linewidth', 1.5}, 1);
elseif exist('HL6')==1
    HL7 = shadedErrorBar([1:samples], [avgdeltafs2], [semdeltafs2], {'-g', 'Linewidth', 1.5}, 1);
elseif exist('HL5')==1
    HL6 = shadedErrorBar([1:samples], [avgdeltafs2], [semdeltafs2], {'-g', 'Linewidth', 1.5}, 1);
elseif exist('HL4')==1
    HL5 = shadedErrorBar([1:samples], [avgdeltafs2], [semdeltafs2], {'-g', 'Linewidth', 1.5}, 1);
elseif exist('HL3')==1
    HL4 = shadedErrorBar([1:samples], [avgdeltafs2], [semdeltafs2], {'-g', 'Linewidth', 1.5}, 1);
elseif exist('HL2')==1
    HL3 = shadedErrorBar([1:samples], [avgdeltafs2], [semdeltafs2], {'-r', 'Linewidth', 1.5}, 1);
else
    HL2 = shadedErrorBar([1:samples], [avgdeltafs2], [semdeltafs2], {'-b', 'Linewidth', 1.5}, 1);
end

%%%% If you want to change the colors, this will have to be done manually.
%%%% See above in the shadedErrorBar line. To change data
%%%% color, use the set command for the HL2 or HL3 or HL(insert handle number) handle for calcium data
%%%% or error bars for that specific handle. You must keep track yourself
%%%% which trace is which!!!!!
%%%% set(HL2.mainLine, 'color', 'g'), for example, will set the second calcium trace to 
%%%% green. Alternatively set(HL2.patch, 'facecolor', 'r') would set the error
%%%% of the second trace to red. You can use RGB code as well. 
%%%% Ex - set(HL1.mainLine, 'color', [.8 .8 1]). This gives wider variety
%%%% of colors. Look up the ones you need online, someone will have figured
%%%% it out.