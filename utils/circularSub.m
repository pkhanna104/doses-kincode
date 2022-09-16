function diff = circularSub(alpha, beta)
% method to find difference between two angles 
% alpha -- angle in degrees
% beta -- angle in degrees 
% Range: -180: 180

diff = alpha - beta;
if diff > 180
    diff = diff - 360; 
elseif diff < -180
    diff = diff + 360; 
end
