function [pos, ang, t] = get_positions(numSensors)
% tracker_position_angles: displays attached sensors positions, angles
% and quality number to the MATLAB command window
%
% Edited by DBS to only get 1 position sample

% Ascension Technology Corporation

global libstring;
global SensorNumAttached; % number of attached sensors
global numBoards;% number of boards

% Get synchronous Record
% Initialize structure

for kk = 0:((4 * numBoards) - 1)
    sm.(['x' num2str(kk)]) = 0;
    sm.(['y' num2str(kk)]) = 0;
    sm.(['z' num2str(kk)]) = 0;
    sm.(['a' num2str(kk)]) = 0;
    sm.(['e' num2str(kk)]) = 0;
    sm.(['r' num2str(kk)]) = 0;
    sm.(['time' num2str(kk)]) = 0;
    sm.(['quality' num2str(kk)]) = 0;
end

if numBoards == 1
    pRecord = libpointer('tagDOUBLE_POSITION_ANGLES_TIME_Q_RECORD_AllSensors_Four', sm);
elseif numBoards == 2
    pRecord = libpointer('tagDOUBLE_POSITION_ANGLES_TIME_Q_RECORD_AllSensors_Eight', sm);
elseif numBoards == 3
    pRecord = libpointer('tagDOUBLE_POSITION_ANGLES_TIME_Q_RECORD_AllSensors_Twelve', sm);
else
    pRecord = libpointer('tagDOUBLE_POSITION_ANGLES_TIME_Q_RECORD_AllSensors_Sixting', sm);
end


Error   = calllib(libstring, 'GetAsynchronousRecord',  hex2dec('ffff'), pRecord, 4*numBoards*64);
errorHandler(Error);

Record = get(pRecord, 'Value');

pos = nan(numSensors,3);
ang = nan(numSensors,3); 
for i=1:numSensors
    if SensorNumAttached(i)
        % active sensor
        pos(i,1) = Record.(['x' num2str(i - 1)]);
        pos(i,2) = Record.(['y' num2str(i - 1)]);
        pos(i,3) = Record.(['z' num2str(i - 1)]);
        
        % angle
        ang(i,1) = Record.(['a', num2str(i-1)]); 
        ang(i,2) = Record.(['e', num2str(i-1)]); 
        ang(i,3) = Record.(['r', num2str(i-1)]);
    end
end

% convert to cm
pos = pos./.301; % honestly no idea how this conversion came about; 

t = Record.time0;







