clear; clc;close all;
load 'W16H_small_pinch_data.mat';
input1 = 'W16H';  %reference to excell sheet number/file
input = 'W16H_small'; %reference to angles produced from Preeya and parsed using my function jt_angle_calc(_aff)
%use S13J_small, W16H_small, R15J_small
sign = 1;  %1 for patients, -1 for controls -> z-axis flipped!!!

%%%%%%%%%%%%%%%  unaffected hand %%%%%%%%%%%%%%%%%%%%%%%%%
Filename = string(strcat('C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\Four healthy subject data\',input,'_jt_angle_un.mat'));
load ([Filename]);
[zscore_mean, zscore_std,u_height,unaffect_all,data_palm,force,unaffect,u_time,sam_p_sec] = jt_angle_calc(unaffected,angle_struct,input1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plotting raw data 10 trials from Preeya -> palm height vs data point in array (not
%time!!!)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for n = 1:10;
   figure(1)
   subplot(5,2,n)
   dp = sign.*data_palm{n}(:,3);
   plot(dp,'b'); 
   ylabel('Palm Z-Height (cm)')
   xlabel('Point in Array')

   figure(2)
   subplot(5,2,n)
   dp = sign.*data_palm{n}(:,3);
   plot(u_time{n},dp,'b'); 
   ylabel('Palm Z-Height (cm)')
   xlabel('time (sec)')
end
%start of trial to end of trial.  Used for plotting palm height vs value in array (not units of time, what
%above is plotting)
excel_ut_real = xlsread('discrete trial points 1 through 10_single_average', input1, 'Z3:AA12');
%median length of trials
excel_ut_length = median(excel_ut_real(:,2));

%Once values in array that determine start and end of test have been
%selected, data is replotted from start to end and the value in new array
%indicating end of pinch test is used...seemed easier to manually do this
%(we care only about second column in this matrix)
excel_u = xlsread('discrete trial points 1 through 10_single_average', input1, 'AG3:AH12');

%start of trial to end of trial starting at 0 seconds -> units of
%seconds...manually recorde into excel :( 
u_times = xlsread('discrete trial points 1 through 10', input1, 'B3:E22');

count = 1;
k = 1;
for n = 1:10;
    dp = sign.*data_palm{n}(:,3);
    dp_new = dp(excel_ut_real(n,1):excel_ut_real(n,2));  %full trial length
    dp = interp1([1:length(dp_new)],dp_new,[1:excel_ut_length]);  %interpolate data so all same length to median trial
    %a lot of interpolated arrays contain NaN's even though all same length
    %now for all ten trials...all we care about is values in array starting
    %at 1st point to end of pinch test

    u_trial = linspace(0,u_times(k+1,4)-u_times(1,1),length(dp)); k = k + 2;  
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
   %below plots showing palm region for analysis in red -> palm height vs.
   %location in array -> start of task to end of pinch task
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   figure(3)
   subplot(5,2,n)
   plot(dp,'b');hold on;
   plot(dp(1:excel_u(n,2)),'r','LineWidth',3)
   ylabel('Palm Z-Height (cm)')
   xlabel('Time (sec)')
   
  ms = [1 7 11];
  %p = [2:2:8];
  k = 3;
    for m = 1:12
       test = unaffect_all{1,n}(:,m);
       test(test > 180) = test(test > 180) - 360;

       u_o = zscore(test);
       u_new = u_o(excel_ut_real(n,1):excel_ut_real(n,2));  %zscored data from trial start to trial end
       u{n,m} = interp1([1:length(u_new)],u_new,[1:excel_ut_length]); %interpolate data to have same length as median trial length


       %un-zcored data
       u_n = test; 
       %interpolate data to have same length as median trial length
       u_unz{n,m} = interp1([1:length(u_n(excel_ut_real(n,1):excel_ut_real(n,2)))],u_n(excel_ut_real(n,1):excel_ut_real(n,2)),[1:excel_ut_length]);
       u_start = u_unz{n,m};
       %data from start to end of pinch task with length of array = median trial
       %lenth
       
       u_unz_2_pinch{n,m} = u_start(1:excel_u(n,2));

       %calculate standard deviation (what we are calling rom) not taking into account nan at end of
       %array (not all arrays same length so median trial might be longer
       %than a couple of the trials
       
       u_rom{n,m} = nanstd(u_unz{n,m});  
       u_rom_2_pinch{n,m} = nanstd(u_unz_2_pinch{n,m});

    end
end


for n = 1:10;
    for m = 1:12
        %median angles of not z scored data from start to end of pinch,
        %same lengths as median trial
        un_raw{n,m} = median(cell2mat(u_unz(:,m))) - cell2mat(u_unz(:,m));
        un_raw{n,m} = un_raw{n,m}(1:excel_u(n,2));
        median_trial_data_u{m} = median(cell2mat(u_unz(:,m)));

        %median angles of zscored data from start to end, same length as median trial
        u_mean{m} = median(cell2mat(u(:,m)));
        %median rom of "un" zscored data from start to end, same length as
        %median trial
        u_mean_rom(m) = median(cell2mat(u_rom(:,m)));
        %median rom of "un" zscored data from start to end of pinch task, same length as
        %median trial
        u_mean_rom_2_pinch(m) = median(cell2mat(u_rom_2_pinch(:,m)));

        
        
            
        if any(isnan(u_mean{m}))  %some of the u_mean vectors have NaN at the end!!!
            ones = find(isnan(u_mean{m}));
            excel_u(n,2) = ones(1)-1;
        end
        
        %for both start through pinch task ---- no return -> mse
        %calculation 
         u_mse{n,m} = (1/length(u{n,m}(1:excel_u(n,2)))).*sum((u{n,m}(1:excel_u(n,2))-u_mean{m}(1:excel_u(n,2))).^2);
         u_mse_2_pinch{n,m} = (1/length(u{n,m}(1:excel_u(n,2)))).*sum((u{n,m}(1:excel_u(n,2))-u_mean{m}(1:excel_u(n,2))).^2);
         
          
    end
end
 C = nchoosek([1:10],5);
 %bootstrap without replacement unaffect ROM!  -> used for determinng
 %"normal data
 for m = 1:12
        for k = 1:size(nchoosek([1:10],5),1)
            u_mse_train = median(cell2mat(u_mse(C(k,:),m)));
            u_mse_test = median(setdiff(cell2mat(u_mse(:,m)),cell2mat(u_mse(C(k,:),m))));
            u_mse_norm(k) = (u_mse_test - u_mse_train) ./ u_mse_train;
            
            u_rom_train = median(cell2mat(u_rom(C(k,:),m)));
            u_rom_test = median(setdiff(cell2mat(u_rom(:,m)),cell2mat(u_rom(C(k,:),m))));
            u_rom_norm(k) = (u_rom_test - u_rom_train) ./ u_rom_train;
        end       
 end
        u_rom_norm_mean(m) = mean(u_rom_norm);
        u_rom_norm_std(m) = 2.*std(u_rom_norm);
        
        u_mse_norm_mean(m) = mean(u_mse_norm);
        u_mse_norm_std(m) = 2.*std(u_mse_norm);


%%%%%%%%%%%%%%%  affected hand %%%%%%%%%%%%%%%%%%%%%%%%%
Filename = string(strcat('C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\Four healthy subject data\',input,'_jt_angle_aff.mat'));
load ([Filename]);
[zscore_mean, zscore_std,u_height,unaffect_all,data_palm,force,unaffect,u_time,sam_p_sec] = jt_angle_calc_aff(affected,angle_struct,input1);
aff_raw = unaffect_all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plotting raw data 10 trials from Preeya -> palm height vs data point in array (not
%time!!!)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for n = 1:10;
   figure(4)
   subplot(5,2,n)
   dp = sign.*data_palm{n}(:,3);
   plot(dp,'b'); 
   ylabel('Palm Z-Height (cm)')
   xlabel('Point in Array')

   figure(5)
   subplot(5,2,n)
   dp = sign.*data_palm{n}(:,3);
   plot(u_time{n},dp,'b'); 
   ylabel('Palm Z-Height (cm)')
   xlabel('time (sec)')
end

excel_at_real = xlsread('discrete trial points 1 through 10_single_average', input1, 'Z16:AA25');
excel_at_length = median(excel_at_real(:,2));
excel_a = xlsread('discrete trial points 1 through 10_single_average', input1, 'AG16:AH25');
a_times = xlsread('discrete trial points 1 through 10', input1, 'I3:L22');

count = 1;
k = 1;
for n = 1:10;
%    figure(11)
   dp = sign.*data_palm{n}(:,3);
   dp_new = dp(excel_at_real(n,1):excel_at_real(n,2));
   dp = interp1([1:length(dp_new)],dp_new,[1:excel_at_length]);
   a_trial = linspace(0,a_times(k+1,4)-a_times(1,1),length(dp)); k = k + 2;

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
   %below plots showing palm region for analysis in red -> palm height vs.
   %location in array -> start of task to end of pinch task
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   figure(6)
   subplot(5,2,n)
   plot(dp,'b');hold on;
   plot(dp(1:excel_a(n,2)),'r','LineWidth',3)
   ylabel('Palm Z-Height (cm)')
   xlabel('Position in array')
   
    for m = 1:12
       test = unaffect_all{1,n}(:,m);
       test(test > 180) = test(test > 180) - 360;
       
        a_o = zscore(test);
        a_new = a_o(excel_at_real(n,1):excel_at_real(n,2));
        a{n,m} = interp1([1:length(a_new)],a_new,[1:excel_at_length]);
         
        a_n = test;
        a_unz{n,m} = interp1([1:length(a_n(excel_at_real(n,1):excel_at_real(n,2)))],a_n(excel_at_real(n,1):excel_at_real(n,2)),[1:excel_at_length]);
        a_start = a_unz{n,m};
        
        a_unz_2_pinch{n,m} = a_start(1:excel_a(n,2));

        a_rom{n,m} = nanstd(a_unz{n,m}) ;
        a_rom_2_pinch{n,m} = nanstd(a_unz_2_pinch{n,m});
   end
end       

for n = 1:10;
    for m = 1:12
        %median angles of not z scored data from start to end of pinch,
        %same lengths as median trial
        aff_raw{n,m} = median(cell2mat(a_unz(:,m))) - cell2mat(a_unz(:,m));
        aff_raw{n,m} = aff_raw{n,m}(1:excel_a(n,2));
        median_trial_data_a{m} = median(cell2mat(a_unz(:,m)));

        %figure(9)
        %subplot(6,2,m)
        a_mean{m} = median(cell2mat(a(:,m)));
        %plot(a_mean{m},'k','LineWidth',2);hold on;
        
         
         a_mean_rom(m) = median(cell2mat(a_rom(:,m)));
         a_mean_rom_2_pinch(m) = median(cell2mat(a_rom_2_pinch(:,m)));

       
        if any(isnan(a_mean{m}))  %some of the a_mean vectors have NaN at the end!!!
            ones = find(isnan(a_mean{m}));
            excel_a(n,2) = ones(1)-1;
            if excel_a(n,2) <= excel_a(n,1)
                continue;
            end
            
        end
        
       %start through pinch task ---- no return!
         a_mse{n,m} = (1/length(a{n,m}(1:excel_a(n,2)))).*sum((a{n,m}(1:excel_a(n,2))-a_mean{m}(1:excel_a(n,2))).^2);
         a_mse_2_pinch{n,m} = (1/length(a{n,m}(1:excel_a(n,2)))).*sum((a{n,m}(1:excel_a(n,2))-a_mean{m}(1:excel_a(n,2))).^2);
         
                  
         a_rom_norm(m) = (a_mean_rom(m) - u_mean_rom(m)) ./ u_mean_rom(m);
         a_rom_norm_2_pinch(m) = (a_mean_rom_2_pinch(m) - u_mean_rom_2_pinch(m)) ./ u_mean_rom_2_pinch(m);

         
       
        %a_mse{n,m} = (1/length(a{n,m}(excel_a(n,1):excel_a(n,2)))).*sum((a{n,m}(excel_a(n,1):excel_a(n,2))-a_mean{m}(excel_a(n,1):excel_a(n,2))).^2);
        %plot([excel_u(n,1):excel_u(b,2)],u_n{n,m}(excel_u(n,1):excel_u(b,2))','g','LineWidth',3);hold on;
        %plot([excel_a(n,1):excel_a(n,2)],a_mean{m}(excel_a(n,1):excel_a(n,2))','m','LineWidth',3);hold on;
    end
end



values = [1:10];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%   Save below!!!! %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    for m = 1:12
       
            
       u_mse_sum(m) = median(cell2mat(u_mse(values,m)));
       a_mse_sum(m) = median(cell2mat(a_mse(values,m)));

%       
    end


% filename = 'C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\unaffected_mata_data\residuals_and_vaf\C9K_Preeya.mat';
% save(filename,'time_u','time_a','unaff','affect');
filename = string(strcat('C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\Four healthy subject data\', input,'_res.mat'));

save(filename,'median_trial_data_u','median_trial_data_a','un_raw','aff_raw', ...
    'u_rom_2_pinch','a_rom_2_pinch','u_mse_sum','a_mse_sum','u_rom_norm','a_rom_norm',...
    'u_rom_norm_mean','u_rom_norm_std','u_mse_norm_mean','u_mse_norm_std');

%save('C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\Four healthy subject data\data\precision_error_preeya.mat','jt_error');


