function [ib_mcp,ib_pip,ib_dip,th_mcp,th_dip,palm_flex, palm_abd, palm_prono,elbo_flex,sh_,] = index(cell_data);

%index mcp = sensor 5
%index pip = sensor 6
%index dip = sensor 7
%palm sensor = sensor 4
index_mcp = 5; %sensor 5
index_pip = 6; %sensor 6
index_dip = 7; %sensor 7
palm_sensor = 8; %sensor 4

data = []; 
for i = 1:100
    data = cat(3, data, cell_data{1, i}'); 
end
data = permute(data, [3, 1, 2]); 
s = size(data); % data is L x 3 x sensors


s = size(data);

for n = 1:s(1);
    
    %palm 
    
        x_palm = cosd(data(n,1,palm_sensor)).*cosd(data(n,2,palm_sensor));
        y_palm = sind(data(n,1,palm_sensor)).*cosd(data(n,2,palm_sensor));
        z_palm = sind(data(n,2,palm_sensor));
        v_palm = [x_palm y_palm z_palm];

   %%%% index mcp bend unaffected %%%%%%%    
        
        x_mcp = cosd(data(n,1,index_mcp)).*cosd(data(n,2,index_mcp));
        y_mcp = sind(data(n,1,index_mcp)).*cosd(data(n,2,index_mcp));
        z_mcp = sind(data(n,2,index_mcp));
        v_mcp = [x_mcp y_mcp z_mcp];

        %index_plane = cross(thumb_pip_mcp,index_dip_unit);
        
        x_pip = cosd(data(n,1,index_pip)).*cosd(data(n,2,index_pip));
        y_pip = sind(data(n,1,index_pip)).*cosd(data(n,2,index_pip));
        z_pip = sind(data(n,2,index_pip));
        v_pip = [x_pip y_pip z_pip];
        
          %%%% calculate dip angle 3 sensor %%%%%%%%%%%

        x_dip = cosd(data(n,1,index_dip)).*cosd(data(n,2,index_dip));
        y_dip = sind(data(n,1,index_dip)).*cosd(data(n,2,index_dip));
        z_dip = sind(data(n,2,index_dip));
        v_dip = [x_dip y_dip z_dip];
        
        ib_dip(n) = abs(acosd(dot(v_dip,v_pip)));
        if cross(v_mcp,v_pip) < 0;
            ib_dip(n) = abs((-1.*acosd(dot(v_dip,v_pip))));
            %display(index_mcp_bend_3sensor);
        else
            %display(index_mcp_bend_3sensor);
        end
        
        ib_pip(n) = abs(acosd(dot(v_mcp,v_pip)));
        if cross(v_mcp,v_pip) < 0;
            ib_pip(n) = abs((-1.*acosd(dot(v_mcp,v_pip))));
            %display(index_mcp_bend_3sensor);
        else
            %display(index_mcp_bend_3sensor);
        end
        
        ib_mcp(n) = abs(acosd(dot(v_mcp,v_palm)));
        if cross(v_mcp,v_palm) < 0;
            ib_mcp(n) = abs((-1.*acosd(dot(v_mcp,v_palm))));
            %display(index_mcp_bend_3sensor);
        else
            %display(index_mcp_bend_3sensor);
        end
        
end
        
        
         