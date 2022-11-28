% Plot to show repeated measurements reliability %
% Pooling over (L/R hand), (days) measurements, show individual measurement
% vs. session mean is reliable
% Now combining over non-pk subjects from 
jts = {'Thumb MCP', % dot product
    'Thumb DIP', % dot product
    'Index DIP', % dot product
    'Index PIP', % dot product
    'Index MCP', % dot product
    'Palm Flex', % angle diff
    'Palm Abd', % angle diff
    'Palm Prono', % abs angle **
    'Elbow Flex', % dot product % 
    %'Shoulder Roll', % abs angle ** 
    'Shoulder VertFlex', % abs angle ** 
    'Shoulder HorzFlex'}; % abs angle **

jt_names = {'Thumb MCP', % dot product
    'Thumb IP', % dot product
    'Index DIP', % dot product
    'Index PIP', % dot product
    'Index MCP', % dot product
    'Wrist Flex/Ext', % angle diff
    'Wrist Abd/Add', % angle diff
    'Forearm Sup/Prono', % abs angle **
    'Elbow Flex/Ext', % dot product % 
    %'Shoulder Roll', % abs angle ** 
    'Shoulder Flex/Ext', % abs angle ** 
    'Shoulder Abd/Add'}; % abs angle **

sessions = {'av-8-30-22-R-edited', 'av-8-30-22-L',...
    'fr-9-1-22-L', 'fr-9-1-22-R','sb-9-1-22-L','sb-9-1-22-R',...
    'pk-8-26-R'};

hand = {'Right', 'Left','Left', 'Right','Left', 'Right', 'Right'};

baseline_fnames = {'task_baselines/av-R-baseline.mat', 'task_baselines/av-L-baseline.mat',...
                   'task_baselines/fr-L-baseline.mat', 'task_baselines/fr-R-baseline.mat',...
                   'task_baselines/sb-L-baseline.mat', 'task_baselines/sb-R-baseline.mat',...
                   'task_baselines/pk-8-26-R-baseline.mat'}; 

path_to_data = '/Users/preeyakhanna/Dropbox/Ganguly_Lab/Projects/HP_Sensorized_Object/doses-kincode/data/healthy_controls_goniometer/';

%% Figure 1; across all sessions -- within-session reliability
figure('Position', [10 10 600 400]); hold all

xoff = 1;
xlab = {};

jt_error_all = struct(); 
% For each joint 
mns =[]; stds = []; rms = []; 

for j=1:length(jts)
    newjt = strrep(jts{j},' ','_');
    
    % Get the angles used 
    [angles,~] = jt_angle_list(jts{j});
    
    jt_error = [];
    
    % For each session
    for s=1:length(sessions)
        
        % Load data 
        data = load([path_to_data sessions{s} '/valid_data.mat' ]);
        data = data.data;
        
        hd = hand{s};
        baseline_fname = [path_to_data baseline_fnames{s}]; 
        
        for a=1:length(angles)
            
%             [ang_dat, ~, fld] = get_angle_data(newjt, hd, angles(a),...
%                 data);
              [ang_dat, ~, fld] = get_angle_data_w_planes(newjt, hd, ...
                  angles(a), data, baseline_fname, 0); 
            
            % mean
            ang_dat_mn = circMean(ang_dat);
            diff = [];
            for i=1:length(ang_dat)
                diff = [diff circularSub(ang_dat(i), ang_dat_mn)];
            end
            
            jt_error = [jt_error diff];
        end
        
    end
    
    jt_error_all.(newjt) = jt_error; 
    
    h = bar(xoff, mean(jt_error)); hold all; 
    set(h,'FaceColor',[150, 150, 150]/255);
    errorbar(xoff, mean(jt_error), 1*circStd(jt_error), 'color','k')
    %newjt2 = strrep(newjt, '_', ' '); 
    xlab{end+1} = jt_names{xoff};
    xoff = xoff + 1;

    mns =[mns, mean(jt_error)]; stds = [stds, circStd(jt_error)]; 
    rms = [rms, sqrt(mean(jt_error.^2)) ]; 

    
end
xticks(1:xoff);
xticklabels(xlab);
xtickangle(90);
ylim([-30, 30])
title('Within session reliability (7 hands, 4 subjects)')
ylabel('Degrees'); 

disp('Within session reliability (7 hands, 4 subjects)')
disp('Mean error: ')
disp(mean(mns))
disp('mean std: ')
disp(mean(stds))
disp('RMS: ')
disp(mean(rms))


