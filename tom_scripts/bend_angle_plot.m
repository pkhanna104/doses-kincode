clear all;
euler1 = [60 45 45]; %sensor 1 more proximal -> yaw, pitch, roll (deg)
euler2 = [45 0 30];  %sensor 2 more distal -> yaw, pitch, roll (deg)

ba = bend_angle(euler1,euler2);

function ba = bend_angle(euler1,euler2);  %inputs are euler angles of both sensors 

    coord = [    % create coordinates xyz of plane
    0 0 0
    1 0 0 
    1 0 0.2
    0 0 0.2];

    %%%%%%%%%%%%%
    % step 1:  create a plane 1 (red) and rotate according to sensor 1 euler angles
    %%%%%%%%%%%%%
    
    R = eul2rotm(deg2rad(euler1));  %create rotation matrix from sensor 1
    
    % Preeya addition; 
%     tol = 1; 
%     % Sensor space to real world space; 
%     R2 = euler2rot(euler1(1), euler1(2), euler1(3), tol);
%     % Real world space to sensor space
%     R2 = R2'; 
    
    coord_r = R*coord';  %rotate plane coordinates according to sensor 1 angles
    coord_r = coord_r';
    patch(coord_r(:,1)',coord_r(:,2)',coord_r(:,3)','r');  %draw plane in plot red

    %%%%%%%%%%%%%
    % step 2:  create two vectors lying on rotated plane 1
    %%%%%%%%%%%%%

    pv_1 = (coord_r(2,:) - coord_r(1,:)) / (norm(coord_r(2,:) - coord_r(1,:))); %vector1 representing bottom edge of plane in rotated plane 
    pv_2 = (coord_r(4,:) - coord_r(1,:)) / (norm(coord_r(4,:) - coord_r(1,:))); %vector2 representing left edge of plane in rotated plane (perpendicular to vector 1 
   
    %%%%%%%%%%%%%
    % step 3:  Calc normal vector to two vectors lying on plane 1
    %%%%%%%%%%%%%

    pv_norm = cross(pv_1,pv_2);  %normal vector to  vector1 and 2
 
    %%%%%%%%%%%%%
    % step 4:  create a plane 2 (blue) and rotate according to sensor 2 euler angles
    %%%%%%%%%%%%%
    
    R = eul2rotm(deg2rad(euler2)); %create rotation matrix from sensor 2
    coord_r = R*coord'; %rotate a second plane coordinates according to sensor 2 angle
    coord_r = coord_r';
    patch(coord_r(:,1)',coord_r(:,2)',coord_r(:,3)','b'); %draw plane in plot blue

    %%%%%%%%%%%%%
    % step 5:  create a vector lying on rotated plane 2 (same bottom edge as
    % pv_1)
    %%%%%%%%%%%%%
    pv_3 = [coord_r(2,:) - coord_r(1,:)] / (norm(coord_r(2,:) - coord_r(1,:))); %vector3 representing bottom edge of plane in rotated plane 

    %%%%%%%%%%%%%
    % step 6:  project vector 3 onto plane 1.  Then calculate bend angle
    % between vector 1 and vector 3.  This is the bend angle we want to
    % calculate.
    %%%%%%%%%%%%%
    proj_pv_3 = pv_3 - (dot(pv_3,pv_norm).*pv_norm) ./ norm(pv_norm).^2; %project vector 3 (pv_3) onto plane of sensor 1
    ba = acosd(dot(pv_1,proj_pv_3));  %calculate angle between vector 1 and vector 3 (angle we care about!)
    
    %%%%%%%%%%%%%
    % step 7:  Determining whether bend angle is up or down (pos or neg).  
    %%%%%%%%%%%%%
    pn = cross(pv_1,proj_pv_3);  %determine normal vector to vector 1 and projected vector 3
    norm_rot = inv(eul2rotm(deg2rad(euler1)))*pn';  %undo rotations to normal vector pn.  Idea being to rotate this normal vector so that normal to zx plane.  If y component of this vector is negative, bend angle is down. If pos, bend angle is up 
    if norm_rot(2) > 0
        ba = -ba;
    end
    
    
    axis([-0.75 0.75 -0.75 0.75 -0.75 0.75])
    view(3)
    grid on;
    hold on;

end

