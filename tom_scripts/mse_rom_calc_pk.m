clear; clc;close all;

if ismac % Preeya computer
    path_to_data = '/Users/preeyakhanna/Dropbox/Ganguly_Lab/Projects/HP_Sensorized_Object/doses-kincode/';
    slash = '/'; 

else % Tom computer 
    path_to_data = 'C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\doses-kincode-main\'; 
    slash = '\'; 

end

Filename = 'W16H_small_pinch_data.mat';
load([path_to_data 'data' slash 'task_data' slash 'patient' slash Filename]);

[input1 input sign] = names_sign(Filename); 
%input reference to (input)_jt_angle_un( or aff).mat -> S13J_small stays same name
%input1 reference to excel files used in function "data_height_plot"-> S13J_small turns into S13J
%sign is 1 for patients, -1 for controls -> controls shoulder sensor placed
%facing towards proximal

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%  unaffected hand %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Filename = string(strcat(path_to_data,'data', slash, 'tom_data',slash, input,'_jt_angle_un.mat'));
load ([Filename]);
[u_height,unaffect_all,data_palm,u_time] = jt_angle_split('un',unaffected,angle_struct,input1);

%below function plots figs 1 and 2 and produces manually determined stamps
%for start to end of pinch task...also captures data from excel needed for
%calculations (see function below)
[exc_data] = data_height_plot(data_palm,u_height, u_time,sign,input1,'un','off');

[output] = interp_raw_n_zscore(unaffect_all,data_palm, u_height, input1,sign,exc_data,'un','on');  %does inerpolation and plotting

figure(12)
for m = 1:12
    for n = 1:10
        subplot(6,2,m)
        plot(cell2mat(output.u_unz(n,m)),'b');hold on; % Unzscored raw data 
    end
end

[mse_rom] = calc_mse_rom(output,input1,exc_data,'un'); %calculates below variables

%below variables needed for below calcs
%u_mse = mse_rom.u_mse;
%un_raw = mse_rom.un_raw;
%median_trial_data_u = mse_rom.median_trial_data_u;
%u_rom = mse_rom.u_rom;
u_mse_2_pinch = mse_rom.u_mse_2_pinch; 
%u_median_rom = mse_rom.u_median_rom;
u_median_rom_2_pinch = mse_rom.u_median_rom_2_pinch;

%calculates expected variation in ROM and MSE for unaffected
%below function calculates green boxes in paper figure 2 -> normal mean and std for
%unaffected normalized t2tc and rom
[u_rom_norm_mean,u_rom_norm_2xstd,u_mse_norm_mean, u_mse_norm_2xstd] = normal_mean_std(mse_rom); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%  affected hand %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Filename = string(strcat(path_to_data,'data', slash, 'tom_data', slash,input,'_jt_angle_aff.mat'));
load ([Filename]);

[a_height,affect_all,aff_data_palm,a_time] = jt_angle_split('aff',affected,angle_struct,input1);

%below function plots figs 4 and 5 and produces manually determined stamps
%for start to end of pinch task...also captures data from excel needed for
%calculations (see function below)
[aff_exc_data] = data_height_plot(aff_data_palm,a_height, a_time,sign,input1,'aff','off');

%below function same as above but for affected.  Also plots fig 6
[aff_output]  = interp_raw_n_zscore(affect_all,aff_data_palm, a_height, input1, sign,aff_exc_data,'aff','off');

%tb_mcp' tb_dip' ib_mcp' ib_pip' ib_dip' eb' palm shoulder_ang
l = ["Thumb MCP","Thumb DIP","Index MCP","Index PIP",...
    "Index DIP","Elbow Flex","Palm Abd","Palm Flex","Palm Prono","Should Horz Flex"...
    "Shoulder Vert Flex","Shoulder Roll"];

figure(12)
for m = 1:12
    for n = 1:10
        subplot(6,2,m)
        plot(cell2mat(aff_output.a_unz(n,m)),'r');hold on;
        title((l(m)))
    end