%saveas(f, 'figs/w_in_session_precision.epsc')

% Save out jt error data 
%save('data/precision_error_preeya.mat', 'jt_error_all'); 

%% Figure 2 -- Repeated subject -- across session var; 
% % Notes -- don't have task baseline for these subjects 
% % Prono0 really doesn't seem as good based on other subject data 
% % TODO : Repeat this with better baseline 
% 
% sessions = {'pk-8-24', 'pk-8-24', 'pk-8-25-v2', 'pk-8-26',...
%     'pk-8-26-R', 'pk-8-26-R2-edited'};
% 
% baseline_fnames = {'prono0_baselines/pk-8-24-L-baseline.mat',...
%                    'prono0_baselines/pk-8-24-R-baseline.mat',...
%                    'prono0_baselines/pk-8-25-v2-L-baseline.mat',...
%                    'prono0_baselines/pk-8-26-L-baseline.mat',...
%                    'prono0_baselines/pk-8-26-R-baseline.mat',...
%                    'prono0_baselines/pk-8-26-R2-edited-baseline.mat',...
%                    }; 
% hand = {'Left', 'Right', 'Left', 'Left', 'Right', 'Right'};
% path_to_data = '/Users/preeyakhanna/Dropbox/Ganguly_Lab/Projects/HP_Sensorized_Object/doses-kincode/data/healthy_controls_goniometer/';
% 
% % Only assess for angles with absolute values (not relative values) 
% jts = {'Thumb MCP', % dot product
%     'Thumb DIP', % dot product
%     'Index DIP', % dot product
%     'Index PIP', % dot product
%     'Index MCP', % dot product
%     'Palm Flex', % angle diff
%     'Palm Abd', % angle diff
%     'Palm Prono', % abs angle **
%     'Elbow Flex',
%     'Shoulder VertFlex',
%     'Shoulder HorzFlex'};
% 
% jt_error = struct();
% jt_error_dmn = struct();
% 
% mns = struct(); 
% 
% colors = {'r','g','b','m','c','k'}; 
% 
% for s=1:length(sessions)
%     data = load([path_to_data sessions{s} '/valid_data.mat' ]);
%     data = data.data;
%     
%     hd = hand{s};
%     baseline_fname = [path_to_data baseline_fnames{s}];
%     
%     for j=1:length(jts)
%         newjt = strrep(jts{j},' ','_');
%         [angles,~] = jt_angle_list(jts{j});
%         
%         angs = []; 
%         angs_lab = []; 
% 
%         if s == 1
%             mns.(newjt) = []; 
%         end
% 
%         figure(j); hold all; 
% 
%         for a=1:length(angles)
%             
%             %[ang_dat, ~, fld] = get_angle_data(newjt, hd, angles(a),...
%             %    data);
%             [ang_dat, ~, fld] = get_angle_data_w_planes(newjt, hd, ...
%                 angles(a), data, baseline_fname, 0);
%             
%             newang = strrep(num2str(angles(a)), '-', 'n');
%             
%             fld = [newjt '_' newang]; 
%             
%             if isfield(jt_error, fld)
%                 jt_error.(fld) = [jt_error.(fld) ang_dat]; 
%             else
%                 jt_error.(fld) = [ang_dat]; 
%             end
%             
%             % Add to angs 
%             angs = [angs ang_dat]; 
%             angs_lab = [angs_lab zeros(1, length(ang_dat)) + angles(a)]; 
% 
%             plot(zeros(1, length(ang_dat)) + angles(a), ang_dat, '.', 'Color', colors{s}); 
%         end
%         
%         % Demean these, add to jt_error_dmn -- within session demean
%         mn_angs = circMean(angs); 
%         mns.(newjt) = [mns.(newjt) mn_angs]; 
%         
%         for a=1:length(angles)
%             ix = find(angs_lab == angles(a)); 
%             newang = strrep(num2str(angles(a)), '-', 'n');
%             fld = [newjt '_' newang]; 
%             
%             if ~isfield(jt_error_dmn, fld)
%                 jt_error_dmn.(fld) = []; 
%             end
%             
%             for i=1:length(ix)
%                 jt_error_dmn.(fld) = [jt_error_dmn.(fld) circularSub(angs(ix(i)), mn_angs)]; 
%             end
%         end
%     end
% end
% 
% figure; hold all
% xoff = 1;
% xlab = {};
% 
% for j=1:length(jts)
%     newjt = strrep(jts{j},' ','_');
%     [angles,~] = jt_angle_list(jts{j});
%     
%     jt_error_xsess = [];
%     jt_error_xsess_dmn = [];
%     
%     
%     for a=1:length(angles)
%         newang = strrep(num2str(angles(a)), '-', 'n');
%         fld = [newjt '_' newang];
%         
%         % Across session de-mean 
%         mean_ang = circMean(jt_error.(fld));
%         mean_ang_dmn = circMean(jt_error_dmn.(fld));
%         
%         % Deviations from across session mean:  
%         diffs = []; diffs_dmn = []; 
%         for i = 1:length(jt_error.(fld))
%             diffs = [diffs circularSub(jt_error.(fld)(i), mean_ang)];
%             diffs_dmn = [diffs_dmn circularSub(jt_error_dmn.(fld)(i), mean_ang_dmn)]; 
%         end
%         jt_error_xsess = [jt_error_xsess diffs]; 
%         jt_error_xsess_dmn = [jt_error_xsess_dmn diffs_dmn]; 
%     end
%     
%     % Measure angle each day, look at deviations from x-session mean 
%     subplot(1, 2, 1); hold all; 
%     h = bar(xoff, mean(jt_error_xsess));  
%     set(h,'FaceColor',[150, 150, 150]/255);
%     errorbar(xoff, mean(jt_error_xsess), 1*circStd(jt_error_xsess), 'color','k')
%     
%     % Measure angle diffs from mean each day, look at deviations from
%     % x-session mean of means 
%     subplot(1, 2, 2); hold all; 
%     h = bar(xoff, mean(jt_error_xsess_dmn)); 
%     set(h,'FaceColor',[150, 150, 150]/255);
%     errorbar(xoff, mean(jt_error_xsess_dmn), 1*circStd(jt_error_xsess_dmn), 'color','k')
%     
%     newjt2 = strrep(newjt, '_', ' '); 
%     xlab{end+1} = newjt2;
%     xoff = xoff + 1;
%     
% end
% 
% for i = 1:2
%     subplot(1, 2, i); 
%     xticks(1:xoff);
%     xticklabels(xlab);
%     xtickangle(90);
%     ylim([-30, 30])
%     ylabel('Degrees')
% end
% 
% title('X session reliability, demeaned'); 
% subplot(1, 2, 1); 
% title('X session reliability (2 hands, 1 subject, 3 days)')

