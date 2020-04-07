clear; close all
dir_of_files = uigetdir;
images = dir([dir_of_files '/*.tif']);
GC = [];
j = 1;
for i = 1:length(images)
     if(length(images(i).name) >4 && isequal(images(i).name(end-3:end),'.tif'))
          
          A = imread([dir_of_files '/' images(i).name]);
          cell(j).total = A;
          figure();
          set(0,'DefaultFigurePosition',[100 100 1000 1000]);
          imagesc(cell(j).total)
          axis xy;
          
          title('Select the cell')
          e = imellipse
          cell(j).position = wait(e);
          x_position = cell(j).position(:,1);
          y_position = cell(j).position(:,2);
          
          x_length = max(x_position - min(x_position));
          y_length = max(y_position - min(y_position));
          
          x_center = mean(x_position);
          y_center = mean(y_position);
          
          % Create an ellipse shaped mask
          c = ([y_center x_center]);   %# Ellipse center point (y, x)
          r_sq = [x_length/2, y_length/2] .^ 2;  %# Ellipse radii squared (y-axis, x-axis)
          [X, Y] = meshgrid(1:size(A, 2), 1:size(A, 1));
          ellipse_mask = (r_sq(2) * (X - c(2)) .^ 2 + ...
              r_sq(1) * (Y - c(1)) .^ 2 <= prod(r_sq));
          
          % Apply the mask to the image
          cell_cropped = bsxfun(@times, A, uint16(ellipse_mask));
          cell_cropped = double(cell_cropped);
          cell_cropped(cell_cropped == 0) = nan;
          cell(j).soma = cell_cropped;
          
          
          title('Select a representative region of the background')
          hh = imrect
          cell(j).BG_position = wait(hh);
          BG_position = round(cell(j).BG_position);
          
          close
          
          x_BG = (BG_position(1):BG_position(1)+BG_position(3));
          y_BG = (BG_position(2):BG_position(2)+BG_position(4));
          cell(j).BG = cell(j).total(y_BG, x_BG);
          
          mean_BG = mean(mean(cell(j).BG));
          
          cell(j).mean_BG = mean_BG;
          
          cell(j).corrected_soma = cell(j).soma - mean_BG;
          
          cell(j).intensity = nanmean(nanmean(cell(j).corrected_soma));
          
          j = j+1;
     end
end

k = strfind(dir_of_files, 'Tc');
name = dir_of_files(k:end);
name = strrep(name, '/', '_');
new_file = ['Neuron_Intensity_' name];
save([dir_of_files '/' new_file])

%%%%%%%%%%%%%



% A = imread('lion.jpeg');
% 
% imagesc(A)
% 
% e = imellipse
% position = wait(e);
% x_position = position(:,1);
% y_position = position(:,2);
% 
% x_length = max(x_position - min(x_position));
% y_length = max(y_position - min(y_position));
% 
% x_center = mean(x_position);
% y_center = mean(y_position);
% 
% 
% 
% 
% %# Create an ellipse shaped mask
% c = ([y_center x_center]);   %# Ellipse center point (y, x)
% r_sq = [x_length/2, y_length/2] .^ 2;  %# Ellipse radii squared (y-axis, x-axis)
% [X, Y] = meshgrid(1:size(A, 2), 1:size(A, 1));
% ellipse_mask = (r_sq(2) * (X - c(2)) .^ 2 + ...
%     r_sq(1) * (Y - c(1)) .^ 2 <= prod(r_sq));
% 
% %# Apply the mask to the image
% A_cropped = bsxfun(@times, A, uint8(ellipse_mask));
% A_cropped = double(A_cropped);
% A_cropped(A_cropped == 0) = nan;