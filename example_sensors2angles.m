% Example code for getting joint angle data from sensor angles
% This will change based on personal computer location
path_to_repository = '/Users/preeyakhanna/Dropbox/Ganguly_Lab/Projects/HP_Sensorized_Object/code_manuscript/';

%% Step one: identify a baseline period
% Some of the calculations require a 'baseline' period when the hand is
% flat on the table. A script below has been made to help identify this
% period. Below is an example for one of the control data sessions
session_id = 'PK_ctrl_pinch_data.mat'; 
fname_save = 'PK_ctrl_baseline'; 
create_baseline_from_syncd_taskfile(fname_save, path_to_repository)

%% Step two: convert task angle data to bend angles using plane method 
session_fname = 'PK_ctrl_pinch_data.mat';
datatype = 'ctrl_task_data'; % Other option is "patient_task_data" -- this affects which sensors are used

% This is the left hand for all control data subjects (all were right-handed)
data_key = 'affected'; 
hand_nm = 'Left'; 
baseline_fname = 'PK_ctrl_baselineaffected.mat'; 
prt = 0; % Dont print bend angle rolls 

% Get path to data
if strncmp(datatype, 'ctrl_task_data', length(datatype))
    pth2 = 'data/task_data/controls/';
elseif strncmp(datatype, 'patient_task_data', length(datatype))
    pth2 = 'data/task_data/patient/';
else
    disp('datatype must be "ctrl_task_data" or "patient_task_data"'); 
    keyboard; 
end

% Load data 
data = load([path_to_repository pth2 session_fname]);

% Extract angle data
angle_data = data.(data_key).angle_data; 

% Get angle structure -- final output of 
angle_struct = get_jt_angles_w_planes(angle_data, datatype, baseline_fname, prt,...
    hand_nm); 

