function [ib_mcp,ib_pip,ib_dip,th_mcp,th_dip,palm_flex, palm_abd, palm_prono,elbo_flex,sh_rol,sh_vert,sh_horz] = index_c_edited(cell_data)

thumb_mcp = 9; 
thumb_pip = 10; 
thumb_dip = 11; 

index_mcp = 5; %sensor 5
index_pip = 6; %sensor 6
index_dip = 7; %sensor 7
palm_sensor = 8; %sensor 4
lower_arm = ?; 
upper_arm = ?; 

data = []; 
for i = 1:100
    data = cat(3, data, cell_data{1, i}'); 
end
data = permute(data, [3, 1, 2]); 
s = size(data); % data is L x 3 x sensors

for n = 1:s(1)
    
   %palm 
   v_palm = get_vect(data(n,1,palm_sensor),data(n,2,palm_sensor)); 

   %%%% index vectors %%%%%%%    
   v_mcp = get_vect(data(n,1,index_mcp),data(n,2,index_mcp)); 
   v_pip = get_vect(data(n,1,index_pip),data(n,2,index_pip)); 
   v_dip = get_vect(data(n,1,index_dip),data(n,2,index_dip)); 
   
   ib_dip(n) = acosd(dot(v_dip, v_pip)); 
   ib_pip(n) = acosd(dot(v_pip, v_mcp)); 
   ib_mcp(n) = acosd(dot(v_mcp, v_palm)); 
   
   %%% thumb vectors %%% 
   vt_mcp = get_vect(data(n,1,thumb_mcp),data(n,2,thumb_mcp)); 
   vt_pip = get_vect(data(n,1,thumb_pip),data(n,2,thumb_pip)); 
   vt_dip = get_vect(data(n,1,thumb_dip),data(n,2,thumb_dip)); 
   
   th_mcp(n) = acosd(dot(vt_pip, vt_mcp)); 
   th_dip(n) = acosd(dot(vt_dip, vt_pip)); 
   
   %%% Palm items %%% 
   palm_flex(n) = data(n,2,palm_sensor) - data(n, 2, lower_arm); 
   palm_abd(n) = abs(data(n,1,palm_sensor)) - abs(data(n,2,lower_arm)); 
   if palm_abd(n) > 80
       palm_abd(n) = palm_abd(n) - 180; 
   end
   palm_prono(n) = abs(data(n,3,palm_sensor)); 
   
   %%% Elbow items %%% 
   v_lower_arm= get_vect(data(n,1,lower_arm), data(n,2,lower_arm)); 
   v_upper_arm = get_vect(data(n,1,upper_arm), data(n,2,upper_arm)); 
   elbo_flex(n) = acosd(dot(v_lower_arm, v_upper_arm));
   
   %%% Shoulder sh_rol,sh_vert,sh_horz
   sh_horz(n) = abs(data(n,1,upper_arm)); 
   sh_vert(n) = abs(data(n,2,upper_arm)); 
   sh_rol(n) = abs(data(n,3,upper_arm)); 
end
   
   
   
    