%% Figure 3 -- X subjects -- across session var; 
sessions = {'av-8-30-22-R-edited', 'av-8-30-22-L',...
    'fr-9-1-22-L', 'fr-9-1-22-R','sb-9-1-22-L','sb-9-1-22-R',...
    'pk-8-26-R'};

hand = {'Right', 'Left','Left', 'Right','Left', 'Right', 'Right'};
baseline_fnames = {'task_baselines/av-R-baseline.mat', 'task_baselines/av-L-baseline.mat',...
                   'task_baselines/fr-L-baseline.mat', 'task_baselines/fr-R-baseline.mat',...
                   'task_baselines/sb-L-baseline.mat', 'task_baselines/sb-R-baseline.mat',...
                   'task_baselines/pk-8-26-R-baseline.mat'}; 
jts = {'Thumb MCP', % dot product
    'Thumb DIP', % dot product
    'Index DIP', % dot product
    'Index PIP', % dot product
    'Index MCP', % dot product
    'Palm Flex', % angle diff
    'Palm Abd', % angle diff
    'Palm Prono', % abs angle **
    'Elbow Flex',
    'Shoulder VertFlex',
    'Shoulder HorzFlex'
    };

jt_names = {'Thumb MCP', % dot product
    'Thumb IP', % dot product
    'Index DIP', % dot product
    'Index PIP', % dot product
    'Index MCP', % dot product
    'Wrist Flex/Ext', % angle diff
    'Wrist Abd/Add', % angle diff
    'Forearm Sup/Prono', % abs angle **
    'Elbow Flex/Ext', % dot product % 
    %'Shoulder Roll', % abs angle ** 
    'Shoulder Flex/Ext', % abs angle ** 
    'Shoulder Abd/Add'}; % abs angle **

% Method: 
% i)  compute x-session/subject for each angle 
% ii) plot deviations from this x-session mean 
% iii) exception: dmn_jts --> account for offsets 
%       compute deviations from within-session mean (dmn_sess_j_ang_i)
%       compute x-session mean of (dmn_sess_j_ang_i) (j=1:length(sessions))
%       compute deviations from x-session mean 

