clear; clc;close all;

Filename = 'W16H_small_pinch_data.mat';
load([Filename]);

[input1 input sign] = names_sign(Filename); 
%input reference to (input)_jt_angle_un( or aff).mat -> S13J_small stays same name
%input1 reference to excel files used in function "data_height_plot"-> S13J_small turns into S13J
%sign is 1 for patients, -1 for controls -> controls shoulder sensor placed
%facing towards proximal

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%  unaffected hand %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Filename = string(strcat('C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\Four healthy subject data\',input,'_jt_angle_un.mat'));
load ([Filename]);
[u_height,unaffect_all,data_palm,u_time] = jt_angle_split('un',unaffected,angle_struct,input1);

%below function plots figs 1 and 2 and produces manually determined stamps
%for start to end of pinch task...also captures data from excel needed for
%calculations (see function below)
[exc_data] = data_height_plot(data_palm,u_time,sign,input1,'un','off');

[output] = interp_raw_n_zscore(unaffect_all,data_palm,input1,sign,exc_data,'un','off');  %does inerpolation and plotting
u_rom_2_pinch = output.u_rom_2_pinch; %needed for below calculations

figure(12)
for m = 1:12
    for n = 1:10
        subplot(6,2,m)
        plot(cell2mat(output.u_unz(n,m)),'b');hold on;
    end
end

[mse_rom] = calc_mse_rom(output,input1,exc_data,'un'); %calculates below variables
%below variables needed for below calcs
u_mse = mse_rom.u_mse;
un_raw = mse_rom.un_raw;
median_trial_data_u = mse_rom.median_trial_data_u;
u_rom = mse_rom.u_rom;
u_median_rom = mse_rom.u_median_rom;
u_median_rom_2_pinch = mse_rom.u_median_rom_2_pinch;

%below function calculates green boxes in paper figure 2 -> normal mean and std for
%unaffected normalized t2tc and rom
[u_rom_norm,u_rom_norm_mean,u_rom_norm_std,u_mse_norm_mean, u_mse_norm_std] = normal_mean_std(mse_rom); %calculates unaffected normalized data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%  affected hand %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Filename = string(strcat('C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\Four healthy subject data\',input,'_jt_angle_aff.mat'));
load ([Filename]);
[u_height,unaffect_all,data_palm,u_time] = jt_angle_split('aff',affected,angle_struct,input1);
aff_raw = unaffect_all;

%below function plots figs 4 and 5 and produces manually determined stamps
%for start to end of pinch task...also captures data from excel needed for
%calculations (see function below)
[exc_data] = data_height_plot(data_palm,u_time,sign,input1,'aff','off');

%below function same as above but for affected.  Also plots fig 6
[output]  = interp_raw_n_zscore(unaffect_all,data_palm,input1,sign,exc_data,'aff','off');
a_rom_2_pinch = output.a_rom_2_pinch; %needed for below calculations

%tb_mcp' tb_dip' ib_mcp' ib_pip' ib_dip' eb' palm shoulder_ang
l = ["Thumb MCP","Thumb DIP","Index MCP","Index PIP",...
    "Index DIP","Elbow Flex","Palm Abd","Palm Flex","Palm Roll","Should Horz Flex"...
    "Shoulder Vert Flex","Shoulder Roll"];

figure(12)
for m = 1:12
    for n = 1:10
        subplot(6,2,m)
        plot(cell2mat(output.a_unz(n,m)),'r');hold on;
        title((l(m)))
    end
end

[mse_rom] = calc_mse_rom(output,input1,exc_data,'aff');
%below variables needed for below calcs
a_mse = mse_rom.a_mse;
aff_raw = mse_rom.aff_raw;
median_trial_data_a = mse_rom.median_trial_data_a;
a_rom = mse_rom.a_rom;
a_median_rom = mse_rom.a_median_rom;
a_median_rom_2_pinch = mse_rom.a_median_rom_2_pinch;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%below variable in for loops are affected rom normalized data and mse sums
%for unaffected and affected
for m = 1:12
   a_rom_norm(m) = (a_median_rom(m) - u_median_rom(m)) ./ u_median_rom(m);
   a_rom_norm_2_pinch(m) = (a_median_rom_2_pinch(m) - u_median_rom_2_pinch(m)) ./ u_median_rom_2_pinch(m);
   u_mse_sum(m) = median(cell2mat(u_mse(:,m))); %start to pinch end
   a_mse_sum(m) = median(cell2mat(a_mse(:,m))); %start to pinch end
end

Filename = string(strcat('C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\Four healthy subject data\', input,'_res.mat'));
save(Filename,'median_trial_data_u','median_trial_data_a','un_raw','aff_raw', ...
    'u_rom_2_pinch','a_rom_2_pinch','u_mse_sum','a_mse_sum','u_rom_norm','a_rom_norm',...
    'u_rom_norm_mean','u_rom_norm_std','u_mse_norm_mean','u_mse_norm_std');



