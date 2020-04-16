# Temperature_Calcium_Imaging_Single_Neuron
Scripts for measuring delta F/F and T*. Mostly written by Harry Bell.

Information directly from Harry Bell:

Here is a description of the imaging-related MATLAB scripts.

1. baseline_correct_universal - this will baseline correct any calcium trace, gcamp or fret, AFD or AWC or whatever. It will do one trace/file at a time. 
You'll have a folder containing all your GCaMP_Analysis.mat or FRET_Analysis.mat files for a given genotype before running it. The first time you run it, select the first file in the folder. When you finish correcting that trace, it creates a folder within that folder called 'BLC' and saves a new blcrrt.mat file in there. Then run it on the rest of your files and they will all have blcrrt.mat files created in that same BLC folder. I recommend numbering your GCaMP_Analysis.mat or FRET_Analysis.mat files at the end of the file name, with a two-digit code, like GCaMP_Analysis_01.mat or FRET_Analysis_01.mat. This way the new file will appear as blccrt_01.mat, in either case. 

2. find_T_star_oscillation - this works just like the find_T_star from before, but only works on single blcrrt.mat files mentioned above. This will also work on any calcium trace, gcamp or fret. This is labeled as 'oscillation' because it is specialized for these experiments. I did away with the former approach of baseline correcting all traces at once because this causes you to redo all of them if you have to add any. If you have old data that you corrected all at once like this and you don’t want to re-correct, you’ll have to use the old find_T_star_blc_multiple script on those. 

3. find_T_star_linear - this is the same as above but meant for experiments with linear ramps. In this one, you will find the T* just like the above script, but then you will also have a second graph of delta_F in which you will click the min, then max of the fret peak. I did this with a clicking tool because autofinding the peak is troublesome in this case. Just make sure you click min, then max. If you click again after that by accident, it won’t matter. Just the first two matter. I recommend just running this on uncorrected files since there aren't repeated peaks. Baseline correcting a trace from a linear ramp is a bad idea in my opinion.

4. data_mean_sem_calc_T_star – this acts as a companion to the above T_star scripts. It will calculate mean, std, sem, and N for the dataset. It will prompt for a file – choose the T_star_numbers file from the dataset. It then spits out the raw data of amplitudes and T_star, as well as the mean, std and sem for each. The variable names are fairly obvious.

5. Ca_events_GCaMP - this is for finding the stochastic events characteristic of AWC. You'll run this on blccrt.mat files from 1). It will display each trace and you will click on the peaks of each calcium event in the trace. It will only save the peak/location of the ones you click on. It also saves the time spent above baseline, the area above baseline, frequency of the events, and the number of events in each trace. It saves a file called Ca_events.mat. It is set for a sampling rate of 2 frames/sec and baseline calcium of 5% as threshold. You'll need to change that if you want something different. It is indicated within the script.

6. data_mean_sem_calc_Ca_events  - this acts as a companion to the above Ca_events_GCaMP script. It will prompt for a file – choose the Ca_events file from the dataset. It then spits out the raw data of amplitudes, number(#of events observed), frequency time above baseline, area above baseline, as well as the mean, std and sem for each. Again, the variable names are fairly obvious.

7. display_avg_calcium_data - this will average and display with error bars any group of files, fret or gcamp, blccrt or not. I tried to make the axes and such as flexible as possible according to what the data are but you may have to change it to make it perfect. There are handles to each axes and error bar set, as explained within the script. If you have trouble with editing them, please ask Mike about the handles. Me and him went through it before. Failing that, email me.

8. add_avg_calcium_data – this works as an add on. It appends a new trace to the one you made with display_avg_calcium_data. Just keep track of which trace is which yourself when plotting more than one at a time. You can edit the colors afterward or as you go with the handles, as I mentioned above.

9. plot_multiple_calcium_heatmap - this will make a heatmap of any group of files, fret or gcamp, blcrrt or not. It will prompt you for how long your experiment is, in frames. Just enter the number of frames you would like plotted and press enter.

10. for fun.....calcium_sphere - drag any blcrrt file made with above scripts into matlab and run this. Isn’t that kewl!?!?!?!?


Now, when you need to extract the data the scripts have processed, all you will need to do is call the correct variables.

For T_star data or Ca_events data, just use the respective data_mean_sem_calc scripts and this spits out the data in a very clearly named way. 

In the event you need to make an average trace in a program other than MATLAB(which is probably going to be the case), this is how to get the data you need:

Run the display_avg_calcium_data script on your folder of mat files. You’ll need to remove the T_star_numbers file if you have one in the folder. I recommend just making another subfolder for that file. Once you have selected the folder and generated the average trace, you can access the following data:

avgdeltafs : the average of all the trials
semdeltafs: standard error of the average trace (error bars) 
stddeltafs : standard deviation of the average trace
avgtemps : the average temperature trace from all the trials

You may notice if you just type them in, the come out as one long row. If you want a column, just add a ‘ to the end 

Ex – avgdeltafs will give a row
        avgdeltafs’ will give a column, easier to transfer by copy/paste.
