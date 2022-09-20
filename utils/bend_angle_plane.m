function [bend_ang] = bend_angle_plane(baseline_data_s1, ...
    baseline_data_s2, s1, s2, angle_type, prt, s1_name, hand_nm)

% Baseline data where we can assume XY plane has a roll of 0; 
% Inputs: 
%   baseline_data_s1 / s2 --> sensor data from flat hand in baseline
%       position (1 x 3 array of A/E/R); 
%   s1 / s2 --> sensor data from hand in position w/ angle to be measured 
%   angle_type --> string: 'flex', 'abd', 'thumb' 
%       "flexion" : create an XY plane, rotate by droll, get angle b/w
%           sensors. Assumption: sensors don't roll w.r.t. one another from
%           baseline to measured angle 
%       "abd" : create an XZ plane, rotate by droll, get angle b/w sensors.
%           Assumption: same as flexion; 
%       "thumb": create an XYZ plane (direction depends on hand), rotate by
%           droll, get angle w.r.t. one another. 
        

if contains(angle_type, 'flex')
    % Get flex angles
    % create vector for XY plane (3 dim x 2 column vectors) 
    V_xy = [1 0 0; 0 1 0]'; 
    bend_ang = bend_angle(s1, s2, baseline_data_s1, baseline_data_s2, V_xy,...
        'flex', prt, s1_name, hand_nm); 
    
elseif contains(angle_type, 'abd')
    % create vector for XZ plane (3 dim x 2 column vectors) 
    V_xz = [1 0 0; 0 0 1]';
    bend_ang = bend_angle(s1, s2, baseline_data_s1, baseline_data_s2, V_xz,...
        'abd', 0, s1_name, hand_nm); 
    
elseif contains(angle_type, 'thumb')
    % This is not in use!!!! 
    % Tried the 45 degree angle plane in XYZ,m didnt really work :(
    ME = MException('thumb option for angle type is deprecated'); 
    throw(ME)
    
    if contains(hand_nm, 'Right')
        V_xyz = [1 0 0; 0 1 1]'; 
    elseif contains(hand_nm, 'Left')
        V_xyz = [1 0 0; 0 -1 1]';
    end
    
    % Normalize
    V_xyz(:, 2) = V_xyz(:, 2) / norm(V_xyz(:, 2)); 
    
    bend_ang = bend_angle(s1, s2, baseline_data_s1, baseline_data_s2, V_xyz,...
        'thumb', 0, s1_name, hand_nm);
end


function ba = bend_angle(euler1,euler2, baseline1, baseline2, V,...
        angle_type, prt ,s1_name, hand_nm)
    %inputs are euler angles of both sensors plus baseline values of both sensors 
    % V is the vectors spanning XY or XZ plane 
    
     % Rotate vectors by rotation matrix 
     roll1 = diff_roll(baseline1(3), euler1(3), hand_nm);
     roll2 = diff_roll(baseline2(3), euler2(3), hand_nm);
     
     % Print relative roll 
     if prt
         disp(['droll = ' num2str(roll1) ' Roll BL --> ' s1_name ': ' num2str(baseline1(3)) ' --> ' num2str(euler1(3))]);
     end
     
     euler1_adj = [euler1(1) euler1(2) roll1]; 
     euler2_adj = [euler2(1) euler2(2) roll2]; 
     
     R1 = eul2rotm(deg2rad(euler1_adj));
     R2 = eul2rotm(deg2rad(euler2_adj)); 
     
     % Vectors of sensor 1; 
     V1 = R1*V;
     
     % Vectors of sensor 2; 
     V2 = R2*V; 
     
     % Cross product of vectors on plane 1; 
     cross1 = cross(V1(:, 1), V1(:, 2)); %normal vector to  vector1 and 2 on plane 1; 
     cross1_norm = cross1 / norm(cross1); 
     
     % Project vector1 from plane 2 in direction of sensor V2(:, 1) onto
     % plane 1; 
     proj_V2_plane1 = V2(:, 1) - (dot(V2(:, 1), cross1_norm)*cross1_norm); 
     
     % Bend angle b/w proj_V2_plane1 and vector2 
     ba = acosd(dot(proj_V2_plane1, V2(:, 1)));
     
     % Determining whether bend angle is up or down (pos or neg).  
    pn = cross(proj_V2_plane1, V2(:, 1));  %determine normal vector to vector 1 and projected vector 3
    norm_rot = R2'*pn;  %undo rotation from vector to plane
    
    if contains(angle_type, 'flex')
        % Convention -- flexion is +
        index = 2;  
        if norm_rot(index) < 0; ba = -1*ba; assert(dot(norm_rot, V(:, 2)) < 0); end
        
    elseif contains(angle_type, 'abd')
        % Convention 
        index = 3; 
        if norm_rot(index) > 0; ba = -1*ba; assert(dot(norm_rot, V(:, 2)) > 0); end
    
    elseif contains(angle_type, 'thumb')
        
        % Is projection onto second vector + or -
        if dot(norm_rot, V(:, 2)) > 0; ba = -1*ba; end
    else
        keyboard;
    end
        
end
end