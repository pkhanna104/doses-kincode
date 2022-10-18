clear;clc;close all;

if ismac % Preeya computer
    path_to_data = '/Users/preeyakhanna/Dropbox/Ganguly_Lab/Projects/HP_Sensorized_Object/doses-kincode/';
    slash = '/'; 

else % Tom computer 
    path_to_data = 'C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\doses-kincode-main\'; 
    slash = '\'; 
end

%Add subjects here if needed..
subject = ["B8M","S13J_small","B12J","C9K","W16H_small","R15J_small"];

norms.a_rom_norm_2_pinch = [];
norms.a_mse_norm_2_pinch = [];
norms.u_mse_norm_mean = [];
norms.u_mse_norm_std = [];
norms.u_rom_norm_mean = [];
norms.u_rom_norm_std = [];
%% Plotting paper figure 2A-C

for sub = 1:6
      if contains(subject(sub), 'ctrl')
        tk =  'controls';
    else 
        tk =  'patient';
      end

    input = convertStringsToChars(subject(sub));
       
    Filename = string(strcat(path_to_data,'data',slash,'task_data',slash,tk,slash,input,'_pinch_data.mat'));
    load([Filename]);
    
    Filename2 = string(strcat(path_to_data,'data',slash,'tom_data',slash,'jt_angle_data',slash,input,'_jt_angle_un.mat'));
    load ([Filename2]);
    if any(sub == [1:3])
        paper_fig2_raw(Filename,'un',angle_struct,sub,'off');hold on; 
    end
    
    Filename2 = string(strcat(path_to_data,'data',slash,'tom_data',slash,'jt_angle_data',slash,input,'_jt_angle_aff.mat'));
    load ([Filename2]);
    if any(sub == [1:3])
        paper_fig2_raw(Filename,'aff',angle_struct,sub,'off');hold on; 
    end


    if contains(input,'_small') 
        input = erase(input,'_small');
    end

    Filename3 = string(strcat(path_to_data,'data',slash,'tom_data',slash,'res_data',slash,input,'_res.mat'));
    load([Filename3]);

    %below variables being concatenated from "input"_res.mat files
    %This storage is done as it seemed easier to create a matrix within a struct then to call separate
    %subject data files in paper_fig2_norms.m

    norms.a_rom_norm_2_pinch = horzcat(norms.a_rom_norm_2_pinch,a_rom_norm_2_pinch');
    norms.a_mse_norm_2_pinch = horzcat(norms.a_mse_norm_2_pinch,a_mse_norm_2_pinch');
    norms.u_mse_norm_mean = horzcat(norms.u_mse_norm_mean,u_mse_norm_mean');
    norms.u_mse_norm_std = horzcat(norms.u_mse_norm_std,u_mse_norm_2xstd');

    norms.u_rom_norm_mean = horzcat(norms.u_rom_norm_mean,u_rom_norm_mean');
    norms.u_rom_norm_std = horzcat(norms.u_rom_norm_std,u_rom_norm_2xstd');

end


%% Plot Paper Figure 2D-G find  indices of max mse and std omitting palm and shoulder roll 
% ->  used for creatting max error bar in paper_fig2_norms
 
joints = setdiff([1:12],[9 12]);

[row.mse column.mse] = find(norms.u_mse_norm_std == max(norms.u_mse_norm_std(joints,:),[],'all')); %location of largest mse std of all subjects

%find indices of max rom std omitting palm and shoulder roll
[row.rom column.rom] = find(norms.u_rom_norm_std == max(norms.u_rom_norm_std(joints,:),[],'all')); %location of largest rom std of all subjects

paper_fig2D_G(norms,row,column);
paper_fig2H(norms,row,column);

              