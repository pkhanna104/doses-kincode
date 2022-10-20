%% Initialize
clear;clc;close all;

 % number of stds to add / subtract to get estimate of min/max ROM/MSE
nstd = 0.5;

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

%%% Save out params 1       2          3    4     5     6 
datatable = {}; %subject, control?, joint, aff, mse, rom 

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
    
    [input1 input sign] = names_sign(Filename); 
    
    %input reference to (input)_jt_angle_un( or aff).mat -> S13J_small stays same name
    %input1 used in function "data_height_plot"-> S13J_small turns into S13J
    %sign is 1 for patients, -1 for controls -> controls shoulder sensor placed
    %facing towards proximal
    
    % Unaffected Analysis
    
    Filename = string(strcat(path_to_data,'data', slash, 'tom_data',slash,'jt_angle_data',slash, input,'_jt_angle_un.mat'));
    load ([Filename]);
    [u_height,unaffect_all,data_palm,u_time] = jt_angle_split('un',unaffected,angle_struct,input1);
    
    %below function plots figs 1 and 2 and produces manually determined indices
    %(ginput.m) for start to end of pinch task...also captures data from folder jt_angle_data needed for
    %calculations (see function below)
    data_height_plot(data_palm,u_height, u_time,sign,input1,'un','off');
    
    [output] = interp_raw_n_zscore(path_to_data,slash,u_time,unaffect_all,data_palm, u_height, input1,sign,'un','off',nstd);  %does inerpolation and plotting
    
    disp(['Subject : ' subject{i_s} ', unaff N = ' num2str(output.mtl)]); 
    % Plot 
    for m = 1:12
        figure(m + 20)
        for n = 1:10
            subplot(5,2,i_s)
            plot(cell2mat(output.u(n,m)),'b');hold on; % Unzscored raw data 
        end
        
    end
    
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
    [aff_output]  = interp_raw_n_zscore(path_to_data,slash,a_time,affect_all,aff_data_palm, a_height, input1, sign,'aff','off',nstd);
    
    disp(['Subject : ' subject{i_s} ', unaff N = ' num2str(aff_output.mtl)]);

    %tb_mcp' tb_dip' ib_mcp' ib_pip' ib_dip' eb' palm shoulder_ang
    jt_names = {'Thumb_MCP', 'Thumb_DIP', 'Index_MCP', 'Index_PIP', 'Index_DIP',...
        'Elbow_Flex', 'Palm_Abd', 'Palm_Flex', 'Palm_Prono', 'Shoulder_HorzFlex',...
        'Shoulder_VertFlex'}; 
    
    prec = load([path_to_data 'data' slash 'precision_error_preeya.mat']); 

    for m = 1:11
        figure(m + 20)
        for n = 1:10
            subplot(5,2,i_s)
            plot(cell2mat(aff_output.a(n,m)),'r');hold on;
            jt_nm = jt_names{m}; 
            if m < 12
                pr = prec.jt_error_all.(jt_nm); 
            else
                pr = nan;
            end
            title(strcat(subject{i_s}, ' --', jt_names{m}, ' -- prec ', num2str(mean(abs(pr)))),...
                'FontSize',10)
        end
    end
    
    [aff_mse_rom] = calc_mse_rom(path_to_data,slash,aff_output,input1,'aff');
    
    % Affected Normal MSE and ROM calculations
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %below variable in for loops are affected rom normalized data and mse sums
    %for unaffected and affected
    for m = 1:12

        u_MSE = [mse_rom.u_median_mse_min(m),     mse_rom.u_median_mse(m),     mse_rom.u_median_mse_max(m)];
        a_MSE = [aff_mse_rom.a_median_mse_min(m), aff_mse_rom.a_median_mse(m), aff_mse_rom.a_median_mse_max(m)];

        u_ROM = [mse_rom.u_median_rom_min(m),     mse_rom.u_median_rom(m),     mse_rom.u_median_rom_max(m)];
        a_ROM = [aff_mse_rom.a_median_rom_min(m), aff_mse_rom.a_median_rom(m), aff_mse_rom.a_median_rom_max(m)];

        %%% Save everything out
        %                            1      2       3    4    5         6
        %                       subject,  control?, jt, aff?, mse,    rom,
        datatable{end+1} = {subject(i_s), ctrl,     m,  0,    u_MSE, u_ROM};
        datatable{end+1} = {subject(i_s), ctrl,     m,  1,    a_MSE, a_ROM};
    end
end

for m = 1:11
    figure(m + 20)
    set(gcf,'position',[0, 0, 1000, 1000])
    saveas(figure(m + 20), ['figs/' jt_names{m} '_subj_traces.png'])
end

save(['data/datatable' num2str(nstd) 'std_acc_samp_prec.mat'], 'datatable')

%% Now can make plots 
clear;
nstd = .5; 

if ismac % Preeya computer
    path_to_data = '/Users/preeyakhanna/Dropbox/Ganguly_Lab/Projects/HP_Sensorized_Object/doses-kincode/';
    slash = '/'; 

else % Tom computer 
    path_to_data = 'C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\doses-kincode-main\'; 
    slash = '\'; 
end

subject = {'B8M','S13J_small','B12J','C9K','W16H_small','R15J_small',...
    'AV_ctrl', 'FR_ctrl', 'PK_ctrl', 'SB_ctrl'};

