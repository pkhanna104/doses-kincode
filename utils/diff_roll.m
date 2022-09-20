function droll = diff_roll(baseline, ang, hand_nm)
    
    v_baseline = [cosd(baseline); sind(baseline)]; 
    v_ang = [cosd(ang); sind(ang)]; 
    
    % Rotation matrix to send angle of zero to baseline
    R = [cosd(baseline) -sind(baseline);
         sind(baseline) cosd(baseline)]; 
     
    % Rotation matrix to send angle of baseline to zero
    RT = R'; 
    
    v_z = RT*v_baseline; 
    assert(abs(v_z(1) - 1) < 1e-13);
    assert(abs(v_z(2) - 0) < 1e-13);
    
    % Apply to angle; 
    v_ang_rot = RT*v_ang; 
    
%     Now figure out what this angle is
%     atan2  Four quadrant inverse tangent.
%     atan2(Y,X) is the four quadrant arctangent of the elements of X and Y
%     such that -pi <= atan2(Y,X) <= pi. X and Y must have compatible sizes.
%     In the simplest cases, they can be the same size or one can be a
%     scalar. Two inputs have compatible sizes if, for every dimension, the
%     dimension sizes of the inputs are either the same or one of them is 1.
    droll = rad2deg(atan2(v_ang_rot(2), v_ang_rot(1))); 
    

end