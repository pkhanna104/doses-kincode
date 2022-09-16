function [zscore_mean, zscore_std,u_height,unaffect_all,data_palm,force,unaffect,u_time,sam_p_sec] = un_all(unaffected,len);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% unaffected data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

s = size(unaffected.T_mat);

sam_p_sec = s(2)/max(unaffected.T_mat);

s = size(unaffected.T_state);


for n = 2:s(2)
    index(n) = floor(sam_p_sec .* unaffected.T_state(n));
    index2 = find(round(unaffected.T_mat,1)  == round(unaffected.T_state(n),1))-20;%-20 originally 
    
    index3(n) = index2(1);
    index4 = find(round(unaffected.T_mat,1)  == round(unaffected.T_state(n),1))+len; %80 or 250 works for most
    
    index5(n) = index4(1);
end

m = 1;
for n = 2:2:20;  %bc of the way task_state is organized!!
    %trial{m} = index3(n):index3(n+1); %start of button press to start of next button press
    trial{m} = index3(n):index5(n); %start of button press to start of next button press
    m = m + 1;
end
  
data_concat_unaf = cat(2,trial{1:10});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = unaffected.angle_data;
data_p = unaffected.pos_data;
data_h = unaffected.obj_height;
u_T_mat = unaffected.T_mat;
data_f = unaffected.ard_pressure_sensor;


for n = 1:10
    [tb_mcp,tb_dip] = thumb(data(trial{n},:,:));
    [eb] = elbow(data(trial{n},:,:));
    [ib_mcp,ib_pip,ib_dip] = index_c(data(trial{n},:,:));
    wrist = data(trial{n},:,8);
    data_palm{n} = data_p(trial{n},:,4);  % pos of palm
    force{n} = data_f(trial{n});
    
    palm = data(trial{n},:,4);
    palm = palm_bend(palm,wrist);
    shoulder_ang = data(trial{n},:,12);
    shoulder_hor_flex = abs(shoulder_ang(:,1));
    shoulder_ver_flex = abs(shoulder_ang(:,2));
    shoulder_roll = abs(shoulder_ang(:,3));
    shoulder_ang = [shoulder_hor_flex shoulder_ver_flex shoulder_roll];
    
    unaffect{n} = [tb_mcp' tb_dip' ib_pip' ib_dip' eb'  palm shoulder_ang];
    
    [unaffect_a,zscore_mean{n}, zscore_std{n}] = zscore(abs([tb_mcp'-tb_mcp(1) tb_dip'-tb_dip(1) ib_mcp'-ib_mcp(1) ib_pip'-ib_pip(1) ib_dip'-ib_dip(1) eb'-eb(1) palm-palm(1,:) shoulder_ang-shoulder_ang(1,:)]));
    unaffect_a = abs([tb_mcp'-tb_mcp(1) tb_dip'-tb_dip(1) ib_mcp'-ib_mcp(1) ib_pip'-ib_pip(1) ib_dip'-ib_dip(1) eb'-eb(1) palm-palm(1,:) shoulder_ang-shoulder_ang(1,:)]);

    unaffect_all{n} = unaffect_a - unaffect_a(1,:);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %normalize data by z-scoring!!!!
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %unaffect_all{n} = unaffect_a - (180/pi).*circ_mean((pi/180).*unaffect_a)./((180/pi).*circ_std((pi/180).*unaffect_a));
    
    
%     dist_block{n} = [tb_mcp' tb_dip' ib_pip' ib_dip'];
%     ave = mean(dist_block{n});
%     dist_block_n{n} = dist_block{n} - ave;
%     [coeff,score,latent,tsquared,explained,mu] = pca(dist_block_n{n});
%     db = find(coeff(:,1) == max(coeff(:,1)));
%     
%     prox_block{n} = [shoulder_ang];
%     ave = mean(prox_block{n});
%     prox_block_n{n} = prox_block{n} - ave;
%     [coeff,score,latent,tsquared,explained,mu] = pca(prox_block_n{n});
%     pb = find(coeff(:,1) == max(coeff(:,1)));
% 
%     
%     i = [1:4];
%     i(db) = [];
%     unaffect{n}(:,i) = [];
%     %tot_std(:,i) = [];
%     i = [6:8];
%     i(pb) = [];
%     unaffect{n}(:,i) = [];
%     %tot_std(:,i) = [];
    
    
    
    u_circ = (pi/180)*[tb_mcp' tb_dip' ib_pip' ib_dip' eb' palm shoulder_ang];
    [s s0] = circ_std(u_circ);
    
    u_std{n} = [180*s0/pi];
    u_height{n} = data_h(trial{n});
    u_time{n} = u_T_mat(trial{n});
    u_time{n} = [u_time{n}-u_time{n}(1)]'; 
   
    
end

   % unaffect_all{8}


end