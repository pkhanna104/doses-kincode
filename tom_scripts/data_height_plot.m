function [exc_data] = data_height_plot(data_palm, height, u_time,sign,input1,hand,on_off)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plotting raw data 10 trials from Preeya -> palm height vs data point in array (not
%time!!!)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if any(convertCharsToStrings(hand) == "un")
    fn1 = 1;
    fn2 = 2;
elseif any(convertCharsToStrings(hand) == "aff")
    fn1 = 4;
    fn2 = 5;
end

for n = 1:10;
   
   if any(convertCharsToStrings(on_off) == "on") 
       %plots palm heigh raw data vs data point in array
       figure(fn1)
       subplot(5,2,n)
       dp = sign.*data_palm{n}(:,3);
       yyaxis left
       plot(dp,'b'); 
       yyaxis right
       plot(height{n}, 'r'); 
       ylabel('Obj Z-Height (cm)')
       yyaxis left
       ylabel('Palm Z-Height (cm)')
       xlabel('Point in Array')
    
       %plots palm height raw data vs time according to raw time data split into
       %ten trials (ten trials split is calculated from jt_angle_split.m
       figure(fn2)
       subplot(5,2,n)
       dp = sign.*data_palm{n}(:,3);
       yyaxis left
       plot(u_time{n},dp,'b'); 
       yyaxis right
       plot(u_time{n}, height{n}, 'r'); 
       ylabel('Palm Z-Height (cm)')
       xlabel('time (sec)')
   end
end

if  any(convertCharsToStrings(hand) == "aff")
    raw_d = 'B16:C25';
    cells = 'I16:J25';
    tcells = 'I3:L22';
elseif any(convertCharsToStrings(hand) == "un")
    raw_d = 'B3:C12'; % raw data points -> values in array from start of test to end of test (not including resting points)
    cells = 'I3:J12'; %interpolated data from start to end of pinch task data point 
    %after plotting raw data vs data point in array (fig 1 or 4), I clicked on the plot to get obtain the starting point
    %and end of pinch task (what I really care about here is column J12 since I plot [1:end of pinch task data point])
    tcells = 'B3:E22'; %time values from start to trial finsih -> 0 to end of trial
end
   
%start of trial to end of trial.  Used for plotting palm height vs value in array (not units of time, what
%above fig 1 and 4 is plotting)
exc_data.(hand).raw = xlsread('discrete trial points 1 through 10_single_average_v2', input1, raw_d);

%median length of trials
exc_data.(hand).median = median(exc_data.(hand).raw(:,2));

%Once values in array that determine start and end of test have been
%selected, data is replotted from start to end (fig 3 and 5 in blue).  
%red curve in fig 3 and 6 correspond to start of pinch task to end of pinch
%task using interpolated data points.  The end of the pinch task data point
%was manually determined from fig 3 and 6 and inputted into second column
%of "cells" variable
exc_data.(hand).s2p = xlsread('discrete trial points 1 through 10_single_average_v2', input1, cells);

%start of trial to end of trial starting at 0 seconds -> units of
%seconds...manually recorde into excel from fig 2 and 5 
exc_data.(hand).t_times = xlsread('discrete trial points 1 through 10_v2', input1, tcells);


end