dmn_jts = 1:11; 

jt_error = struct();
jt_error_demean = struct(); 

colors = {'r','g','b','m','c','k','g'}; 

for s=1:length(sessions)
    data = load([path_to_data sessions{s} '/valid_data.mat' ]);
    data = data.data;
    
    hd = hand{s};
    baseline_fname = [path_to_data baseline_fnames{s}]; 
    
    for j=1:length(jts)
        newjt = strrep(jts{j},' ','_');
        [angles,~] = jt_angle_list(jts{j});
        
        jt_ang_dat = []; 
        angs_lab = []; 
        for a=1:length(angles)
            
            % Angle data is NOT modified L/R since it is characterized as
            % "validation data"

            % Also not modified true angles bc not pushed through datatable
            % fcn 
             
            [ang_dat, ~, fld] = get_angle_data_w_planes(newjt, hd, ...
                angles(a), data, baseline_fname, 0);
            
            % To resolve, do modifications here! 
            ang_dat = mod_true_angles(ang_dat, jts{j}, hd); 
            
            % Now proceed
            newang = strrep(num2str(angles(a)), '-', 'n');
            
            fld = [newjt '_' newang]; 
            
            if isfield(jt_error, fld)
                jt_error.(fld) = [jt_error.(fld) ang_dat]; 
            else
                jt_error.(fld) = [ang_dat]; 
            end
            jt_ang_dat = [jt_ang_dat ang_dat]; 
            angs_lab = [angs_lab zeros(1, length(ang_dat)) + angles(a)]; 
        end

        % Remove mean offset over all angles 
        mnAng = circMean(jt_ang_dat); 

         for a=1:length(angles)
            ix = find(angs_lab == angles(a)); 
            newang = strrep(num2str(angles(a)), '-', 'n');
            fld = [newjt '_' newang]; 
            
            if ~isfield(jt_error_demean, fld)
                jt_error_demean.(fld) = []; 
            end
            
            for i=1:length(ix)
                jt_error_demean.(fld) = [jt_error_demean.(fld) circularSub(jt_ang_dat(ix(i)), mnAng)]; 
            end

            if j == 8
                figure(j); hold on; 
                if contains(hd, 'Right')
                    mark = '.'; 
                elseif contains(hd, 'Left')
                    mark = 's';
                else
                    exception('?')
                end
                plot(zeros(1, length(ix)) + angles(a), jt_ang_dat(ix), mark, 'Color',colors{s}); 
                xlim([-10, 100])
            end
         end

    end
end

figure; hold all
xoff = 1;
xlab = {};

global_diffs = []; 

for j=1:length(jts)
    newjt = strrep(jts{j},' ','_');
    [angles,~] = jt_angle_list(jts{j});
    
    jt_error_xsess = []; 
    
    for a=1:length(angles)
        newang = strrep(num2str(angles(a)), '-', 'n');
        fld = [newjt '_' newang];
        
        if ~isempty(find(dmn_jts == j))
            mean_ang = circMean(jt_error_demean.(fld)); 
            dmn = 1; 
        else
            mean_ang = circMean(jt_error.(fld)); 
            dmn = 0; 
        end
        
        % Demean 
        diffs = []; 
        for i = 1:length(jt_error.(fld))
            if dmn
                diffs = [diffs circularSub(jt_error_demean.(fld)(i), mean_ang)];
            else
                diffs = [diffs circularSub(jt_error.(fld)(i), mean_ang)];
            end
        end
        jt_error_xsess = [jt_error_xsess diffs]; 
    end
    
    h = bar(xoff, mean(jt_error_xsess));  
    set(h,'FaceColor',[150, 150, 150]/255);
    errorbar(xoff, mean(jt_error_xsess), 1*circStd(jt_error_xsess), 'color','k')
    %plot(xoff + .1*randn(1, length(jt_error_xsess)), jt_error_xsess, 'k.')
    newjt2 = strrep(newjt, '_', ' '); 
    xlab{end+1} = jt_names{j}; 
    xoff = xoff + 1;
    
    global_diffs = [global_diffs jt_error_xsess]; 

end

xticks(1:xoff);
xticklabels(xlab);
xtickangle(90);
ylim([-30, 30])
ylabel('Degrees')
title('X subject reliability (7 hands, 4 subjects)')

rms_ = sqrt(mean(global_diffs.^2)); 
fprintf('Mean x session/subj reliability: %.3f, Std: %.3f, RMS: %.3f ', mean(global_diffs), std(global_diffs), mean(rms_))



