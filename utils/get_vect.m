function vect = get_vect(a,e)

% Sensor is aligned such that its length is aligned to [1;0;0] in global
% axes (see page 147 of the manual) 

% In order to rotate the unit vector [1;0;0] to sensor orientation,
% multiple by rotation matrix

% Assume roll is 0 since doesn't matter for this 
r = 0; 

% Rotation matrix 
M = euler2rot(a, e, r, 1); 
vect0 = M*[1;0;0]; 

% Manual method 
x = cosd(a).*cosd(e);
y = sind(a).*cosd(e);
z = -1*sind(e); % changed from sind(e) to -1*sind(e) on 9/14; 
vect = [x y z];

% Make sure these are the same regardless of method
assert(all(abs(vect0'-vect) < 1e-13))

% Make sure norm of vector is 1; 
assert(abs(norm(vect) - 1) < 1e-13); 
