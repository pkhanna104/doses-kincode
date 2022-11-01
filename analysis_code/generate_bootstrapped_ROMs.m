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

sessions = {'av-8-30-22-R-edited', 'av-8-30-22-L',...
    'fr-9-1-22-L', 'fr-9-1-22-R','sb-9-1-22-L','sb-9-1-22-R',...
    'pk-8-26-R'};

hand = {'Right', 'Left','Left', 'Right','Left', 'Right', 'Right'};

baseline_fnames = {'task_baselines/av-R-baseline.mat', 'task_baselines/av-L-baseline.mat',...
                   'task_baselines/fr-L-baseline.mat', 'task_baselines/fr-R-baseline.mat',...
                   'task_baselines/sb-L-baseline.mat', 'task_baselines/sb-R-baseline.mat',...
                   'task_baselines/pk-8-26-R-baseline.mat'}; 

path_to_data = '/Users/preeyakhanna/Dropbox/Ganguly_Lab/Projects/HP_Sensorized_Object/doses-kincode/data/healthy_controls_goniometer/';

%% Gather bootstrapped stds from accuracy data 
figure('Position', [10 10 600 400]); hold all
ax = gca; 

jt_rom_ratio_range = struct(); 

% For each joint 
for j=1:length(jts)
    newjt = strrep(jts{j},' ','_');
    
    % Get the angles used 
    [angles,~] = jt_angle_list(jts{j});
    
    % Jt std distribution 
    jt_std_true = []; 
    jt_std_meas = []; 

    % For each session
    for s=1:length(sessions)
        
        % Load data 
        data = load([path_to_data sessions{s} '/valid_data.mat' ]);
        data = data.data;
        
        hd = hand{s};
        baseline_fname = [path_to_data baseline_fnames{s}]; 
        
        true_angle = []; 
        meas_angle = []; 

        for a=1:length(angles)
            
              % Get data 
              [ang_dat, ~, fld] = get_angle_data_w_planes(newjt, hd, ...
                  angles(a), data, baseline_fname, 0); 

              true_angle = [true_angle zeros(1, length(ang_dat))+angles(a)];
              meas_angle = [meas_angle ang_dat];
        end

        k = 5; 
        
        if length(true_angle) > 0
            
            % Bootstrap 
            N = nchoosek(length(true_angle), k); 
            
            % Get combinations 
            combos = nchoosek(1:length(true_angle), k);  
    
            % Get std of subselection 
            for i=1:N
                grp_ix = combos(i, :); 
                jt_std_true = [jt_std_true std(true_angle(grp_ix))]; 
                jt_std_meas = [jt_std_meas std(meas_angle(grp_ix))]; 
            end       
        end
    end

    ratio = jt_std_true./jt_std_meas; 
    disp(['JOINT: ' jts{j} ' N = ' num2str(length(ratio))])
    draw_boxplot(ax, j, ratio, 'k', 'k', .1)

    newjt = strrep(jts{j}, ' ', '_'); 
    jt_rom_ratio_range.(newjt) = [mean(ratio) - 1.96*std(ratio), mean(ratio) + 1.96*std(ratio)]; 

end

jt_rom_ratio_range.('notes') = ' values are jt_std_true / jt_std_meas '; 
save('data/bootstrapped_roms.mat', 'jt_rom_ratio_range')