f = gcf; 
%saveas(f, 'figs/x_session_precision_dmn.epsc')

%% Figure 4 - hysteresis plots across subjects %%
jts = {...,
    'Thumb MCP', % dot product
    'Thumb DIP', % dot product
    'Index DIP', % dot product
    'Index PIP', % dot product
    'Index MCP', % dot product
    'Palm Flex', % angle diff
    'Palm Abd', % angle diff
    'Palm Prono', % abs angle **
    'Elbow Flex', % dot product % 
    'Shoulder Roll', % abs angle ** --> remove this angle 
    'Shoulder VertFlex', % abs angle ** 
    'Shoulder HorzFlex', % abs angle **
    };

%%% Baseline from task 
sessions = { 'av-8-30-22-R-edited', 'av-8-30-22-L',...
             'fr-9-1-22-L',         'fr-9-1-22-R',...
             'sb-9-1-22-L',         'sb-9-1-22-R',...
             'pk-8-26-R', };
             
hand = {'Right', 'Left',...
        'Left', 'Right',...
        'Left', 'Right',...
        'Right'};
    
baseline_fnames = {'task_baselines/av-R-baseline.mat', 'task_baselines/av-L-baseline.mat',...
                   'task_baselines/fr-L-baseline.mat', 'task_baselines/fr-R-baseline.mat',...
                   'task_baselines/sb-L-baseline.mat', 'task_baselines/sb-R-baseline.mat',...
                   'task_baselines/pk-8-26-R-baseline.mat'}; 
  
path_to_data = '/Users/preeyakhanna/Dropbox/Ganguly_Lab/Projects/HP_Sensorized_Object/doses-kincode/data/healthy_controls_goniometer/';

%%%%%%%%% Get datatables %%%%%%%%%
datatable_plane_tsk_bl = make_table_w_planes(sessions, hand, jts, baseline_fnames, path_to_data);

