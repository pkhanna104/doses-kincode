clear; clc;close all;

if ismac % Preeya computer
    path_to_data = '/Users/preeyakhanna/Dropbox/Ganguly_Lab/Projects/HP_Sensorized_Object/doses-kincode/';
    slash = '/'; 

else % Tom computer 
    path_to_data = 'C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\doses-kincode-main\'; 
    slash = '\'; 

end

%% Loading patient/ctrl data

Filename = 'SB_ctrl_pinch_data.mat';

%Tom: added 10/10/2022
if contains(Filename, 'ctrl')
    load([path_to_data 'data' slash 'task_data' slash 'controls' slash Filename]);
else 
    load([path_to_data 'data' slash 'task_data' slash 'patient' slash Filename]);
end


[input1 input sign] = names_sign(Filename); 

%input reference to (input)_jt_angle_un( or aff).mat -> S13J_small stays same name
%input1 used in function "data_height_plot"-> S13J_small turns into S13J
%sign is 1 for patients, -1 for controls -> controls shoulder sensor placed
%facing towards proximal

%% Unaffected Analysis

Filename = string(strcat(path_to_data,'data', slash, 'tom_data',slash,'jt_angle_data',slash, input,'_jt_angle_un.mat'));
load ([Filename]);
[u_height,unaffect_all,data_palm,u_time] = jt_angle_split('un',unaffected,angle_struct,input1);

%below function plots figs 1 and 2 and produces manually determined indices
%(ginput.m) for start to end of pinch task...also captures data from folder jt_angle_data needed for
%calculations (see function below)
data_height_plot(data_palm,u_height, u_time,sign,input1,'un','off');

[output] = interp_raw_n_zscore(path_to_data,slash,u_time,unaffect_all,data_palm, u_height, input1,sign,'un','on');  %does inerpolation and plotting

figure(12)
for m = 1:12
    for n = 1:10
        subplot(6,2,m)
        plot(cell2mat(output.u(n,m)),'b');hold on; % Unzscored raw data 
    end
end

[mse_rom] = calc_mse_rom(path_to_data,slash,output,input1,'un'); %calculates below variables

%below variables needed for below calcs
u_mse = mse_rom.u_mse;
u_median_rom = mse_rom.u_median_rom;

%calculates expected variation in ROM and MSE for unaffected
%below function calculates green boxes in paper figure 2 -> normal mean and std for
%unaffected normalized t2tc and rom
[u_rom_norm_mean,u_rom_norm_2xstd,u_mse_norm_mean, u_mse_norm_2xstd] = normal_mean_std(mse_rom); 

%% Affected Analysis

Filename = string(strcat(path_to_data,'data', slash, 'tom_data',slash,'jt_angle_data',slash, input,'_jt_angle_aff.mat'));
load ([Filename]);

[a_height,affect_all,aff_data_palm,a_time] = jt_angle_split('aff',affected,angle_struct,input1);

%below function plots figs 4 and 5 and produces manually determined stamps
%for start to end of pinch task...also captures data from excel needed for
%calculations (see function below)
data_height_plot(aff_data_palm,a_height, a_time,sign,input1,'aff','off');

%below function same as above but for affected.  Also plots fig 6
[aff_output]  = interp_raw_n_zscore(path_to_data,slash,a_time,affect_all,aff_data_palm, a_height, input1, sign,'aff','on');

%tb_mcp' tb_dip' ib_mcp' ib_pip' ib_dip' eb' palm shoulder_ang
l = ["Thumb MCP","Thumb DIP","Index MCP","Index PIP",...
    "Index DIP","Elbow Flex","Palm Abd","Palm Flex","Palm Prono","Should Horz Flex"...
    "Shoulder Vert Flex","Shoulder Roll"];

figure(12)
for m = 1:12
    for n = 1:10
        subplot(6,2,m)
        plot(cell2mat(aff_output.a(n,m)),'r');hold on;
        title((l(m)))
    end
end

[aff_mse_rom] = calc_mse_rom(path_to_data,slash,aff_output,input1,'aff');

%below variables needed for below calcs
a_mse = aff_mse_rom.a_mse;
a_median_rom = aff_mse_rom.a_median_rom;

%% Affected Normal MSE and ROM calculations

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%below variable in for loops are affected rom normalized data and mse sums
%for unaffected and affected
for m = 1:12
   a_rom_norm_2_pinch(m) = (a_median_rom(m) - u_median_rom(m)) ./ u_median_rom(m);
      
   u_mse_med = median(cell2mat(u_mse(:,m))); %start to pinch end
   a_mse_med = median(cell2mat(a_mse(:,m))); %start to pinch end
   a_mse_norm_2_pinch(m) = (a_mse_med - u_mse_med) / u_mse_med; 
end

%% To save: For plotting, save normalized unaff and aff value

Filename = string(strcat(path_to_data, 'data', slash, 'tom_data', slash,'res_data', slash, input1, '_res.mat')); 

save(Filename,...
    'u_rom_norm_mean','u_rom_norm_2xstd','u_mse_norm_mean', 'u_mse_norm_2xstd',...    % Bootstrapped unaffected
    'a_rom_norm_2_pinch', 'a_mse_norm_2_pinch');% Normalized params 
    