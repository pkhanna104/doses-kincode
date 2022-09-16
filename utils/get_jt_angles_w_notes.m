function angle_struct = get_jt_angles(cell_data, pos_data, hand)

lower_arm = 1; % Inserted parallel to other sensors
upper_arm = 2; % Inserted so that sensor is pointing upwards 
palm_sensor = 4; % sensor was 8 for 8-23 data, moved to 4 for 8/24 onward

index_mcp = 5; %sensor 5
index_pip = 6; %sensor 6
index_dip = 7; %sensor 7

thumb_mcp = 9; 
thumb_pip = 10; 
thumb_dip = 11; 
object_sensor = 12; 

tol = 1; % Tolerance acceptable for estimate fo rotation matrix

% Get data from cell array to matrix (Samples x [X,Y,Z] x sensors)
data = []; pos = []; 
for i = 1:size(cell_data, 2)
    data = cat(3, data, cell_data{1, i}'); 
    pos = cat(3, pos, pos_data{1, i}'); 
end
data = permute(data, [3, 1, 2]); 
pos = permute(pos, [3, 1, 2]); 
s = size(data); 


for n = 1:s(1)
    
   % palm -- get vector in direction of pam  
   v_palm = get_vect(data(n,1,palm_sensor),data(n,2,palm_sensor)); 
   
   % Rotation matrix to rotate into palm space --> from NDI manual 
   % If you take a vector like [1, 0, 0], you'll then rotate from wrist
   % space into real world space
   R_palm = euler2rot(data(n, 1, palm_sensor), data(n, 2, palm_sensor), data(n, 3, palm_sensor), tol);
   
   % From real world space into wrist space % 
   RT_palm = R_palm'; 
   
   %%%% index vectors %%%%%%%    
   v_mcp = get_vect(data(n,1,index_mcp),data(n,2,index_mcp)); 
   v_pip = get_vect(data(n,1,index_pip),data(n,2,index_pip)); 
   v_dip = get_vect(data(n,1,index_dip),data(n,2,index_dip)); 
   
   % What is the direction of the vector w.r.t wrist?
   vx1 = cross(v_pip, v_dip); vx1 = vx1/norm(vx1); 
   vx2 = cross(v_mcp, v_pip); vx2 = vx2/norm(vx2); 
   vx3 = cross(v_palm, v_mcp); vx3 = vx3/norm(vx3); 
    
    % Move in direction of x product should be closer to palm if L hand
    %    d_pos_cross = 5*vx1 + pos(n,:,index_pip); 
    %    d_neg_cross = -5*vx1 + pos(n,:,index_pip); 
    %    
    %    ib_dip_sign = 1; 
    %    if norm(d_pos_cross - pos(n,:,palm_sensor)) < norm(d_neg_cross - pos(n,:,palm_sensor))
    %        if contains(hand, 'R')
    %            ib_dip_sign = -1;
    %        end
    %    else
    %        if contains(hand, 'L')
    %            ib_dip_sign = -1; 
    %        end
    %    end
    %    

%    % Direction of wrist to 
%    vx1_wrt_palm = RT_palm*vx1';
%    if vx1_wrt_palm(2) < 0, ib_dip_sign = 1; else, ib_dip_sign = -1; end
%    
%    vx2_wrt_palm = RT_palm*vx2';
%    if vx2_wrt_palm(2) < 0, ib_pip_sign = 1; else, ib_pip_sign = -1; end
%    
%    vx3_wrt_palm = RT_palm*vx3';
%    if vx3_wrt_palm(2) < 0, ib_mcp_sign = 1; else, ib_mcp_sign = -1; end
%    
%    ib_dip_sign=1;
%    ib_pip_sign=1;
%    ib_mcp_sign=1;
   %if cross(v_pip, v_dip) < 0;
   ib_dip(n) = ib_dip_sign*acosd(dot(v_dip, v_pip)); 
   ib_pip(n) = acosd(dot(v_pip, v_mcp)); 
   ib_mcp(n) = acosd(dot(v_mcp, v_palm)); 
   
   
%    R_palm = euler2rot(data(n, 1, palm_sensor), data(n, 2, palm_sensor), data(n, 3, palm_sensor), tol); 
%    R_mcp = euler2rot(data(n, 1, index_mcp), data(n, 2, index_mcp), data(n, 3, index_mcp), tol); 
%    R_pip = euler2rot(data(n, 1, index_pip), data(n, 2, index_pip), data(n, 3, index_pip), tol);
%    R_dip = euler2rot(data(n, 1, index_dip), data(n, 2, index_dip), data(n, 3, index_dip), tol);
%    
%    Matrix to go from PIP to DIP
%    R_pip2dip = R_dip*(R_pip'); 
%    pip2dip_angs = SpinCalc('DCMtoEA321', R_pip2dip, tol, 0); 
%    ib_dip(n) = inRange(pip2dip_angs(2)); %elevation
%    
%    Matrix to go from MCP to PIP
%    R_mcp2pip = R_pip*(R_mcp'); 
%    mcp2pip_angs = SpinCalc('DCMtoEA321', R_mcp2pip, tol, 0); 
%    ib_pip(n) = inRange(mcp2pip_angs(2)); %elevation
%    
%    Matrix to go from PALM to MCP
%    R_palm2mcp = R_mcp*(R_palm'); 
%    palm2mcp_angs = SpinCalc('DCMtoEA321', R_palm2mcp, tol, 0); 
%    ib_mcp(n) = inRange(palm2mcp_angs(2)); %elevation
   
   
   %%% thumb vectors %%% 
   vt_mcp = get_vect(data(n,1,thumb_mcp),data(n,2,thumb_mcp)); 
   vt_pip = get_vect(data(n,1,thumb_pip),data(n,2,thumb_pip)); 
   vt_dip = get_vect(data(n,1,thumb_dip),data(n,2,thumb_dip)); 
   
   th_mcp(n) = acosd(dot(vt_pip, vt_mcp)); 
   th_dip(n) = acosd(dot(vt_dip, vt_pip)); 

%    R_thmcp = euler2rot(data(n, 1, thumb_mcp), data(n, 2, thumb_mcp), data(n, 3, thumb_mcp), tol); 
%    R_thpip = euler2rot(data(n, 1, thumb_pip), data(n, 2, thumb_pip), data(n, 3, thumb_pip), tol);
%    R_thdip = euler2rot(data(n, 1, thumb_dip), data(n, 2, thumb_dip), data(n, 3, thumb_dip), tol);
%    
%    Matrix to go from THUMB PIP to DIP
%    R_THpip2dip = R_thdip*(R_thpip'); 
%    THpip2dip_angs = SpinCalc('DCMtoEA321', R_THpip2dip, tol, 0); 
%    th_dip(n) = inRange(THpip2dip_angs(2)); %elevation
% 
%    R_THmcp2pip = R_thpip*(R_thmcp'); 
%    THmcp2pip_angs = SpinCalc('DCMtoEA321', R_THmcp2pip, tol, 0); 
%    th_mcp(n) = inRange(THmcp2pip_angs(2)); %elevation
%    
   %%% Palm items %%% 
%    palm_flex(n) = data(n,2,palm_sensor) - data(n, 2, lower_arm); 
%    palm_abd(n) = abs(data(n,1,palm_sensor)) - abs(data(n,1,lower_arm)); 
%    if palm_abd(n) > 80
%        palm_abd(n) = palm_abd(n) - 180; 
%    end
%    palm_prono(n) = abs(data(n,3,palm_sensor)); 
%   
   % maybe these should be circular subtraction? 
   % palm_flex(n) = circularSub(data(n,2,palm_sensor), data(n,2,lower_arm)); 
   % palm_abd(n)  = circularSub(data(n,1,palm_sensor), data(n,1,lower_arm)); 
   palm_prono(n)= data(n,3,palm_sensor); 
   
   % one cannot subtract euler angles to get relative orientation % 
   % https://math.stackexchange.com/questions/320981/how-to-get-euler-angles-with-respect-to-initial-euler-angle
    
   R_lower_arm = euler2rot(data(n, 1, lower_arm), data(n, 2, lower_arm), data(n, 3, lower_arm), tol); 
   
   % Matrix to go from lower arm to palm is R_p * R_la ' 
   R_eff = R_palm*(R_lower_arm'); 
   
   % Euler angles of this matrix
   out_angs = SpinCalc('DCMtoEA321', R_eff, tol, 0); 
   r_az = inRange(out_angs(1)); 
   r_el = inRange(out_angs(2));
   
   % Assign these to palm flex / abd; 
   palm_flex(n) = r_el; 
   palm_abd(n) = r_az; 
      
   %%% Elbow items %%% 
   v_lower_arm= get_vect(data(n,1,lower_arm), data(n,2,lower_arm)); 
   v_upper_arm = get_vect(data(n,1,upper_arm), data(n,2,upper_arm)); 
   elbo_flex(n) = acosd(dot(v_lower_arm, v_upper_arm));
   
   %%% Shoulder sh_rol,sh_vert,sh_horz
   sh_horz(n) = data(n,1,upper_arm); 
   sh_vert(n) = data(n,2,upper_arm);
   sh_rol(n) =  data(n,3,upper_arm); 
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
if ang > 180
    ang = ang - 360; 
end
end
