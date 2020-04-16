clear all;
%close all;

[FileName,PathName] = uigetfile('/Volumes/home/bev/behavior/cryocalibration/*.mat');
load([PathName filesep FileName]);

from_turns = [];
to_turns = [];
for i = 1:length(data_summary.turns.from_angle)
    from_turns = [from_turns; data_summary.turns.from_angle{1}(:)]; 
    to_turns = [to_turns; data_summary.turns.to_angle{1}(:)]; 
end

[to_turns from_turns (to_turns - from_turns)]


diff_angle_deg = (to_turns - from_turns) .* (180/pi);

figure
vals = sort(abs(diff_angle_deg))
y = histc(vals,1:10:360)
hist((y./data_summary.plates.num_of_plates),1:10:360) 