function data_height_plot(data_palm, height, u_time,sign,input1,hand,on_off)

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

       % (1) select start of test point and (2) end of pinch task 
       %marked by object going back down to zero height
       st_2_pi{n} = ginput(2);  % row 1 -- (x,y) of pt1, row 2 -- (x,y) of pt2
       
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

if any(convertCharsToStrings(on_off) == "on") 
    if ismac % Preeya computer
    path_to_data = '/Users/preeyakhanna/Dropbox/Ganguly_Lab/Projects/HP_Sensorized_Object/doses-kincode/';
    slash = '/'; 

    else % Tom computer 
        path_to_data = 'C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\doses-kincode-main\'; 
        slash = '\'; 
    
    end
    %if on_off variable is 'on', indices of each trial will be saved in the
    %below folder
    Filename = string(strcat(path_to_data,slash,'data\tom_data\start_2_pinch_data\', input1, '_st_2_pi_',hand,'.mat'));
    save(Filename,'st_2_pi')
end


end