jt_names = {'Thumb_MCP', 'Thumb_DIP', 'Index_MCP', 'Index_PIP', 'Index_DIP',...
    'Elbow_Flex', 'Palm_Abd', 'Palm_Flex', 'Palm_Prono', 'Shoulder_HorzFlex',...
    'Shoulder_VertFlex'}; 

% Load data table; 
%load([path_to_data 'data' slash 'datatable' num2str(nstd) 'std_prec.mat'])
load(['data/datatable' num2str(nstd) 'std_acc_samp_prec.mat'])


%% Plot 1 -- ROM vs ; 

roms = struct();  
%figure; hold all;
rom_all = []; 
for jt = 1 : 11
    
    if jt <= 5 % fine 
        figure(1); hold all; 
        cat = 'fine'; 
    elseif jt <= 9 % med
        figure(2); hold all; 
        cat = 'med'; 
    else % gross 
        figure(3); hold all;
        cat = 'gross'; 
    end
    %figure(jt); hold all; 
    
    jt_rom = []; 

    for i = 1:length(datatable)
        
        rm = []; 
            % patient               joint                   affected 
        if datatable{i}{2} == 0 && datatable{i}{3} == jt && datatable{i}{4} == 1
            col = 'r'; 
            rm = datatable{i}{6}; 
            mse = datatable{i}{5}; 
            id = 'aff'; 
        elseif datatable{i}{2} == 0 && datatable{i}{3} == jt && datatable{i}{4} == 0
            col = 'b'; 
            rm = datatable{i}{6}; 
            mse = datatable{i}{5}; 
            id = 'unaff'; 
        elseif datatable{i}{2} == 1 && datatable{i}{3} == jt && datatable{i}{4} == 0
            col = 'k'; 
            rm = datatable{i}{6}; 
            mse = datatable{i}{5}; 
            id = 'ctrl_R'; 
            jt_rom = [jt_rom 4*rm(2)]; % 2*jt rom 

        elseif datatable{i}{2} == 1 && datatable{i}{3} == jt && datatable{i}{4} == 1
            col = [.5, .5, .5]; 
            rm = datatable{i}{6}; 
            mse = datatable{i}{5}; 
            id = 'ctrl_L'; 
        end
        
        if ~isempty(rm)
            plot(rm(2), mse(2), '.', 'MarkerSize', 20, 'Color', col); 
            plot([rm(1), rm(3)], [mse(2), mse(2)], '-', 'Color', col); 
            plot([rm(2), rm(2)], [mse(1), mse(3)], '-', 'Color', col); 
            text(rm(2), mse(2), datatable{i}{1}{1}, 'FontSize', 10)
        end
        


    end
    title(jt_names{jt})
    
    rom_all = [rom_all mean(jt_rom)]; 
    %xlim([0, 35])
    %ylim([0, 2])
    %set(gcf,'position',[0, 0, 1000, 1000])
    %saveas(figure(jt), ['figs/' jt_names{jt} '_mse_vs_rom.png'])
end


%% Plot 2*ROM of healthy right hand vs. tested ROM 
jt_names = {'Thumb_MCP', 'Thumb_DIP', 'Index_MCP', 'Index_PIP', 'Index_DIP',...
    'Elbow_Flex', 'Palm_Abd', 'Palm_Flex', 'Palm_Prono', 'Shoulder_HorzFlex',...
    'Shoulder_VertFlex'}; 

jt_var_list = [40, 30, 60, 60, 30, 90, 30, 90, 90, 60, 60]; 
figure; hold all; 
for i = 1:11
    plot(jt_var_list(i), rom_all(i), 'k.', 'Markersize', 20); hold all; 
    text(jt_var_list(i), rom_all(i), jt_names{i}, 'FontSize', 14); 
end
b1 = jt_var_list'\rom_all'; 
y1 = b1*jt_var_list; 
plot(jt_var_list, y1, 'k--')
xlabel('Angle Variation Tested (max-min)')
ylabel('Angle Variation during Task (4*std=95% of data)')
xlim([0, 110])
ylim([0, 110])
title(["Line slope = " num2str(b1)])

% figure; 
% num = 8; 
% cats = {'fine', 'med', 'gross'}; 
% ids = {'aff', 'unaff', 'ctrl_R', 'ctrl_L'}; 
% color = {'r', 'b', 'k', [.5, .5, .5]}; 
% for j = 1:length(cats)
%     cat = cats{j}; 
%     for i = 1:length(ids)
%         id = ids{i}; 
%         tmp = [cat '_' id]; 
% 
%         bins = 0:20/num:20;
%         [n, eds] = histcounts(roms.(tmp), bins); 
%         disp(length(roms.(tmp)))
%         bins = eds(1:end-1) + 0.5*(eds(2) - eds(1)); 
%         subplot(3, 1, j); hold all; 
%         plot(bins, n, '-', 'Color', color{i}, 'LineWidth',3); 
%         mn = mean(roms.(tmp)); 
%         plot([mn, mn], [0, 10], '-', 'Color', color{i}, 'LineWidth',1); 
%     end
%     title(cat)
% end
% xlabel('ROM (std of degrees)'); 