end

[aff_mse_rom] = calc_mse_rom(aff_output,input1,aff_exc_data,'aff');

%below variables needed for below calcs
%a_mse_ = mse_rom.a_mse;
%aff_raw = mse_rom.aff_raw;
%median_trial_data_a = mse_rom.median_trial_data_a;
%a_rom = mse_rom.a_rom;
%a_median_rom = mse_rom.a_median_rom;
%a_median_rom_2_pinch = mse_rom.a_median_rom_2_pinch;
a_median_rom_2_pinch = aff_mse_rom.a_median_rom_2_pinch;
a_mse_2_pinch = aff_mse_rom.a_mse_2_pinch; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%below variable in for loops are affected rom normalized data and mse sums
%for unaffected and affected
for m = 1:12
   %a_rom_norm(m) = (a_median_rom(m) - u_median_rom(m)) ./ u_median_rom(m);
   a_rom_norm_2_pinch(m) = (a_median_rom_2_pinch(m) - u_median_rom_2_pinch(m)) ./ u_median_rom_2_pinch(m);
   
   u_mse_med = median(cell2mat(u_mse_2_pinch(:,m))); %start to pinch end
   a_mse_med = median(cell2mat(a_mse_2_pinch(:,m))); %start to pinch end
   a_mse_norm_2_pinch(m) = (a_mse_med - u_mse_med) / u_mse_med; 
end

%Filename = string(strcat('C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\Four healthy subject data\', input,'_res.mat'));
% save(Filename,'median_trial_data_u','median_trial_data_a','un_raw','aff_raw', ...
%     'u_rom_2_pinch','a_rom_2_pinch','u_mse_sum','a_mse_sum','u_rom_norm','a_rom_norm',...
%     'u_rom_norm_mean','u_rom_norm_std','u_mse_norm_mean','u_mse_norm_std');

Filename = string(strcat(path_to_data, 'data', slash, 'tom_data', slash, input, '_res.mat')); 

%% To save: 
% 1) Save raw joint angle trial data --> can be used to re-do ROM w/ accuracy
% estimates as baseline 

% 2) Save raw joint angle trial data, zscored + mean/std of zscores in
% order to convert reliability data into zscored, can be used to bound
% minimum error in MSE

% 3) For plotting, save median_rom_2_pinch, mse_2_pinch, and normalized
% values for these; 

u_2_pinch = output.u_2_pinch; % z-scored trial truncated at pinch
u_unz_2_pinch = output.u_unz_2_pinch; % un-zscored trial trunacted at pinch 
u_zsc_mu = output.zsc_mu; 
u_zsc_std = output.zsc_std;
u_rom_2_pinch = mse_rom.u_rom_2_pinch; 


a_2_pinch = aff_output.a_2_pinch; % z-scored trial truncated at pinch
a_unz_2_pinch = aff_output.a_unz_2_pinch; % un-zscored trial trunacted at pinch 
a_zsc_mu = aff_output.zsc_mu; 
a_zsc_std = aff_output.zsc_std;
a_rom_2_pinch = aff_output.a_rom_2_pinch; 


save(Filename,...
    'u_unz_2_pinch', 'u_2_pinch', 'u_zsc_mu', 'u_zsc_std',...  %1 + 2) raw joint angle data, z-scored jt angle data, zscore params
    'a_unz_2_pinch', 'a_2_pinch', 'a_zsc_mu', 'a_zsc_std',...
    'u_mse_2_pinch', 'u_median_rom_2_pinch', 'u_rom_2_pinch',...% 3) median rom, mserom,normalized
    'a_mse_2_pinch', 'a_median_rom_2_pinch', 'a_rom_2_pinch',...
    'u_rom_norm_mean','u_rom_norm_2xstd','u_mse_norm_mean', 'u_mse_norm_2xstd',...    % Bootstrapped unaffected
    'a_rom_norm_2_pinch', 'a_mse_norm_2_pinch');% Normalized params 
    