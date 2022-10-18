% Load R15J 
if ismac
    path_to_data = '/Users/preeyakhanna/Dropbox/Ganguly_Lab/Projects/HP_Sensorized_Object/doses-kincode/data/'; 
    slash = '/'; 
else
    path_to_data = 'C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\doses-kincode-main\data\'; 
    slash = '\'; 
end

% Raw data
load([path_to_data 'task_data' slash 'patient' slash 'R15J_small_pinch_data.mat'], 'affected');

% Jt angle data 
load([path_to_data 'tom_data' slash 'jt_angle_data' slash 'R15J_small_jt_angle_aff.mat'])

% sensors involved in index dip: 
index_dip = 7; 
index_pip = 6; 

angs = {'azi', 'elev', 'roll'}; 
figure; 
for i = 1:3
    subplot(3, 3, (i*3) - 2); hold all; 
    %subplot(3, 3, i); hold all; 
    plot(affected.angle_data(:, i, index_pip), 'b-'); % pip 
    plot(affected.angle_data(:, i, index_dip), 'g-'); % dip 
    title(['raw ' angs{i}]); 
end

% Plot angle estimate
subplot(3, 3, 2); hold all; 
plot(angle_struct.Index_DIP, 'm-'); 
title(['index dip']); 

%% Plot unrolled raw angles

% Load baseline data; 

baseline = load([path_to_data 'task_data' slash 'baselines' slash 'R15J_small_ctrl_baseline-testaffected.mat']);
baseline_index_dip = baseline.data.angles.(['sensor' num2str(index_dip)])(end, :);
baseline_index_pip = baseline.data.angles.(['sensor' num2str(index_pip)])(end, :);

% % calculate unrolled raw angles: 
% unrolled_d = []; 
% unrolled_p = []; 
% 
% for i = 1:3
%     if i <= 2
%         unrolled_dip = unroll_sensor(affected.angle_data(:, i, index_dip));
%         unrolled_pip = unroll_sensor(affected.angle_data(:, i, index_pip));
%     else
%         unrolled_dip = affected.angle_data(:, i, index_dip);
%         unrolled_pip = affected.angle_data(:, i, index_pip);
%     end
% 
%     unrolled_d = [unrolled_d unrolled_dip]; 
%     unrolled_p = [unrolled_p unrolled_pip]; 
% 
%     subplot(3, 3, (i*3)  ); hold all; 
%     plot(unrolled_pip, 'b-'); % pip 
%     plot(unrolled_dip, 'g-'); % dip 
%     title(['unroll ' angs{i}]); 
% end


prt = 0; 
hand_nm = 'Left';
for n = 1:length(affected.angle_data(:, 1, index_dip))
%     bend_flex_dip(n) = bend_angle_plane(baseline_index_dip, baseline_index_pip, ...
%                                     unrolled_d(n, :),unrolled_p(n, :), 'flex', prt,...,
%                                     'index dip', hand_nm);
    bend_flex_dip(n) = bend_angle_plane(baseline_index_dip, baseline_index_pip, ...
                                    affected.angle_data(n, :, index_dip),...
                                    affected.angle_data(n, :, index_pip),...
                                    'flex', prt,...,
                                    'index dip', hand_nm);
end
% subplot(3, 3, 2+6); hold all; 
% plot(bend_flex_dip, 'm-'); 
% title(['unrolled index dip']); 

subplot(3, 3, 2); hold all; 
plot(bend_flex_dip, 'k-'); 

 



