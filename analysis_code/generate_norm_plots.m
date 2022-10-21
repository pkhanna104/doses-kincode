% Script to plot figures with ROMnorm vs. MSEnorm
clear;

% Load data table (made in "generate_rom_mse_datatable.m")
%%% Save out params 1       2          3    4     5     6 
% Column 1 -- subject ID
% Column 2 -- control subject? 1=yes, 0=no
% Column 3 -- joint number (#1-11)
% Column 4 -- affected hand? 1=yes, 0=no (for controls affected=L, unaff=R)
% Column 5 -- [mse_min, mse, mse_max]; 
% Column 6 -- [rom_min, rom, rom_max];
nstd = 0.5; 
load(['data/datatable' num2str(nstd) 'std_acc_samp_prec.mat'])

%% Get out mse_norm and rom_norm
mse_norm = []; % N x 3 
rom_norm = []; % N x 5
jt_ = []; % 1 x N 
id_ = []; % 1 x N: id: 1=aff, 2=unaff, 3=ctrl

for jt = 1 : 11
    
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

        end
    end
end

%% Plot rom_norm vs. mse_norm

% Plot datapoints 
ix1 = find(id_==1); % affected
ix3 = find(id_==3); % ctrls 

%% Plot 1 -- only mean, by joint category
figure; hold all; 
ax = subplot(1,1,1); 

for i=1:11
    if i<=5
        mark = 's';
    elseif i==6
        mark = 'o'; 
    elseif i<=9
        mark = 'h'; 
    elseif i<=11
        mark = 'd'; 
    end
    ix_jt1 = find(jt_(ix1) == i); 
    ix_jt3 = find(jt_(ix3) == i); 
    
    plot(rom_norm(ix1(ix_jt1), 2), mse_norm(ix1(ix_jt1), 2), mark, 'MarkerSize',10, 'Color', 'r')
    plot(rom_norm(ix3(ix_jt3), 2), mse_norm(ix3(ix_jt3), 2), mark, 'MarkerSize',10, 'Color', 'k')  
end
[~] = plot_conf_ellipse(ax, rom_norm(ix3, 2), mse_norm(ix3, 2),'k',...
    rom_norm(ix1, 2), mse_norm(ix1, 2));

%% Plot 2 -- mean and error bars
figure; hold all; 
ax = subplot(1,1,1); 

% Plot dots 
plot(rom_norm(ix1, 2), mse_norm(ix1, 2), 'r.', 'MarkerSize',15)

% Plot errorbars
for i = 1:length(ix1)
    plot([rom_norm(ix1(i), 1), rom_norm(ix1(i), 3)],...
         [mse_norm(ix1(i), 2), mse_norm(ix1(i), 2)], 'r-', 'MarkerSize',15)
    plot([rom_norm(ix1(i), 2), rom_norm(ix1(i), 2)],...
         [mse_norm(ix1(i), 1), mse_norm(ix1(i), 3)], 'r-', 'MarkerSize',15)
end

% Plot control subjects 
plot(rom_norm(ix3, 2), mse_norm(ix3, 2), 'k.', 'MarkerSize',15)  

% Labels 
xlabel('Norm ROM')
ylabel('Norm MSE')

%% Plot 3 -- Median values for normal, borderline, abnormal points
% inside or outside the ellipse 
test_result = plot_conf_ellipse(ax, rom_norm(ix3, 2), mse_norm(ix3, 2),'k',...
    rom_norm(ix1, 2), mse_norm(ix1, 2)); 

% Make sure output is the right length 
assert(length(test_result) == length(ix1))

% Dummy figure 
figure; ax2=subplot(1,1,1); 

% Test whether all 4 points of the 2D error bars (N/E/S/W) are outside the
% error ellipse as well
% North
tr1 = plot_conf_ellipse(ax2, rom_norm(ix3, 2), mse_norm(ix3, 2),'k',...
    rom_norm(ix1, 2), mse_norm(ix1, 3)); 
% South
tr2 = plot_conf_ellipse(ax2, rom_norm(ix3, 2), mse_norm(ix3, 2),'k',...
    rom_norm(ix1, 2), mse_norm(ix1, 1));
% East
tr3 = plot_conf_ellipse(ax2, rom_norm(ix3, 2), mse_norm(ix3, 2),'k',...
    rom_norm(ix1, 3), mse_norm(ix1, 2)); 
% West
tr4 = plot_conf_ellipse(ax2, rom_norm(ix3, 2), mse_norm(ix3, 2),'k',...
    rom_norm(ix1, 1), mse_norm(ix1, 2)); 

% Adds all test results %
sum_test_res = sum([test_result', tr1', tr2', tr3', tr4'], 2); 
assert(length(sum_test_res) == length(ix1))

% Find points that are ALL outside the ellipse; 
ix_abn = find(sum_test_res == 5);

% Points were mean is outside error ellipse (but all 4 pts of error may not
% be) 
ix_med = find(test_result == 1); 

% All points 
ix_all = 1:length(test_result); 

% Plot median plots for ROM/MSE for distal

% Jt indices to count as distal/palm/elb/shouder
dist_ix = 1:5; 
palm_ix = 7:9;
elb_ix = 6; 
shoul_ix = 10:11; 

inds = {dist_ix, palm_ix, elb_ix, shoul_ix}; 

% Same markers as Tom's Fig2 plot for distal/palm/elb/shouder
marker = {'s', 'h', 'o', 'd'}; 

% 3 different median lines to compute -- all / abnormal mean / abnormal
% mean+abnormal error bars
lev_ix = {ix_abn, ix_med, ix_all}; 
lev_color = {'r', 'm', 'k'}; 
lev_label = {'abn-pt', 'abn+border-pt', 'all-pt'}; 

% Different metrics to plot (rom/mse)
mets = {rom_norm(ix1, 2), mse_norm(ix1, 2)}; 
met_label = {'rom', 'mse'}; 

% Joint labels 
jts = jt_(ix1); 

% Make sure lengths of jts and mets match up since "jts" will be used to
% index into mets; 
assert(length(jts) == length(mets{1}))
assert(length(jts) == length(mets{2}))


figure; 
for met = 1:2

    % First subplot for first metric 
    subplot(1, 2, met); hold all; 
    mt = mets{met}; 

    % For each of the different lines 
    for level=1:3

        % Use level indices derived from above for which datapoints to
        % include
        mt_lev = mt(lev_ix{level}); 
        jt_lev = jts(lev_ix{level}); 

        % Category of joints: 
        for cat=1:4

            % Find all indices that fall into this joint category
            jts_cat = []; 
            for j = 1:length(inds{cat})
                tmp = find(jt_lev==inds{cat}(j)); 
                jts_cat = [jts_cat tmp]; 
            end

            % Plot median of this joint
            plot(median(mt_lev(jts_cat)), level, marker{cat},...
                'Color', lev_color{level},...
                'MarkerFaceColor', lev_color{level},...
                'MarkerSize', 10);
        end

        % Plot horizontal line 
        plot([-1, 3], [level,level], '-',...
            'Color', lev_color{level}, 'LineWidth', 1.5);

        % Add text to describe this line's data 
        text(-1, level-.25, lev_label{level}, 'Color', lev_color{level});
    end

    % Add metric title
    title('Medians by Jt Category'); 
    xlabel(['Norm ' met_label{met}])
    ylim([0, 4]); 
end
