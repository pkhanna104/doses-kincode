function sens_unroll = unroll_sensor(sens)

%%% Unroll a sensor value (nx1 vector) in degrees
rad_sens = sens/180*pi; 
unroll = unwrap(rad_sens); 
sens_unroll = unroll*180/pi; 