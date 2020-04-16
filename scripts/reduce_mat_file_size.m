clear;
diroffiles  = uigetdir('..');
dir_struct = dir(diroffiles);
for eachfile = 1:length(dir_struct)
    if(length(dir_struct(eachfile).name)>2)
        contents = dir([diroffiles filesep dir_struct(eachfile).name filesep '*.mat' ]);
        if(~isempty(contents))
            for eachfile2 = 1:length(contents)
                if(isequal(contents(eachfile2).name(1:3),'blc'))
                   continue; 
                end
                disp([diroffiles filesep dir_struct(eachfile).name filesep contents(eachfile2).name]);
                try
                load([diroffiles filesep dir_struct(eachfile).name filesep contents(eachfile2).name]);
                catch
                   disp('Cannot read file');
                   delete( [diroffiles filesep dir_struct(eachfile).name filesep contents(eachfile2).name]);
                   continue;
                end
                
                clear stack Total_Data Images Lab_View_File BG Image1 L_Neuron
                clear R_Neuron L_Neuron_BG_Im R_Neuron_BG_Im L_Neuron_Im
                clear L_Neuron_loc R_Neuron_Im R_Neuron_loc IX L_IX L_Neuron_BG
                clear L_Neuron_Pixels R_Neuron_BG R_Neuron_Pixels T_file M
                clear AX Delta_R_Figure H1 H2 L Neuron_Pixel_Size axes_Delta_R
                clear f
                

                delete([diroffiles filesep dir_struct(eachfile).name filesep contents(eachfile2).name]);
                disp(['Saving: ' dir_struct(eachfile).name filesep contents(eachfile2).name]);
                save([diroffiles filesep dir_struct(eachfile).name filesep contents(eachfile2).name]);
            end
        end
    end
end