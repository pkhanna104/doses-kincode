%% Initialize
clear;clc;close all;

%%
if ismac % Preeya computer
    path_to_data = '/Users/preeyakhanna/Dropbox/Ganguly_Lab/Projects/HP_Sensorized_Object/doses-kincode/';
    slash = '/'; 

else % Tom computer 
    path_to_data = 'C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\doses-kincode-main\'; 
    slash = '\'; 
end

%% Individual traces (normal vs. patients) 
patient_subject = {'B8M', 'B12J', 'S13J_small'}; 

% jt_names = {'Thumb_MCP', 'Thumb_DIP', 'Index_MCP', 'Index_PIP', 'Index_DIP',...
%     'Elbow_Flex', 'Palm_Abd', 'Palm_Flex', 'Palm_Prono', 'Shoulder_HorzFlex',...
%     'Shoulder_VertFlex'}; 

%%% Index DIP 
%jts_ids = [7, 6, 10];
%jt_nms = {'Palm Abd/Add', 'Elbow Flex/Ext', 'Shoulder Abd/Add'}; 

% jts_ids = [1, 2, 3, 4, 5]; 
% jt_nms = {'thumb mcp', 'thumb dip', 'index mcp', 'index pip', 'index dip'}; 
% 

jts_ids = [2, 6, 10];
jt_nms = {'Thumb DIP', 'Elbow Flex/Ext', 'Shoulder Abd/Add'}; 


%jt_cols = {[237, 32, 36]/256, [118, 172, 66]/256, [127, 47, 141]/256}; % R/G/purple
%jt_cols = {[123,50,148],[166,219,160],[0,136,55]}; 
%jt_cols = {[123,50,148],[147, 193, 139],[0,136,55]}; 
% light purple, light green, green 
%jt_cols = {[178,144,195],[147, 193, 139],[0,136,55]};
%jt_cols = {[178,144,195], [178,144,195], [178,144,195], [178,144,195], [178,144,195]}; 

% dark purple light green, green 
jt_cols = {[123,50,148], [147, 193, 139],[0,136,55]};

%ylims = {[-30, 40], [-10, 50], [-60, 20]}; 
%ylims = {[-10, 30], [-10, 30], [-10, 50], [-10, 50], [-10, 50]}; 
ylims = {[-10, 35], [-10, 50], [-60, 20]}; 

% Load healthy subject data 
Filename = strcat('FR_ctrl', '_pinch_data.mat'); 
load([path_to_data 'data' slash 'task_data' slash 'controls' slash Filename]);
ctrl = 1; 
[input1 input sign] = names_sign(Filename); 

% Unaffected 
Filename = string(strcat(path_to_data,'data', slash, 'tom_data',slash,'jt_angle_data',slash, input,'_jt_angle_un.mat'));
load ([Filename]);
[u_height,unaffect_all,data_palm,u_time] = jt_angle_split('un',unaffected,angle_struct,input1);
[healthy_output] = interp_raw_n_zscore(path_to_data,slash,u_time,unaffect_all,data_palm, u_height, input1,sign,'un','off');  %does inerpolation and plotting
     

% Load data from each subject
for i_s = 1:length(patient_subject)

    % Loading patient/ctrl data
    Filename = strcat(patient_subject{i_s}, '_pinch_data.mat'); 
    
    load([path_to_data 'data' slash 'task_data' slash 'patient' slash Filename]);
    ctrl = 0; 
    
    [input1 input sign] = names_sign(Filename); 
    
    %input reference to (input)_jt_angle_un( or aff).mat -> S13J_small stays same name
    %input1 used in function "data_height_plot"-> S13J_small turns into S13J
    %sign is 1 for patients, -1 for controls -> controls shoulder sensor placed
    %facing towards proximal
    
    % Affected Analysis
    Filename = string(strcat(path_to_data,'data', slash, 'tom_data',...
        slash,'jt_angle_data',slash, input,'_jt_angle_aff.mat'));

    load ([Filename]);
    
    [a_height,affect_all,aff_data_palm,a_time] = jt_angle_split('aff',affected,angle_struct,input1);
    
    %below function same as above but for affected.  Also plots fig 6
    [aff_output]  = interp_raw_n_zscore(path_to_data,slash,a_time,...
        affect_all,aff_data_palm, a_height, input1, sign,'aff','off');
    
    disp(['Subject : ' patient_subject{i_s} ', aff N = ' num2str(aff_output.mtl)]);

    %tb_mcp' tb_dip' ib_mcp' ib_pip' ib_dip' eb' palm shoulder_ang
    jt_names = {'Thumb_MCP', 'Thumb_DIP', 'Index_MCP', 'Index_PIP', 'Index_DIP',...
        'Elbow_Flex', 'Palm_Abd', 'Palm_Flex', 'Palm_Prono', 'Shoulder_HorzFlex',...
        'Shoulder_VertFlex'}; 
    
    for jt_i = 1:length(jts_ids)
        jt = jts_ids(jt_i); 
        figure(jt); 
        set(gcf, 'Position', [10 10 400 600]); 
        
        subplot(3, 1, i_s) % figure is jt; 
        hold all; 


        for trl = 1:10


            % Un-zscored healthy 
            jt_trl2 = cell2mat(healthy_output.u(trl, jt)); 
            jt_trl2 = jt_trl2 - jt_trl2(1); 
            plot(jt_trl2, 'Color', [.2, .2, .2], 'LineWidth',.35)

            % Un-zscored trial
            jt_trl = cell2mat(aff_output.a(trl, jt)); 
            jt_trl = jt_trl - jt_trl(1); 

            % Flip the elbow
            if contains(jt_nms{jt_i}, 'Elbow')
                jt_trl = -1*jt_trl; 
            end

            plot(jt_trl, 'Color', jt_cols{jt_i}/256, 'LineWidth',.35)

        end
        
        % Title 
        title(strcat(patient_subject{i_s}, ': ', jt_nms{jt_i}), 'FontSize',14)
        ylim(ylims{jt_i})
        ylabel('\Delta degrees')

        if i_s == 3
            xlabel('% way through trial')
        end
    end
end

for jt_i = 1:length(jts_ids)
    jt = jts_ids(jt_i); 
    jtnm = jt_nms{jt_i}; 
    jtnm2 = strrep(jtnm, '/', '_');
    jtnm2 = strrep(jtnm2, ' ', '_');
    %saveas(figure(jt), ['figs/' jtnm2 '_fig2_traces.svg'])
end


