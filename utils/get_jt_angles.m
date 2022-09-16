function angle_struct = get_jt_angles(cell_data, datatype)%, baseline_data)

% Sensor IDs for data collected in Aug 2022 %
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

if contains(datatype, 'angle_validation')
    % Get data from cell array to matrix (Samples x [X,Y,Z] x sensors)
    data = []; 
    for i = 1:size(cell_data, 2)
        data = cat(3, data, cell_data{1, i}'); 

    end
    data = permute(data, [3, 1, 2]); 
    s = size(data);   
    
elseif contains(datatype, 'task_data')
    
    data = cell_data; 
    assert(size(data, 2) == 3)
    assert(size(data, 2) == 12)
    s = size(data);  
end

tol = 1; % Tolerance acceptable for estimate fo rotation matrix


for n = 1:s(1)
    
   % palm -- get vector in direction of pam  
   v_palm = get_vect(data(n,1,palm_sensor),data(n,2,palm_sensor)); 
   
   %% index vectors %%%%%%%    
   v_mcp = get_vect(data(n,1,index_mcp),data(n,2,index_mcp)); 
   v_pip = get_vect(data(n,1,index_pip),data(n,2,index_pip)); 
   v_dip = get_vect(data(n,1,index_dip),data(n,2,index_dip)); 
   
   %%% assume no negative angles %%% 
   ib_dip(n) = acosd(dot(v_dip, v_pip)); 
   ib_pip(n) = acosd(dot(v_pip, v_mcp)); 
   ib_mcp(n) = acosd(dot(v_mcp, v_palm)); 
   
   %% thumb vectors %%% 
   vt_mcp = get_vect(data(n,1,thumb_mcp),data(n,2,thumb_mcp)); 
   vt_pip = get_vect(data(n,1,thumb_pip),data(n,2,thumb_pip)); 
   vt_dip = get_vect(data(n,1,thumb_dip),data(n,2,thumb_dip)); 
   
   th_mcp(n) = acosd(dot(vt_pip, vt_mcp)); 
   th_dip(n) = acosd(dot(vt_dip, vt_pip)); 

   %% Palm %%% 
   palm_prono(n)= data(n,3,palm_sensor); 
   
   % one cannot subtract euler angles to get relative orientation % 
   % https://math.stackexchange.com/questions/320981/how-to-get-euler-angles-with-respect-to-initial-euler-angle
    
   % Convert lower arm rotation angle %%
   R_lower_arm = euler2rot(data(n, 1, lower_arm), data(n, 2, lower_arm), data(n, 3, lower_arm), tol);
   % Matrix to go from sensor coordinates to real world coordintes; 
   %R_lower_arm = eul2rotm(deg2rad(data(n, :, lower_arm)), 'ZYX');
   
   % Matrix to go from lower arm to palm is R_p * R_la ' 
   R_palm = euler2rot(data(n, 1, palm_sensor), data(n, 2, palm_sensor), data(n, 3, palm_sensor), tol);
   %R_palm = eul2rotm(deg2rad(data(n, :, palm_sensor)), 'ZYX');
   
   % Calculate matrix to go from lower arm to palm
   R_eff = R_palm*(R_lower_arm'); 
   
   % Euler angles of this matrix
   % out_angs = SpinCalc('DCMtoEA321', R_eff, tol, 0); 
   out_angs = rotm2eul(R_eff, 'ZYX'); 
   r_az = rad2deg(inRange(out_angs(1))); 
   r_el = rad2deg(inRange(out_angs(2)));
   
   % Assign these to palm flex / abd; 
   palm_flex(n) = -1*r_el; 
   palm_abd(n) = r_az; 
   
   
   %% Option 2 -- testing out tom's plane idea
%    baseline = load(baseline_data); 
%    baseline_data_lower_arm = baseline.data.angles.sensor1(end, :); 
%    baseline_data_palm = baseline.data.angles.sensor4(end, :); 
%    
%    [bend_flex, bend_abd] = bend_angle_plane(baseline_data_palm, ...
%     baseline_data_lower_arm, data(n, :, palm_sensor), data(n, :, lower_arm)); 
%    palm_flex(n) = bend_flex; 
%    palm_abd(n) = bend_abd; 
      
   %% Elbow items %%% 
   v_lower_arm= get_vect(data(n,1,lower_arm), data(n,2,lower_arm)); 
   v_upper_arm = get_vect(data(n,1,upper_arm), data(n,2,upper_arm)); 
   elbo_flex(n) = acosd(dot(v_lower_arm, v_upper_arm));
   
   %% Shoulder sh_rol,sh_vert,sh_horz
   sh_horz(n) = data(n,1,upper_arm); % azimuth 
   sh_vert(n) = data(n,2,upper_arm); % elevation 
   sh_rol(n) =  data(n,3,upper_arm); % roll of sensor
   
end
   
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
