function angle_struct = get_jt_angles_w_planes(cell_data, datatype, baseline_data, prt,...
    hand_nm)

% Cell_data is data input; 
    % for angle_validation, cell_array 
    % for task_data, 
% Baseline data is fname of baseline file
% Prt is 1 for printing bend angle roll, else 0
% hand_nm is which hand is being analyzed; 

if contains(datatype, 'angle_validation')
    % Get data from cell array to matrix (Samples x [X,Y,Z] x sensors)
    data = []; 
    for i = 1:size(cell_data, 2)
        data = cat(3, data, cell_data{1, i}'); 
    end
    data = permute(data, [3, 1, 2]); 
    s = size(data);   
    
    %%% Aug 2022 sensor values 
    lower_arm = 1; % Inserted parallel to other sensors
    upper_arm = 2; % Inserted so that sensor is pointing upwards 
    palm_sensor = 4; % sensor was 8 for 8-23 data, moved to #4 for 8/24 onward

    index_mcp = 5; %sensor 5
    index_pip = 6; %sensor 6
    index_dip = 7; %sensor 7

    thumb_mcp = 9; 
    thumb_pip = 10; 
    thumb_dip = 11; 
    object_sensor = 12; 
    
    modify_angle_signs = false; % will modify in make_table function
    
elseif contains(datatype, 'patient_task_data')
    data = cell_data; 
    assert(size(data, 2) == 3)
    assert(size(data, 3) == 16)
    s = size(data);  
    
    %%% 2018/2019 sensor values 
    lower_arm = 8; % Inserted parallel to other sensors
    upper_arm = 12; % Inserted parallel to other sensors 
    palm_sensor = 4;
    
    index_mcp = 5; 
    index_pip = 6; 
    index_dip = 7;

    thumb_mcp = 1; 
    thumb_pip = 2; 
    thumb_dip = 3; 
    object_sensor = 13; 
    
    modify_angle_signs = true; % will modify signs here
    
elseif contains(datatype, 'ctrl_task_data')
    data = cell_data; 
    assert(size(data, 2) == 3)
    assert(size(data, 3) == 12)
    s = size(data);  
    
    lower_arm = 1; % Inserted parallel to other sensors
    upper_arm = 2; % Inserted so that sensor is pointing upwards 
    palm_sensor = 4; % sensor was 8 for 8-23 data, moved to #4 for 8/24 onward

    index_mcp = 5; %sensor 5
    index_pip = 6; %sensor 6
    index_dip = 7; %sensor 7

    thumb_mcp = 9; 
    thumb_pip = 10; 
    thumb_dip = 11; 
    object_sensor = 12; 
    
    modify_angle_signs = true; % will modify signs here
end

% Load baseline data filename 
baseline = load(baseline_data); 


for n = 1:s(1)
    
   % palm -- get vector in direction of palm  
   v_palm = get_vect(data(n,1,palm_sensor),data(n,2,palm_sensor)); 
   
   %% index vectors %%%%%%%   
   baseline_index_dip = baseline.data.angles.(['sensor' num2str(index_dip)])(end, :);
   baseline_index_pip = baseline.data.angles.(['sensor' num2str(index_pip)])(end, :);
   baseline_index_mcp = baseline.data.angles.(['sensor' num2str(index_mcp)])(end, :);
   
   % Dont' need these anymore since using dot product for thumb method % 
   %baseline_thumb_dip = baseline.data.angles.(['sensor' num2str(thumb_dip)])(end, :);
   %baseline_thumb_pip = baseline.data.angles.(['sensor' num2str(thumb_pip)])(end, :);
   %baseline_thumb_mcp = baseline.data.angles.(['sensor' num2str(thumb_mcp)])(end, :);
   baseline_palm      = baseline.data.angles.(['sensor' num2str(palm_sensor)])(end, :);
   
   [bend_flex_dip] = bend_angle_plane(baseline_index_dip, baseline_index_pip, ...
                                    data(n,:,index_dip),data(n,:,index_pip), 'flex', prt,...,
                                    'index dip', hand_nm);
    ib_dip(n) = bend_flex_dip; 


    [bend_flex_pip] = bend_angle_plane(baseline_index_pip, baseline_index_mcp, ...
                                    data(n,:,index_pip),data(n,:,index_mcp), 'flex', prt,...
                                    'index pip', hand_nm);
    ib_pip(n) = bend_flex_pip; 
 
   
    [bend_flex_mcp] = bend_angle_plane(baseline_index_mcp, baseline_palm, ...
                                    data(n,:,index_mcp),data(n,:,palm_sensor),'flex',...
                                    prt, 'index mcp', hand_nm);
    ib_mcp(n) = bend_flex_mcp; 
    
   %% thumb vectors -- plane way %%% 

%    [bend_flex_thdip] = bend_angle_plane(baseline_thumb_dip, baseline_thumb_pip, ...
%                                 data(n,:,thumb_dip),data(n,:,thumb_pip), 'thumb', prt,...
%                                 'thumb dip', hand_nm);
%    th_dip(n) = bend_flex_thdip; 

%    [bend_flex_thmcp] = bend_angle_plane(baseline_thumb_pip, baseline_thumb_mcp, ...
%                                     data(n,:,thumb_pip),data(n,:,thumb_mcp), 'thumb', prt,...,
%                                     'thumb pip',hand_nm);
%    th_mcp(n) = bend_flex_thmcp; 

   %%% Going back to non-plane way %%%
   
   % Get unit vector representaiton using azimuth and elevation
   vt_mcp = get_vect(data(n,1,thumb_mcp),data(n,2,thumb_mcp)); 
   vt_pip = get_vect(data(n,1,thumb_pip),data(n,2,thumb_pip)); 
   vt_dip = get_vect(data(n,1,thumb_dip),data(n,2,thumb_dip)); 
   
   % Get dot product
   th_mcp(n) = acosd(dot(vt_pip, vt_mcp)); 
   th_dip(n) = acosd(dot(vt_dip, vt_pip)); 

   %% Palm %%% 
   palm_prono(n)= data(n,3,palm_sensor); 
   % tried relative prono, didn't work as well :/
   %palm_prono(n) = diff_roll(baseline_palm(3), data(n, 3, palm_sensor), hand_nm);
   
   
   % Baseline for lower arm (palm sensor is above) 
   baseline_lower_arm = baseline.data.angles.(['sensor' num2str(lower_arm)])(end, :); 
   
   % Palm flexion
   [bend_flex] = bend_angle_plane(baseline_palm, ...
    baseline_lower_arm, data(n, :, palm_sensor), data(n, :, lower_arm), 'flex', prt,...
    'palm', hand_nm); 

    % Palm abduction
    [bend_abd] = bend_angle_plane(baseline_palm, ...
    baseline_lower_arm, data(n, :, palm_sensor), data(n, :, lower_arm), 'abd', prt,...
    'palm', hand_nm);

   % convention is for flexion to be +, for my goniometer measurement I had noted extension as +
   palm_flex(n) = -1*bend_flex; 
   palm_abd(n) = bend_abd; 
      
   %% Elbow bend %%% 
   v_lower_arm= get_vect(data(n,1,lower_arm), data(n,2,lower_arm)); 
   v_upper_arm = get_vect(data(n,1,upper_arm), data(n,2,upper_arm)); 
   elbo_flex(n) = acosd(dot(v_lower_arm, v_upper_arm));
   
   %% Shoulder sh_rol,sh_vert,sh_horz
   sh_horz(n) = data(n,1,upper_arm); % azimuth 
   sh_vert(n) = data(n,2,upper_arm); % elevation 
   sh_rol(n) =  data(n,3,upper_arm); % roll of sensor
   
   
end
   
% Modifications for equalizing conventions for DOFs with signs in reference
% to toward midline vs. away from midline rotation
if modify_angle_signs
    palm_abd = mod_true_angles(palm_abd, 'Palm_Abd', hand_nm); 
    palm_prono = mod_true_angles(palm_prono, 'Palm_Prono', hand_nm); 
    sh_horz = mod_true_angles(sh_horz, 'Shoulder_HorzFlex', hand_nm); 
    sh_vert = mod_true_angles(sh_vert, 'Shoulder_VertFlex', hand_nm);
    sh_rol = mod_true_angles(sh_rol, 'Shoulder_Roll', hand_nm); 
end

%% Unroll raw sensor data (e.g. if any cross overs in jts that use raw sensor data) 
palm_prono = unroll_sensor(palm_prono); 
sh_horz = unroll_sensor(sh_horz); 
sh_vert = unroll_sensor(sh_vert); 

angle_struct = struct(); 
angle_struct.('Thumb_MCP') = th_mcp;
angle_struct.('Thumb_DIP') = th_dip;
angle_struct.('Index_MCP') = ib_mcp;
angle_struct.('Index_PIP') = ib_pip;
angle_struct.('Index_DIP') = ib_dip;
angle_struct.('Palm_Flex') = palm_flex;
angle_struct.('Palm_Abd') = palm_abd;
angle_struct.('Palm_Prono') = palm_prono;
angle_struct.('Elbow_Flex') = elbo_flex;
angle_struct.('Shoulder_Roll') = sh_rol;
angle_struct.('Shoulder_VertFlex') = sh_vert;
angle_struct.('Shoulder_HorzFlex') = sh_horz;
end

function ang = inRange(ang)
% Convert 0-360 --> -180-180; 
if ang > 180
    ang = ang - 360; 
end
end
