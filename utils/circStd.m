function sd = circStd(angledata_deg)

mn_s = mean(sind(angledata_deg)); 
mn_c = mean(cosd(angledata_deg)); 

% Resultant length 
r = sqrt(mn_s^2 + mn_c^2); 

% Formula for std 
sd_rad = sqrt(-2*log(r)); 

% Convert back to degrees; 
sd = sd_rad/pi*180; 