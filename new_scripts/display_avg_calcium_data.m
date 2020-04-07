% This script will plot an average trace of the BLC_raw_delta_F or delta_F
% from a group of files, blcrrt, GCaMP_Analysis or FRET_Analysis. It also 
% plots the error bars. 
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
    if exist('BLC_raw_delta_F')==1
        lengths(end+1) = length(BLC_raw_delta_F);
        display(c).raw_delta_F = BLC_raw_delta_F;
        display(c).temps = temp;
    elseif exist('blc')==1
        lengths(end+1) = length(blc);
        display(c).raw_delta_F = blc;
        display(c).temps = resampletemp;
    else 
        lengths(end+1) = length(delta_F);
        display(c).raw_delta_F = delta_F;
        display(c).temps = Temperature;
    end
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

if length(display)==1
    avgdeltafs = display.raw_delta_F;
    avgtemps = display.temps;
    semdeltafs = zeros(1, length(display.raw_delta_F));
elseif length(display) > 1
    avgdeltafs = mean(raw_deltafs);
    semdeltafs = nanstd(raw_deltafs) ./ sqrt(size(raw_deltafs,1));
    avgtemps = nanmean(temps);
    stddeltafs = nanstd(raw_deltafs);
end
set(0,'DefaultFigurePosition',[100 100 1000 1000])

%HL1 = line( [(1:samples); (1:samples)], [(avgdeltafs - semdeltafs); (avgdeltafs + semdeltafs)],'Color', [.8 .8 1]);
%the above line is for error bars
hold on
[AX,H1,HT] = plotyy(1:samples,avgdeltafs,1:samples,avgtemps);
set(AX(1),'XLim',[0 samples ],'YLim',[round(min(avgdeltafs))-5 (max(avgdeltafs)+10)], 'ytick',[-10:10:max(avgdeltafs)+10], 'LineWidth', 2, 'FontSize', 13);
set(AX(2),'XLim',[0 samples ],'YLim',[round(min(avgtemps))-1 max(avgtemps)+1], 'ytick',[round(min(avgtemps)):1:max(avgtemps)+1],'LineWidth', 2, 'FontSize', 13);
set(AX(1),'Box','off')
%set(H1, 'LineWidth', 2)
HL1 = shadedErrorBar([1:samples], [avgdeltafs], [semdeltafs], {'-g', 'Linewidth', 1.5}, 1);


%%%% If you want to change the colors, this will have to be done manually.
%%%% See above in the shadedErrorBar line. To change data
%%%% color, use the set command for the HL1 handle for calcium data or error bars, or the 
%%%%  HT handle for temperature........
%%%% set(HL1.mainLine, 'color', 'g'), for example, will set the calcium trace to 
%%%% green. Alternatively set(HL1.patch, 'facecolor', 'r') would set the error
%%%% to red. You can use RGB code as well. 
%%%% Ex - set(HL1.mainLine, 'color', [.8 .8 1]). This gives wider variety
%%%% of colors. Look up the ones you need online.