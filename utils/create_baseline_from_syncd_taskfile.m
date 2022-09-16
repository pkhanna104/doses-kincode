function create_baseline_from_syncd_taskfile(fname_save, path_to_repo)

% method to load data from synced task data files and manually get
% snapshots of baseline periods
% Inputs: 
%   fname_save: filename stem (string)
%   path_to_repo: path to code_manuscript repository

disp([' file name to save: ' fname_save]); 
disp('load up task data: '); 
[filename, pathname] = uigetfile;

% load task data
data_task = load([pathname filename]); 

% Check thsi is the right type of datafile  
try
    assert(isfield(data_task, 'affected'))
    assert(isfield(data_task, 'unaffected'))
catch
    disp(['looks like you loaded the wrong type of datafile: ' filename]); 
    disp('Doesnt have the affected/unaffected structure expected'); 
end

% Sensor IDs to plot for this 
if contains(pathname, 'controls')
    object = 12; 
    palm = 4; 
elseif contains(pathname, 'patient')
    object = 13; 
    palm = 4; 
else
    disp('Not sure whether data is from 2022 or 2018/2019 batch')
    disp(pathname)
    keyboard; 
end

keys = {'affected', 'unaffected'}; 

% Make baseline for affected and unaffected
for i_k = 1:length(keys)

    close all; 
    
    % Plot palm sensor and object sensor 
    figure; subplot(2, 1, 1); hold all;
    tmp = data_task.(keys{i_k}).pos_data(:, :, object); % object sensors
    tmp(:, 1) = tmp(:, 1) - mean(tmp(:, 1)); 
    tmp(:, 2) = tmp(:, 2) - mean(tmp(:, 2)); 
    tmp(:, 3) = tmp(:, 3) - mean(tmp(:, 3)); 
    plot(tmp); 
    title('Object'); 

    subplot(2, 1, 2); hold all; 
    tmp = data_task.(keys{i_k}).pos_data(:, :, palm); % palm sensor 
    tmp(:, 1) = tmp(:, 1) - mean(tmp(:, 1)); 
    tmp(:, 2) = tmp(:, 2) - mean(tmp(:, 2)); 
    tmp(:, 3) = tmp(:, 3) - mean(tmp(:, 3)); 
    plot(tmp); 
    title('Palm sensor de meaned'); 

    % Get time indices that hand and object are at baseline; 
    disp('Click on a few points (4) places where hand is at rest'); 
    inputs = ginput(4);
    indices = round(inputs(:, 1)); 

    % Create baseline files 
    data = struct(); 
    data.angles = struct(); 

    for s = 1:size(data_task.(keys{i_k}).angle_data, 3)
        sens = ['sensor' num2str(s)]; 
        data.angles.(sens) = data_task.(keys{i_k}).angle_data(indices, :, s); 
    end
    
    % Path to save data: 
    pth = [path_to_repo 'data/task_data/baselines/'];

    % Save out filename 
    save_path = [pth fname_save keys{i_k} '.mat']; 
    disp('Saving...')
    disp(save_path)
    save(save_path, 'data'); 
end

