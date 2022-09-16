function mn = circMean(angledata_deg)

mn_s = mean(sind(angledata_deg)); 
mn_c = mean(cosd(angledata_deg)); 

%-pi <= atan2(Y,X) <= pi.
mn = rad2deg(atan2(mn_s, mn_c)); 