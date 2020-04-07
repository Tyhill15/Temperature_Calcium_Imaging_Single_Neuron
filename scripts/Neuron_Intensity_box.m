clear; close all
dir_of_files = uigetdir;
images = dir([dir_of_files '/*.tif']);
GC = [];
c = 1;
for i = 1:length(images)
     if(length(images(i).name) >4 && isequal(images(i).name(end-3:end),'.tif'))
          
          cell(c).total = imread([dir_of_files '/' images(i).name]);
          figure();
          set(0,'DefaultFigurePosition',[100 100 2000 2000]);
          imagesc(cell(c).total)
          axis xy;
          
          title('Select the cell')
          h = imrect
          cell(c).position = wait(h);
          cell_position = round(cell(c).position);
          
          title('Select a representative region of the background')
          hh = imrect
          cell(c).BG_position = wait(hh);
          BG_position = round(cell(c).BG_position);
          
          close
          
          x_cell = (cell_position(1):cell_position(1)+cell_position(3));
          y_cell = (cell_position(2):cell_position(2)+cell_position(4));
          cell(c).soma = cell(c).total(y_cell, x_cell);
          
          x_BG = (BG_position(1):BG_position(1)+BG_position(3));
          y_BG = (BG_position(2):BG_position(2)+BG_position(4));
          cell(c).BG = cell(c).total(y_BG, x_BG);
          
          mean_BG = mean(mean(cell(c).BG));
          
          cell(c).corrected_soma = cell(c).soma - mean_BG;
          
          cell(c).intensity = mean(mean(cell(c).corrected_soma));
          
          c = c+1;
     end
end

k = strfind(dir_of_files, 'Tc');
name = dir_of_files(k:end);
name = strrep(name, '/', '_');
new_file = ['Neuron_Intensity_' name];
save([dir_of_files '/' new_file])



%[dir_of_files '/' images(1).name(1:end-4)]
%movefile([filename, '.mat'], dir_of_files)
            