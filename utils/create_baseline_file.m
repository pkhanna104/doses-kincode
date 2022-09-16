function create_baseline_file(fname_save, filetype)

% Method to plot task data and interactively select points to use 
% as baseline data  -- this is for use for goniometer data or raw task
% data from Aug 2022 (i.e. NOT collated task data formats) 

% For collated task data formats use "create_baseline_from_syncd_taskfile"

% Filetype options: 
%   'task' -- task data 
%   'gon' -- goniometer data 

disp([' file name to save: ' fname_save]); 
disp('load up task data: '); 
[filename, pathname] = uigetfile;

if contains(filetype, 'gon')
    key = 'Palm_Prono_0'; 
    pth2 = 'prono0_baselines/'; 
    
    % load data 
    data_gon = load([pathname filename]); 
    
    % Get the fieldname that has key above
    keys = fieldnames(data_gon.data); 
    key_use = nan; 
    for k=1:length(keys)
        if contains(keys{k}, key)
            key_use = keys{k};
            break
        end
    end
    
    if isnan(key_use)
        disp(['couldnt find key: ' key ' so pausing here']); 
        keyboard; 
    else
        disp(['using key: ' key_use]); 
        x=input('Is this the correct hand? (1=yes,0=no)'); 
        if x ~= 1
            disp(keys)
            disp('')
            disp('')
            disp('')
            key_use = input('Enter key you want to use (must be in quotes): ');
        end
    end
        
    % if proceed, get that data -- use last measurement 
    cnt = data_gon.data.(key_use).cnt; 
    key_gon = data_gon.data.(key_use).(['Ang' num2str(cnt)]); 
    
    % Save out angle data 
    data = struct(); 
    data.angles = struct(); 

    % THis will make a 12 sensors x 3 dim x 5 observations matrix 
    data_tmp = cat(3, key_gon{end-4}, key_gon{end-3}, key_gon{end-2},...
        key_gon{end-1}, key_gon{end}); 
    
    % Now going ot be 12 x 5 x 3 
    data_tmp = permute (data_tmp, [1, 3, 2]); 

    for s = 1:12
        sens = ['sensor' num2str(s)]; 
        data.angles.(sens) = squeeze(data_tmp(s, :, :)); 
    end
    
elseif contains(filetype, 'task')
    
    % load task data
    data_task = load([pathname filename]); 
    pth2 = 'task_baselines/'; 

    % Plot palm sensor and object sensor 
    figure; subplot(2, 1, 1); hold all;
    tmp = data_task.data.position.sensor12; 
    tmp(:, 1) = tmp(:, 1) - mean(tmp(:, 1)); 
    tmp(:, 2) = tmp(:, 2) - mean(tmp(:, 2)); 
    tmp(:, 3) = tmp(:, 3) - mean(tmp(:, 3)); 
    plot(tmp); 
    title('Object'); 

    subplot(2, 1, 2); hold all; 
    tmp = data_task.data.position.sensor4; % palm sensor 
    tmp(:, 1) = tmp(:, 1) - mean(tmp(:, 1)); 
    tmp(:, 2) = tmp(:, 2) - mean(tmp(:, 2)); 
    tmp(:, 3) = tmp(:, 3) - mean(tmp(:, 3)); 
    plot(tmp); 
    title('Palm sensor de meaned'); 

    % Get time indices that hand and object are at baseline; 
    inputs = ginput(5);
    indices = round(inputs(:, 1)); 

    % baseline.data.angles.(['sensor' num2str(index_dip)])(end, :);
    data = struct(); 
    data.angles = struct(); 

    for s = 1:12
        sens = ['sensor' num2str(s)]; 
        data.angles.(sens) = data_task.data.angles.(sens)(indices, :); 
    end
else
    disp(['wrong filetype (must be "task" or "gon"): ' filetype])
    keyboard
end

pth = '/Users/preeyakhanna/Dropbox/Ganguly_Lab/Projects/HP_Sensorized_Object/code_manuscript/data/healthy_controls_goniometer/';

% Save out filename 
save_path = [pth pth2 fname_save]; 
save(save_path, 'data'); 
