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
subject = {'B8M', 'S13J_small','B12J','C9K','W16H_small','R15J_small', 'AV_ctrl', 'FR_ctrl', 'PK_ctrl', 'SB_ctrl'};

t2tv = []; 
tt_minus_mn = []; 

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
    
    % Unaffected Analysis
    Filename = string(strcat(path_to_data,'data', slash, 'tom_data',slash,'jt_angle_data',slash, input,'_jt_angle_un.mat'));
    load ([Filename]);
    [u_height,unaffect_all,data_palm,u_time] = jt_angle_split('un',unaffected,angle_struct,input1);
    data_height_plot(data_palm,u_height, u_time,sign,input1,'un','off');
    [unaff_output] = interp_raw_n_zscore(path_to_data,slash,u_time,unaffect_all,data_palm, u_height, input1,sign,'un','off');  
    [mse_rom] = calc_mse_rom(path_to_data,slash,unaff_output,input1,'un'); %calculates below variables

    % Affected Analysis
    Filename = string(strcat(path_to_data,'data', slash, 'tom_data',slash,'jt_angle_data',slash, input,'_jt_angle_aff.mat'));
    load ([Filename]);
    [a_height,affect_all,aff_data_palm,a_time] = jt_angle_split('aff',affected,angle_struct,input1);
    data_height_plot(aff_data_palm,a_height, a_time,sign,input1,'aff','off');
    [aff_output]  = interp_raw_n_zscore(path_to_data,slash,a_time,affect_all,aff_data_palm, a_height, input1, sign,'aff','off');
    [aff_mse_rom] = calc_mse_rom(path_to_data,slash,aff_output,input1,'aff');
    
    % Get t2tv vs. trial time; 
    u_fs = 1./mean(diff(u_time{1})); 
    u_mse = cell2mat(mse_rom.u_mse); 

    a_fs = 1./mean(diff(a_time{1})); 
    a_mse = cell2mat(aff_mse_rom.a_mse); 

    TT = []; T2TV = []; 
    for trl = 1:10
        TT = [TT length(unaff_output.raw{trl, 1})/u_fs]; 
        T2TV = [T2TV mean(u_mse(trl, 1:11))]; 
    end
    t2tv = [t2tv T2TV]; 
    tt_minus_mn = [tt_minus_mn TT - mean(TT)]; 

    TT = []; T2TV = []; 
    for trl = 1:10
        TT = [TT length(aff_output.raw{trl, 1})/a_fs]; 
        T2TV = [T2TV mean(a_mse(trl, 1:11))]; 
    end

    t2tv = [t2tv T2TV]; 
    tt_minus_mn = [tt_minus_mn TT - mean(TT)]; 

end

figure; plot(t2tv, abs(tt_minus_mn), 'k.'); hold all; 

X = [ones(length(t2tv), 1) t2tv'];
Y = abs(tt_minus_mn'); 
  
% Regress stats 
% 1. R-square statistic, 
% 2. F statistic 
% 3. p value for the full model, 
% 4. an estimate of the error variance.

[b,bint,r,rint,stats] = regress(Y,X); 
y_est = t2tv*b(2) + b(1); 
plot(t2tv, y_est, 'b-')

xlabel('T2TV (mean across jts)')
ylabel('Abs deviation from mean trial time (sec)')

xlim([.15, 1.5])
ylim([0, 5])

set(gcf, 'Position', [0, 0, 400, 400])
saveas(gcf, ['figs/reviewer_t2tv_vs_tt.svg'])


