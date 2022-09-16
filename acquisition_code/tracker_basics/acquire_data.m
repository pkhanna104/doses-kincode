%tracker_setup;

fs = 10; % 10 Hz

%Rec = cell(100,1);
sensor = 11; 
while 1
    tic 
    
    % get data
    [~, ang] = get_positions(12);
    
    % pause for 1/fs 
    pause(1/fs - min([0, toc]))
    
    disp(ang(sensor,:)); 
end

%tracker_close;