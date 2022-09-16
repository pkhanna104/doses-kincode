function [angles, hint] = jt_angle_list(angle_str)
angles = nan; 
hint = nan; 
switch angle_str
    case 'Thumb MCP'
        angles = [0, 20, 40]; 
        hint = ' 0 is straight, > 0 is thumb flex ';
    case 'Thumb DIP' % 180 is straight, < 180 is flex 
        angles = [10, 40]; 
        hint = ' 0 is straight, > 0 is thumb flex ';
    case 'Index DIP' % 0 is straight, > 0 is flex 
        angles = [20, 50]; 
        hint = ' 0 is straight, > 0 is flex ';
    case 'Index PIP' %
        angles = [0, 30, 60];
        hint = ' 0 is straight, > 0 is flex';
    case 'Index MCP' % 0 is straight, > 0 is flex';
        angles = [0, 30, 60]; 
        hint = ' 0 is straight, > 0 is flex ';
    case 'Palm Flex' % flex (+)
        angles = [50, 20, -10, -40,]; 
        hint = 'ext is +'; 
    case 'Palm Abd' % abduction (+) towards thumb 
        angles = [10, -20]; 
        hint = 'abduction (+) towards thumb , 0 is straight'; 
    case 'Palm Prono' % 
        %angles = [0, 90, 180]; 
        angles = [0, 90]; 
        hint = 'pronation = hand down = 0 degrees; '; 
    case 'Elbow Flex' % straight is 180, flex is +
        angles = [150, 120, 90, 60]; 
        hint = 'straight is 180, flex is +'; 
    case 'Shoulder Roll'
        angles = [30, 0, -30]; 
        hint = ' 90 deg arm, + roll is inwards'; 
    case 'Shoulder VertFlex'
        angles = [-60, -30, 0]; 
        hint = 'straight arm is 0, + is flex upward, - is flex downard '; 
    case 'Shoulder HorzFlex'
        angles = [-30, 0, 30];
        hint = 'straight arm is 0, + flex is inwards'; 
end
if isnan(angles)
    x=10; 
end

