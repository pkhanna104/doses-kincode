%%% Script to generate datatable for ROM/MSE and min/max
%%% Adapted from ~fig2 scripts from tom_scripts

%% Initialize
clear;clc;close all;

% number of stds to add / subtract to get estimate of min/max ROM
% this is based on analysis (at the end of this section illustrating that
% the task-ROM is approx 1/2 of the angle validation ROM; Since accuracy 
% error is mostly from hysteresis, half the ROM should mean half the error
% Would like some validation on whether this argument makes sense; 

if ismac % Preeya computer
    path_to_data = '/Users/preeyakhanna/Dropbox/Ganguly_Lab/Projects/HP_Sensorized_Object/doses-kincode/';
    slash = '/'; 

else % Tom computer 
    path_to_data = 'C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\doses-kincode-main\'; 
    slash = '\'; 
end

%%% Subjects 
subject = {'B8M','S13J_small','B12J','C9K','W16H_small','R15J_small',...
    'AV_ctrl', 'FR_ctrl', 'PK_ctrl', 'SB_ctrl'};

datatable = {}; 
% Create a datatable where each row is a datapoint 
% Columns of the datatable are: 
% Column 1 -- subject ID (string)
% Column 2 -- control subject? 1=yes, 0=no (integer)
% Column 3 -- joint number (#1-11) (integer) 
% Column 4 -- affected hand? 1=yes, 0=no (for controls affected=L, unaff=R)
% Column 5 -- [mse_min, mse, mse_max]; (array) 
% Column 6 -- [rom_min, rom, rom_max]; (array) 

trl_tms = []; 

%% Load data from each subject
for i_s = 1:length(subject)

    % Loading patient/ctrl data
    Filename = strcat(subject{i_s}, '_pinch_data.mat'); 
    
    if contains(Filename, 'ctrl')
        load([path_to_data 'data' slash 'task_data' slash 'controls' slash Filename]);
        ctrl = 1; 
    else 
        load([path_to_data 'data' slash 'task_data' slash 'patient' slash Filename]);
        ctrl = 0; 
    end
    
    % Get out the input1; 
    [input1 input sign] = names_sign(Filename); 
    
    %input reference to (input)_jt_angle_un( or aff).mat -> S13J_small stays same name
    %input1 used in function "data_height_plot"-> S13J_small turns into S13J
    %sign is 1 for patients, -1 for controls -> controls shoulder sensor placed
    %facing towards proximal
    
    % Unaffected Analysis
    Filename = string(strcat(path_to_data,'data', slash, 'tom_data',slash,'jt_angle_data',slash, input,'_jt_angle_un.mat'));
    load ([Filename]);

    % Get out data 
    [u_height,unaffect_all,data_palm,u_time] = jt_angle_split('un',unaffected,angle_struct,input1);
    
    %below function plots figs 1 and 2 and produces manually determined indices
    %(ginput.m) for start to end of pinch task...also captures data from folder jt_angle_data needed for
    %calculations (see function below)
    data_height_plot(data_palm,u_height, u_time,sign,input1,'un','off');
    
    %does inerpolation and calculation of 
    [output] = interp_raw_n_zscore(path_to_data,slash,u_time,unaffect_all,data_palm, u_height, input1,sign,'un','off');  
    
    % Plot 
    for m = 1:12
        figure(m + 20)
        for n = 1:10
            subplot(5,2,i_s)
            plot(cell2mat(output.u(n,m)),'b');hold on; % Unzscored raw data 
        end
        
    end
    
    trl_tms = [trl_tms, output.trial_length_ts]; 
    
    [mse_rom] = calc_mse_rom(path_to_data,slash,output,input1,'un'); %calculates below variables
   
    %calculates expected variation in ROM and MSE for unaffected
    %below function calculates green boxes in paper figure 2 -> normal mean and std for
    %unaffected normalized t2tc and rom
    %[u_rom_norm_mean,u_rom_norm_2xstd,u_mse_norm_mean, u_mse_norm_2xstd] = normal_mean_std(mse_rom); 
    
    % Affected Analysis
    
    Filename = string(strcat(path_to_data,'data', slash, 'tom_data',slash,'jt_angle_data',slash, input,'_jt_angle_aff.mat'));
    load ([Filename]);
    
    [a_height,affect_all,aff_data_palm,a_time] = jt_angle_split('aff',affected,angle_struct,input1);
    
    %below function plots figs 4 and 5 and produces manually determined stamps
    %for start to end of pinch task...also captures data from excel needed for
    %calculations (see function below)
    data_height_plot(aff_data_palm,a_height, a_time,sign,input1,'aff','off');
    
    %below function same as above but for affected.  Also plots fig 6
    [aff_output]  = interp_raw_n_zscore(path_to_data,slash,a_time,affect_all,aff_data_palm, a_height, input1, sign,'aff','off');
    
    %tb_mcp' tb_dip' ib_mcp' ib_pip' ib_dip' eb' palm shoulder_ang
    jt_names = {'Thumb_MCP', 'Thumb_DIP', 'Index_MCP', 'Index_PIP', 'Index_DIP',...
        'Elbow_Flex', 'Palm_Abd', 'Palm_Flex', 'Palm_Prono', 'Shoulder_HorzFlex',...
        'Shoulder_VertFlex'}; 
    
    for m = 1:11
        figure(m + 20)
        for n = 1:10
            subplot(5,2,i_s)
            plot(cell2mat(aff_output.a(n,m)),'r');hold on;
            jt_nm = jt_names{m}; 
            title(strcat(subject{i_s}, ' --', jt_names{m}),'FontSize',10)
        end
    end
    
    [aff_mse_rom] = calc_mse_rom(path_to_data,slash,aff_output,input1,'aff');
    
    %%%% Save to datatable %%%%
    for m = 1:12

        u_MSE = [mse_rom.u_median_mse_min(m),     mse_rom.u_median_mse(m),     mse_rom.u_median_mse_max(m)];
        a_MSE = [aff_mse_rom.a_median_mse_min(m), aff_mse_rom.a_median_mse(m), aff_mse_rom.a_median_mse_max(m)];

        u_ROM = [mse_rom.u_median_rom_min(m),     mse_rom.u_median_rom(m),     mse_rom.u_median_rom_max(m)];
        a_ROM = [aff_mse_rom.a_median_rom_min(m), aff_mse_rom.a_median_rom(m), aff_mse_rom.a_median_rom_max(m)];

        % Skip saving R15J index DIP: 
        if m == 12 
            disp('Skipping Shoulder roll')
        elseif and(contains(subject{i_s}, 'R15J'), contains(jt_names{m}, 'Index_DIP'))
            % Only add unaffected 
            datatable{end+1} = {subject(i_s), ctrl,     m,  0, u_MSE, u_ROM}; 
        else
            %%% Save everything out
            %                            1      2       3    4    5         6
            %                       subject,  control?, jt, aff?, mse,    rom,
            datatable{end+1} = {subject(i_s), ctrl,     m,  0,    u_MSE, u_ROM};
            datatable{end+1} = {subject(i_s), ctrl,     m,  1,    a_MSE, a_ROM};
        end
    end
end

% Save figures if desired
for m = 1:11
    figure(m + 20)
    set(gcf,'position',[0, 0, 1000, 1000])
    saveas(figure(m + 20), ['figs/' jt_names{m} '_subj_traces.png'])
end

% Save datatable
%save(['data/datatable' num2str(nstd) 'std_acc_samp_prec.mat'], 'datatable')
save('data/datatable_boot_acc_samp_prec.mat', 'datatable')

%% Plot showing range of angles measured vs. actual range exerted during the task
jt_names = {'Thumb_MCP', 'Thumb_DIP', 'Index_MCP', 'Index_PIP', 'Index_DIP',...
    'Elbow_Flex', 'Palm_Abd', 'Palm_Flex', 'Palm_Prono', 'Shoulder_HorzFlex',...
    'Shoulder_VertFlex'}; 

roms_all = []; 
for jt=1:11
    rom_jt = []; 
    for i=1:length(datatable)
        if datatable{i}{3} == jt % correct jt
            if datatable{i}{2} == 1 % control subject
                rom_jt = [rom_jt datatable{i}{6}(2)]; % add rom
            end
        end
    end
    % 4*sd covers ~95% of data
    roms_all = [roms_all 4*mean(rom_jt)]; 
end

% Measured range of motion 
jt_var_list = [40, 30, 60, 60, 30, 90, 30, 90, 90, 60, 60]; 
figure; hold all; 

for i = 1:11
    plot(jt_var_list(i), roms_all(i), 'k.', 'Markersize', 20); hold all; 
    text(jt_var_list(i), roms_all(i), jt_names{i}, 'FontSize', 14); 
end

b1 = jt_var_list'\roms_all'; 
y1 = b1*jt_var_list; 
plot(jt_var_list, y1, 'k--')
xlabel('Angle Variation Tested (max-min)')
ylabel('Angle Variation during Task (4*std=95% of data)')
xlim([0, 110])
ylim([0, 110])
title(["Line slope = " num2str(b1)])

%% Plot for trial times 
figure; 
histogram(trl_tms, 'Normalization','probability'); 
ylim([0, .3])
xlabel('Trial Times (sec)')
ylabel('Fraction of trials')
set(gcf,'position',[0, 0, 400, 300])
saveas(gcf, ['figs/trial_times.png'])