function [bend_flex, bend_abd] = bend_angle_plane(baseline_data_palm, ...
    baseline_data_lower_arm, palm, lower_arm)

% Baseline data where we can assume XY plane has a roll of 0; 
%baseline_data_palm = [164.3774  -21.6431 -126.1230]'; 
%baseline_data_lower_arm = [141.6797  -14.1284  -56.7993]'; 

% Test data (palm flexion == 20); 
%palm = [177.2534    6.3062 -122.5415]'; 
%lower_arm = [158.5767  -17.2925  -54.4043]'; 

bend_flex = bend_angle_flex_ext(lower_arm, palm, baseline_data_lower_arm, baseline_data_palm); 
bend_abd = bend_angle_abd_add(lower_arm, palm, baseline_data_lower_arm, baseline_data_palm); 

function ba = bend_angle_flex_ext(euler1,euler2, baseline1, baseline2)
    %inputs are euler angles of both sensors plus baseline values of both sensors 

     % create vector for XY plane (3 dim x 2 column vectors) 
     V = [1 0 0; 0 1 0]'; 
     
     % Rotate vectors by rotation matrix 
     roll1 = euler1(3) - baseline1(3); 
     roll2 = euler2(3) - baseline2(3); 
     
     % todo: bound roll 1
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
    if norm_rot(2) < 0
        ba = -ba;
    end
end

function ba = bend_angle_abd_add(euler1,euler2, baseline1, baseline2)
    %inputs are euler angles of both sensors plus baseline values of both sensors 

     % create vector for XZ plane (3 dim x 2 column vectors) 
     V = [1 0 0; 0 0 1]'; 
     
     % Rotate vectors by rotation matrix 
     roll1 = euler1(3) - baseline1(3); 
     roll2 = euler2(3) - baseline2(3); 
     
     % todo: bound roll 1
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
    if norm_rot(2) < 0
        ba = -ba;
    end
end
end