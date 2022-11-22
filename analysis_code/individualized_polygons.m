% Script to plot figures with ROMnorm vs. MSEnorm
clear; close all

% Load data table (made in "generate_rom_mse_datatable.m")
%%% Save out params 1       2          3    4     5     6 
% Column 1 -- subject ID
% Column 2 -- control subject? 1=yes, 0=no
% Column 3 -- joint number (#1-11)
% Column 4 -- affected hand? 1=yes, 0=no (for controls affected=L, unaff=R)
% Column 5 -- [mse_min, mse, mse_max]; 
% Column 6 -- [rom_min, rom, rom_max];


% Assume you're in the doses-kincode directory: 
%nstd = 0.5; 
%load(['data/datatable' num2str(nstd) 'std_acc_samp_prec.mat'])
load('data/datatable_boot_acc_samp_prec.mat')

%% Get out mse_norm and rom_norm
mse_norm = []; % N x 3 
rom_norm = []; % N x 5
jt_ = []; % 1 x N 
id_ = []; % 1 x N: id: 1=aff, 2=unaff, 3=ctrl
subj_nm = {}; 

% Control subjects normalized data for fitting exponential 
norm_x = []; norm_y = []; 

for jt = 1:11
    
    % Get control values to do the normalizations: 
    normal_rom = []; 
    normal_mse = []; 

    for i = 1:length(datatable)
            % correct joint             % normals
        if datatable{i}{3} == jt && datatable{i}{2} == 1
            mse = datatable{i}{5};
            rm = datatable{i}{6}; 
            normal_rom = [normal_rom rm(2)]; 
            normal_mse = [normal_mse mse(2)]; 
            
        end
    end

    % Calculate normalizers for this joint 
    medROM = median(normal_rom); 
    medMSE = median(normal_mse);

    % Now collect all data we care about and normalize it 
    for i = 1:length(datatable)
    
        % Correct joint 
        if datatable{i}{3} == jt 

            if datatable{i}{2} == 1 
                id_num = 3; % CONTROL -- not distinguishing b/w L/R; 
                norm_x = [norm_x (datatable{i}{5}(2) - medMSE)/medMSE]; 
                norm_y = [norm_y (datatable{i}{6}(2) - medROM)/medROM]; 
                
            elseif datatable{i}{2} == 0 && datatable{i}{4} == 1 % affected
                id_num = 1; % AFF
               
            elseif datatable{i}{2} == 0 && datatable{i}{4} == 0 % unaffected
                id_num = 2; %UNAFF
            else
                disp('Mistake! You should NOT end up here -- you should be in one of the above if/else statements')
                keyboard
            end
            
            % Save [min, val, max] for mse/rom: 
            mse = datatable{i}{5};
            rm = datatable{i}{6}; 
            mse_norm = [mse_norm; (mse - medMSE)/medMSE ];
            rom_norm = [rom_norm; (rm  - medROM)/medROM ]; 
            jt_ = [jt_ jt]; 
            id_ = [id_ id_num]; 
            subj_nm{end+1} = datatable{i}{1}{1}; 

        end
    end
end

%% Get out conf ellipse
% Plot datapoints 
ix1 = find(id_==1); % affected
ix2 = find(id_==2); %unaffected
ix3 = find(id_==3); % ctrls 

figure(1); 
ax = gca; 
in_ellipse = plot_conf_ellipse(ax, rom_norm(ix3, 2), mse_norm(ix3, 2),'k',...
    rom_norm(:, 2), mse_norm(:, 2));
close all; 

%% Fit curve to use for ROM b/w [-1, 1]
norm_x = [norm_x', ones(length(norm_x), 1)]; 
b_b0 = norm_x\norm_y'; 

%% Subject specific 
subjects = unique(subj_nm); 
jt_id_order = [1:5, 7:9, 6, 10:11];  % distal // wrist // elbow // shoulder 
colormap2 = copper(256); % black --> red (0 --> 2)
colormap_ids = linspace(0, 2, 256); 

th = 0:pi/50:2*pi;
xunit = cos(th);
yunit = sin(th);

for i_s = 1:length(subjects)
    
    if ~contains(subjects{i_s}, '_ctrl')
        figure(i_s); hold all; 
        colormap(colormap2)
        % rom // mse for rom // in_ellipse (1=out of ellipse)
        polygon = zeros(3, 11); 
    
        for i = 1:length(subj_nm)

            if and(contains(subj_nm{i}, subjects{i_s}), id_(i) == 1)

                % Save out ROM
                polygon(1, jt_(i)) = rom_norm(i, 2); 

                % Recentered ROM 
                if rom_norm(i) > 1
                    mse_norm_max = 1; 
                    polygon(2, jt_(i)) = mse_norm(i, 2) - (b_b0(1)*mse_norm_max + b_b0(2));  
                else
                    polygon(2, jt_(i)) = mse_norm(i, 2) - (b_b0(1)*mse_norm(i,2)+ b_b0(2)); 
                end

                polygon(3, jt_(i)) = in_ellipse(i); % 1 = out // 0 = in 

                % Threshold for ROM 
                polygon(1, jt_(i)) = min([3, polygon(1, jt_(i))]); % max is 3; 
                polygon(1, jt_(i)) = max([-1, polygon(1, jt_(i))]); % min is -1; 
                
                % Threshold for MSE 
                polygon(2, jt_(i)) = min([3, polygon(2, jt_(i))]); % max is 3; 
                polygon(2, jt_(i)) = max([-1, polygon(2, jt_(i))]); % min is -1; 
                
            end
        end

        % Make sure this makes sense 
        for i_j = 1 :length(jt_id_order)
            ang = 2*pi/11*i_j; 
            rad = polygon(1, jt_id_order(i_j)) + 1; 
            
            % Which is this closest to? 
            if polygon(3, jt_id_order(i_j))
                [~, id] = min(abs(colormap_ids - polygon(2, jt_id_order(i_j)))); 
                color = colormap2(id, :); 
            else
                color = [.1, .1, .1]; 
            end
            plot([0, rad*cos(ang)], [0, rad*sin(ang)], '.', 'Color',...
                color, 'MarkerSize', 30)
            plot([0, rad*cos(ang)], [0, rad*sin(ang)], '-', 'Color',...
                color, 'LineWidth', 3)
        end
        title(subjects{i_s})

        % Plot ROM == 0 (rad == 1) 
        plot(xunit*1, yunit*1, 'k-') % ROM = 0
        plot(xunit*2, yunit*2,'k--') % ROM = 1

        % axis 
        axis('equal')

        xlim([-4, 4])
        ylim([-4, 4])
        colorbar()
        
        set(figure(i_s), 'Position', [0, 0, 300, 300])
        saveas(gcf, ['figs/indplot' subjects{i_s} '.svg'])
    end
end

