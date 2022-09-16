function [palm] = palm_bend(palm,wrist)
 
%palm flex

    

    palm_flex = palm(:,2) - wrist(:,2);
    
    
    
    %wrist(value,1) = wrist(value,1) - 180;
    
    palm_azi = abs(palm(:,1)) - abs(wrist(:,1));
    value = find(palm_azi > 80);
    palm_azi(value) = palm_azi(value) - 180;
    value = find(palm_azi > 50);
    %palm_azi(value) = palm_azi(value)-360
    pa = [palm(:,1) wrist(:,1) palm_azi];
    
    palm_roll = abs(palm(:,3)); 
    
    palm = [palm_azi palm_flex palm_roll];
    
  
                   
        
end
        