% Dot product version (no baseline used  
datatable = make_table(sessions, hand, jts, path_to_data);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% Get mean offset (mean for a subject/hand/joint/middle value) 
mean_offs = struct(); 
mean_offs_plane = struct(); 

for j = 1:length(jts)
    
    % For later 
    newjt = strrep(jts{j},' ','_');
    
    mean_offs.(newjt) = struct(); 
    mean_offs_plane.(newjt) = struct(); 
    
    % Get angles 
    [angles, ~] = jt_angle_list(jts{j});
    
    for i_s=1:length(sessions)
        hnd = hand{i_s}; 
        
        sess_hnd = [sessions{i_s} hnd]; 
        sess_hnd = strrep(sess_hnd, '-', '_'); 
        
        mean_offs.(newjt).(sess_hnd) = struct(); 
        mean_offs_plane.(newjt).(sess_hnd) = struct(); 
        
        % Storage for angles of the base variety 
        angs_true = []; 
        angs = []; 
        angs_plane = []; 
        
        % Modify true angles according to rules 
        [angles, ~] = jt_angle_list(jts{j});
        angles = mod_true_angles(angles, jts{j}, hnd); 
        
%         base_ang = angles(base_ang_ix); 
        disp('')
        disp('')
        disp(['starting : ' sess_hnd]); 
        
        for i = 1:length(datatable)
        
            if and(contains(datatable{i}{1}, sessions{i_s}), contains(datatable{i}{2}, hnd))
                
                %if and(contains(datatable{i}{3}, newjt), datatable{i}{4} == base_ang)
                if contains(datatable{i}{3}, newjt)
                    
                    angs_true = [angs_true datatable{i}{4}]; 
                    %angs = [angs datatable{i}{5}]; 
                    angs_plane = [angs_plane datatable_plane_tsk_bl{i}{5}];
                    
                    assert(contains(datatable_plane_tsk_bl{i}{1}, sessions{i_s}))
                    assert(contains(datatable_plane_tsk_bl{i}{2}, hnd))
                    assert(contains(datatable_plane_tsk_bl{i}{3}, newjt))
                    %assert(datatable_plane_tsk_bl{i}{4} == base_ang)
                    
                end
            end
        end
        
        % Compute angular mean
        ang_tru_mn = circMean(angs_true); % True mean 
        %ang_dat_mn = circMean(angs); % Meas mean 
        ang_dat_mn_plane = circMean(angs_plane); % Meas mean plane

        % Save this for later to subtract this from measurements 
        %mean_offs.(newjt).(sess_hnd).true_ang = ang_tru_mn; 
        %mean_offs.(newjt).(sess_hnd).meas_ang = ang_dat_mn;
        
        mean_offs_plane.(newjt).(sess_hnd).true_ang = ang_tru_mn;% True mean 
        mean_offs_plane.(newjt).(sess_hnd).meas_ang = ang_dat_mn_plane;% Meas mean plane
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
%%%%%%%%%%%% Make plot for each jt -- showing hysteresis;
%%% Make plot for each jt -- showing hysteresis with mean correction;

angle_data_true = struct(); 
angle_data = struct(); 
angle_data_dem = struct(); 
angle_data_dem_true = struct(); 
cols = struct(); 

for j = 1:length(jts)
    newjt = strrep(jts{j},' ','_');
    
    fg = figure(j); 
    set(fg, 'Position', [10 10 900 600]) 
    
    angle_data_true.(newjt) = struct(); 
    angle_data.(newjt) = struct(); 
    angle_data_dem.(newjt) = struct(); 
    angle_data_dem_true.(newjt) = struct(); 

    angles_true = []; 
    angles_dmn = []; 
    
    for i = 1:length(datatable)
        
        if contains(datatable{i}{3}, newjt)
            
            t = datatable{i}{4};
            meas = datatable{i}{5};
            
            % Datatables are made the same way so should have the same
            % ordering of fields added
            assert(contains(datatable_plane_tsk_bl{i}{1}, datatable{i}{1}))
            assert(contains(datatable_plane_tsk_bl{i}{2}, datatable{i}{2}))
            assert(contains(datatable_plane_tsk_bl{i}{3}, newjt))
            assert(t == datatable_plane_tsk_bl{i}{4})
            meas_tsk = datatable_plane_tsk_bl{i}{5};

            %%% Remove baseline 
            sess_hnd = [datatable{i}{1} datatable{i}{2}]; 
            sess_hnd = strrep(sess_hnd, '-', '_'); 
            
            %true_ang_sub = mean_offs.(newjt).(sess_hnd).true_ang; 
            %meas_ang_sub = mean_offs.(newjt).(sess_hnd).meas_ang; 
            true_ang_sub =       mean_offs_plane.(newjt).(sess_hnd).true_ang; 
            meas_ang_sub_plane = mean_offs_plane.(newjt).(sess_hnd).meas_ang; 

            t_dmn = circularSub(t, true_ang_sub); % Diff b/w true angle and angle mean
            %meas_dmn = circularSub(meas, meas_ang_sub); 
            meas_tsk_dmn = circularSub(meas_tsk, meas_ang_sub_plane);  %Diff b/w meas angle and meas angle mean
            
            
            if isfield(angle_data_true.(newjt), sess_hnd)
                angle_data.(newjt).(sess_hnd)(end+1) = meas_tsk; % meas angle 
                angle_data_true.(newjt).(sess_hnd)(end+1) = t; % true angle 
                 
                angle_data_dem.(newjt).(sess_hnd)(end+1) = meas_tsk_dmn;%Diff b/w meas angle and meas angle mean 
                angle_data_dem_true.(newjt).(sess_hnd)(end+1) = t_dmn; % Diff b/w true angle and angle mean
            else
                angle_data.(newjt).(sess_hnd) = [meas_tsk];
                angle_data_true.(newjt).(sess_hnd) = [t];
                 
                angle_data_dem.(newjt).(sess_hnd) = [meas_tsk_dmn];
                angle_data_dem_true.(newjt).(sess_hnd) = [t_dmn]; 
            end
            
            % Plot these ones! 
            if contains(datatable{i}{1}, 'pk')
                if contains(datatable{i}{3}, 'Shoulder')
                    col = 'w';
                else
                    col = [189,215,231]/256; 
                end
            elseif contains(datatable{i}{1}, 'av')
                col = [107,174,214]/256; 

            elseif contains(datatable{i}{1}, 'fr')
                col = [49,130,189]/256; 
            elseif contains(datatable{i}{1}, 'sb')
                col = [8,81,156]/256; 
            end
            
            % Save for later 
            cols.(sess_hnd) = col; 

            if contains(datatable{i}{2}, 'Right')
                mark = 'o'; 
            else
                mark = 's'; 
            end

            subplot(1, 2, 1); hold all;
            scatter(t + .5*randn(), meas_tsk, 50, col, 'filled', mark); 
            angles_true = [angles_true t ];
            
            subplot(1, 2, 2); hold all;
            %plot(t_dmn, meas_dmn, [col 's']);
            %plot(t_dmn+2, meas_tsk_dmn, [col, '*']); 
            scatter(t_dmn + randn(), meas_tsk_dmn, 50, col, 'filled', mark); 
            angles_dmn = [angles_dmn t_dmn ];
        end
    end
    
    for i = 1:2
        subplot(1, 2 ,i); hold all; 
        if i ==1 
            plot([min(angles_true), max(angles_true)], [min(angles_true), max(angles_true)], 'k--');
            xlim([min(angles_true) - 5, max(angles_true) + 5]);
            xlabel('True Angle (degrees)')
            ylabel('Meas Angle (degrees)')

        else
            plot([min(angles_dmn), max(angles_dmn)], [min(angles_dmn), max(angles_dmn)], 'k--');
            xlim([min(angles_dmn) - 5, max(angles_dmn) + 5]);
            xlabel('demeaned True Angle (degrees)')
            ylabel('demeaned Meas Angle (degrees)'); 
        end
        
       if i == 1
            title(['True vs Meas: ' jts{j}]);
       else
           title(['dMnTrue vs dMnMeas: ' jts{j}]);
       end
        
    end

    % Add subject-specific lines 
    for i_s = 1:length(sessions)
        
        sess_hnd = [sessions{i_s} hand{i_s}]; 
        sess_hnd = strrep(sess_hnd, '-', '_'); 

        if isfield(angle_data_true.(newjt), sess_hnd)
            x1 = angle_data_true.(newjt).(sess_hnd); 
            y1 = angle_data.(newjt).(sess_hnd); 
            p = polyfit(x1, y1, 1);
            y1_est = x1*(p(1)) + p(2); 
            subplot(1, 2, 1); 
            plot(x1, y1_est, '-', 'Color', cols.(sess_hnd), 'Linewidth', 1)
    
    
            x2 = angle_data_dem_true.(newjt).(sess_hnd); 
            y2 = angle_data_dem.(newjt).(sess_hnd); 
            p = polyfit(x2, y2, 1);
            y2_est = x2*(p(1)) + p(2); 
            subplot(1, 2, 2); 
            plot(x2, y2_est, '-', 'Color', cols.(sess_hnd), 'Linewidth', 1)
        end
        
    end

    f = gcf; 
    if j == 9 % save elbow flex for supplement example 
%         saveas(f, ['figs/' newjt '.png']);
%         saveas(f, ['figs/' newjt '.epsc']);
    end

end

%% Figures 5 -- error plots 

% Figure of true and dmn errors 
figure;%(1); % By subject 

% List of hands 
hands = fieldnames(angle_data.('Thumb_MCP')); 

jts_tru = {'Thumb MCP',...
     'Thumb DIP',... 
     'Index DIP',... 
     'Index PIP',... 
     'Index MCP',... 
    'Palm Flex',...
    'Palm Abd',...
    'Palm Prono',...
    'Elbow Flex',...
    'Shoulder VertFlex',...
    'Shoulder HorzFlex'};

jts_label = {'Thumb MCP', % dot product
    'Thumb IP', % dot product
    'Index DIP', % dot product
    'Index PIP', % dot product
    'Index MCP', % dot product
    'Wrist Flex/Ext', % angle diff
    'Wrist Abd/Add', % angle diff
    'Forearm Sup/Prono', % abs angle **
    'Elbow Flex/Ext', % dot product % 
    '', %'Shoulder Roll', % abs angle ** 
    'Shoulder Flex/Ext', % abs angle ** 
    'Shoulder Abd/Add'}; % abs angle **

cmap = {[215,25,28]/255,...
        [253,174,97]/255,...
        [255,255,191]/255,...
        [171,217,233]/255,...
        [44,123,182]/255};

cols = {cmap{1}, cmap{1},...
        cmap{2}, cmap{2}, cmap{2},...
        cmap{3}, cmap{3}, cmap{3},...
        cmap{4},...
        cmap{5}, cmap{5}, cmap{5}}; 

sum_tru_err = struct(); 
sum_tru_dmnerr = struct(); 

dmn_jts = [8, 10, 11]; 

% Iterate through hands 
for i_h = 1:length(hands) 
    hd = hands{i_h}; 
    
    % True errors / demeaned errors 
    figure(1); 
    subplot(2, 7, i_h); hold all; title(strrep(hd, '_', '-'), 'fontsize', 10); 
    subplot(2, 7, i_h + 7); hold all; 
    
    xlab0 = {};
    xlab = {}; 
    
    for i_j = 1:length(jts)
        newjt = strrep(jts{i_j},' ','_');
        xlab{end+1} = jts{i_j}; 
        
        if i_h == 1
            sum_tru_err.(newjt) = [];  
            sum_tru_dmnerr.(newjt) = []; 
        end
        
        % True vs. meas
        if isfield(angle_data_true.(newjt), hd)
            tru = angle_data_true.(newjt).(hd); 
            mea = angle_data.(newjt).(hd); 

            tru_d = angle_data_dem_true.(newjt).(hd); 
            mea_d = angle_data_dem.(newjt).(hd); 

            % Error
            err = circularSub(tru, mea);
            err_d = circularSub(tru_d, mea_d); 

            if ~isempty(find(contains(jts_tru, jts{i_j})))
                xlab0{end+1} = jts_label{i_j}; 
                subplot(2, 7, i_h);
                h=bar(length(xlab0), circMean(err));
                set(h,'FaceColor',cols{i_j});
                errorbar(length(xlab0), circMean(err), 1*circStd(err), 'color', 'k'); 
                
                sum_tru_err.(newjt) = [sum_tru_err.(newjt) err];  
                
            end

            subplot(2, 7, i_h + 7);
            h=bar(i_j, circMean(err_d));
            set(h,'FaceColor',cols{i_j});
            errorbar(i_j, circMean(err_d), 1*circStd(err_d), 'color', 'k');
            sum_tru_dmnerr.(newjt) = [sum_tru_dmnerr.(newjt) err_d]; 
        end
    end
    
    subplot(2, 7, i_h); 
    xticks(1:length(xlab0))
    xticklabels(xlab0)
    xtickangle(90)
    ax = gca(); 
    ax.XAxis.FontSize = 10;
    ylim([-30, 30])
    
    subplot(2, 7, i_h + 7); 
    xticks(1:length(jts))
    xticklabels(xlab)
    xtickangle(90)
    ax = gca(); 
    ax.XAxis.FontSize = 10; 
    ylim([-30, 30])
end

figure('Position', [10 10 800 400]); hold all
subplot(1, 2, 1); hold all; title('True err'); 
subplot(1, 2, 2); hold all; title('Demean err'); 

tru_cnt = 0;

xlab0 = {}; 
xlab = {}; 

mns = []; 
stds = []; 
rms = []; 

for i_j = 1:length(jts)
    newjt = strrep(jts{i_j},' ','_');
    
    if ~isempty(find(contains(jts_tru, jts{i_j})))
        errs = sum_tru_err.(newjt); 
        tru_cnt = tru_cnt + 1; 
        
        subplot(1, 2, 1); 
        h = bar(tru_cnt, circMean(errs)); 
        set(h,'FaceColor',cols{i_j});
        errorbar(tru_cnt, circMean(errs), 1*circStd(errs), 'color', 'k');
        xlab0{end+1} = jts_label{i_j}; 
        
        
        errs_d = sum_tru_dmnerr.(newjt); 
        subplot(1, 2, 2); 
        h = bar(tru_cnt, circMean(errs_d)); 
        set(h,'FaceColor',cols{i_j});
        errorbar(tru_cnt, circMean(errs_d), 1*circStd(errs_d), 'color', 'k');
        xlab{end+1} = jts_label{i_j}; 

        mns = [mns, circMean(errs_d)]; 
        stds = [stds, circStd(errs_d)]; 
        rms = [rms, sqrt(mean(errs_d.^2))]; 
    end
end

disp('Mean: ')
disp(circMean(mns))
disp('Stds: ')
disp(circMean(stds))
disp('RMS: ')
disp(mean(rms))


subplot(1, 2, 1); 
xticks(1:tru_cnt)
xticklabels(xlab0)
xtickangle(90)
ax = gca(); 
ax.XAxis.FontSize = 14; 
ylim([-30, 30])
ylabel('Error (deg)');

subplot(1, 2, 2); 
xticks(1:length(xlab))
xticklabels(xlab)
xtickangle(90)
ax = gca(); 
ax.XAxis.FontSize = 14; 
ylim([-30, 30])
ylabel('Error (deg)');
    
% Save out data 
accuracy_data = sum_tru_dmnerr;  %struct containing errors of accuracy data per joint 
f = gcf; 
saveas(f, 'figs/accuracy.epsc');
%save('data/rom_error_preeya.mat', 'accuracy_data');
