function acquire_save_data(filename)

% Initialize Variables
num_sensors = 12;

data = struct(); 
for i = 1:num_sensors
    data.position.(strcat('sensor',num2str(i))) = [];
    data.angles.(strcat('sensor',num2str(i))) = [];
    data.time = [];
    data.matlab_timer = [];
    data.datetime = [];
end

timer_start = tic; 

disp('Starting recording'); 

KEY_IS_PRESSED = 0;
gcf
set(gcf, 'KeyPressFcn', @myKeyPressFcn)
niters = 0; 

while ~KEY_IS_PRESSED
    drawnow
    
    [pos,ang,t] = get_positions(num_sensors);
    for i = 1:num_sensors
        data.position.(strcat('sensor',num2str(i)))(end+1,:) = pos(i,:);      
        data.angles.(strcat('sensor',num2str(i)))(end+1,:) = ang(i,:);
    end
    
    data.time(end+1) = t;
    data.matlab_time = [data.matlab_timer toc(timer_start)]; 
    
    % Get datetime % 
    tmp_d = datetime;
    % Reformat in Y - Month - Day - Hour - Minute - Second:
    tmp_datetime = [tmp_d.Year, tmp_d.Month, tmp_d.Day, tmp_d.Hour, tmp_d.Minute, tmp_d.Second];
    data.datetime(end+1, :) = tmp_datetime;
    niters = niters + 1; 
end

data.niters = niters; 
try
    disp(['Saving data here: ' filename] ); 
    save(filename,'data'); 
catch
    tmp_d = datetime;
    DateString = datestr( tmp_d);
    DateStringnew = strrep(DateString, ' ', '_'); 
    DateStringnew = strrep(DateStringnew, '-', '_'); 
    DateStringnew = strrep(DateStringnew, ':', '_'); 
    save(['taskdata_' DateStringnew], 'data'); 
end
    

function myKeyPressFcn(hObject, event)
    KEY_IS_PRESSED  = 1;
    disp('end of recording!')
end
end