function M = euler2rot(a, e, r, tol)

% from page 158 of the NDI manual 
% based on info from Appendix 2 of the manual (pg 255), need to multiply
% the transpose of this matrix to a vector through given transform 

% also transformation matrix to go from sensor space to global space 

% if vector is [1;0;0] will show unit vector of sensor 
M = [ cosd(e)*cosd(a),                             cosd(e)*sind(a)                            -sind(e);
    -(cosd(r)*sind(a))+(sind(r)*sind(e)*cosd(a)), (cosd(r)*cosd(a))+(sind(r)*sind(e)*sind(a)), sind(r)*cosd(e);
     (sind(r)*sind(a))+(cosd(r)*sind(e)*cosd(a)),-(sind(r)*cosd(a))+(cosd(r)*sind(e)*sind(a)), cosd(r)*cosd(e)];

 M = M'; 
  
% out = SpinCalc('DCMtoEA321', M, tol, 0); 
% rz = out(1); 
% ry = out(2); 
% rx = out(3); 

% assert(abs(rz-a) < tol)
% assert(abs(ry-e) < tol)
% assert(abs(rx-r) < tol)
