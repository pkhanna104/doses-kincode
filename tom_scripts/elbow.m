function [eb] = elbow(data);

%elbow bend 12 (shoulder) and 8 (wrist)

s = size(data);

for n = 1:s(1);
     
        
        x_mcp = cosd(data(n,1,12)).*cosd(data(n,2,12));
        y_mcp = sind(data(n,1,12)).*cosd(data(n,2,12));
        z_mcp = sind(data(n,2,12));
        v_mcp = [x_mcp y_mcp z_mcp];

  
        x_pip = cosd(data(n,1,8)).*cosd(data(n,2,8));
        y_pip = sind(data(n,1,8)).*cosd(data(n,2,8));
        z_pip = sind(data(n,2,8));
        v_pip = [x_pip y_pip z_pip];
        
             
         eb(n) = abs(acosd(dot(v_mcp,v_pip)));
        if cross(v_mcp,v_pip) < 0;
            eb(n) = abs((-1.*acosd(dot(v_mcp,v_pip))));
            %display(index_mcp_bend_3sensor);
        else
            %display(index_mcp_bend_3sensor);
        end
        
           
        
end
        
        
         