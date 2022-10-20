clear;clc;
% Example code for getting joint angle data from sensor angles
% This will change based on personal computer location
if ismac % Preeya computer
    path_to_repository = '/Users/preeyakhanna/Dropbox/Ganguly_Lab/Projects/HP_Sensorized_Object/doses-kincode/';
    slash = '/'; 

else % Tom computer 
    path_to_repository = 'C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\doses-kincode-main\'; 
    slash = '\'; 

end

subjects = ["PK","FR","AV","SB","B8M","C9K","B12J","W16H_small","S13J_small","R15J_small"];

for n = 1  %:size(subjects,2)
    for m = 2%1:2

            disp(subjects(n))
            if m == 1
                data_key = 'unaffected';
            else
                data_key = 'affected';
            end
    
            if n <= 4
                datatype = 'ctrl_task_data';
                add_to_task_name = '_ctrl'; 
            else
                datatype = 'patient_task_data'; % Other option is "patient_task_data" -- this affects which sensors are used
                add_to_task_name = ''; 
            end
    
            input = convertStringsToChars(subjects(n));
            session_id = convertStringsToChars(strcat(input,add_to_task_name,'_pinch_data.mat'));
            fname_save = convertStringsToChars(strcat(input,'_ctrl_baseline')); 
    
            names1 = ["C9K","B12J","W16H_small","S13J_small"];
            names2 = ["B8M","R15J_small","PK","FR","AV","SB"];
            
            %hand_nm -> which hand was unaffacted and which affected?? 
            %This is the left hand for all control data subjects (all were right-handed)
            
            if any(convertCharsToStrings(input) == names1) & convertCharsToStrings(data_key) == "unaffected"
                hand_nm = 'Left';
            elseif any(convertCharsToStrings(input) == names1) & convertCharsToStrings(data_key) == "affected"
                hand_nm = 'Right';
            elseif any(convertCharsToStrings(input) == names2) & convertCharsToStrings(data_key) == "unaffected"
                hand_nm = 'Right';
            elseif any(convertCharsToStrings(input) == names2) == 1 & convertCharsToStrings(data_key) == "affected"
                hand_nm = 'Left';
            end
            
            %hand_nm = 'Left'; 
            
            if data_key == "unaffected"
                data_key2 = 'un';
            else
                data_key2 = 'aff';
            end
            
            %% Step one: identify a baseline period
            % Some of the calculations require a 'baseline' period when the hand is
            % flat on the table. A script below has been made to help identify this
            % period. Below is an example for one of the control data sessions
            
            %create_baseline_from_syncd_taskfile(fname_save, path_to_repository)
            
            %% Step two: convert task angle data to bend angles using plane method 
            session_fname = session_id;
            
            
%             if contains(convertCharsToStrings(input),"_small")
%                 input = erase(input,"_small");
%             end
            
            
            baseline_fname = string(strcat(path_to_repository, 'data', slash, 'task_data', slash, 'baselines', slash, input, '_ctrl_baseline', data_key, '.mat')); 
            prt = 0; % Dont print bend angle rolls 
            
            % Get path to data
            if strncmp(datatype, 'ctrl_task_data', length(datatype))
                pth2 = ['data' slash 'task_data' slash 'controls' slash]; 
            elseif strncmp(datatype, 'patient_task_data', length(datatype))
                pth2 = ['data' slash 'task_data' slash 'patient' slash]; 
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
            
            filename = string(strcat(path_to_repository, 'data', slash, 'tom_data', slash, 'jt_angle_data', slash, input, add_to_task_name, '_jt_angle_', data_key2, '.mat')); 
            save(filename,'angle_struct');
            
        
    end
end

