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

% Assume you're in the doses-kincode directory: 
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
ix2 = find(id_==2); %unaffected
ix3 = find(id_==3); % ctrls 

%% Plot 1 -- only mean, by joint category
figure; hold all; 
ax = subplot(1,1,1); 

% light to dark 
%colors_p = {[253,204,138],[252,141,89],[227,74,51],[179,0,0]};
colors_p = {[228,26,28],[55,126,184],[77,175,74],[152,78,163]}; 

% light to dark 
%colors_c = {[.8, .8, .8], [.6, .6, .6], [.4, .4, .4], [.2, .2, .2]}; 
%colors_c = colors_p; 

for i=1:11
    if i<=5 % distal joints 
        %mark = 's';
        c = 1; % category 1 
    elseif i==6 % elbow 
        %mark = 'o'; 
        c = 3; % category 3 -- elbow 
    elseif i<=9 % palm 
        %mark = 'h'; 
        c = 2; % category 2 -- wrist 
    elseif i<=11 % shoulder
        %mark = 'd'; 
        c = 4; % category 4 -- wrist
    end
    ix_jt1 = find(jt_(ix1) == i); 
    ix_jt2 = find(jt_(ix2) == i); 
    ix_jt3 = find(jt_(ix3) == i); 
    
    % Affected (red) 
    n = length(ix_jt1); 
    scatter(rom_norm(ix1(ix_jt1), 2), mse_norm(ix1(ix_jt1), 2), 100, repmat(colors_p{c}/256, [n, 1]), 'filled');

    % Control (black) 
    n = length(ix_jt3); 
    scatter(rom_norm(ix3(ix_jt3), 2), mse_norm(ix3(ix_jt3), 2), 50, 'k', 'filled', 'MarkerFaceAlpha', .5);  

    % Unaffected (blue)-- remove this for now 
    %scatter(rom_norm(ix2(ix_jt2), 2), mse_norm(ix2(ix_jt2), 2), 100, 'b', 'filled', mark)  
end

% Confidence ellipse 
[in_out_ellipse] = plot_conf_ellipse(ax, rom_norm(ix3, 2), mse_norm(ix3, 2),'k',...
    rom_norm(ix1, 2), mse_norm(ix1, 2));

% Also plot confidence ellipses for abnormal distal/wrist/elbow/shoulder
ellipse_data = {}; 
for c = 1:4
    ellipse_data{c} = []; 
end

for i=1:11
    if i<=5 % distal joints 
        c = 1; % category 1 
    elseif i==6 % elbow 
        c = 3; % category 3 -- elbow 
    elseif i<=9 % palm 
        c = 2; % category 2 -- wrist 
    elseif i<=11 % shoulder
        c = 4; % category 4 -- wrist
    end
    
    % Get joints
    ix_jt1 = find(jt_(ix1) == i); 

    % of these, which are ABNORMAL (out of ellipse)
    ix_jt1_1 = find(in_out_ellipse(ix_jt1) == 1); 

    % save data for ellipse making later 
    ellipse_data{c} = [ellipse_data{c};...
        [rom_norm(ix1(ix_jt1(ix_jt1_1)), 2) mse_norm(ix1(ix_jt1(ix_jt1_1)), 2)]]; 
end

for c = 1:4
    [~] = plot_conf_ellipse(ax, ellipse_data{c}(:, 1),...
        ellipse_data{c}(:, 2), colors_p{c}/256,...
        [], [], 75);
end


%% Plot 2 -- mean and error bars
figure; hold all; 
ax = subplot(1,1,1); 

% Plot dots 
plot(rom_norm(ix1, 2), mse_norm(ix1, 2), 'r.', 'MarkerSize',15)
plot(rom_norm(ix2, 2), mse_norm(ix2, 2), 'b.', 'MarkerSize',15)

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
jt_labels = {'Distal', 'Wrist', 'Elbow', 'Shoulder'}; 

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

%% Plot 4 -- plot out bar plot with stars for sig / non-signifcant comparisons to control data 
figure; 

mets_patient = {rom_norm(ix1, 2), mse_norm(ix1, 2)}; 
mets_control = {rom_norm(ix3, 2), mse_norm(ix3, 2)}; 
mets_label = {'ROM norm', 'MSE norm'}; 

% Joint labels 
jts_p = jt_(ix1); 
jts_c = jt_(ix3); 

% Jt indices to count as distal/palm/elb/shouder
dist_ix = 1:5; % index/thumb
palm_ix =7:9;% palm abd / flex / prono
elb_ix = 6; % elbow 
shoul_ix = 10:11; % shoulder 

inds = {dist_ix, palm_ix, elb_ix, shoul_ix}; 

% any patient w/ mean outside ellipse, all patients
lev_ix = {ix_med};%, ix_all}; 
lev_color = {'r'};%,'b'}; 
lev_label = {'abn-pt'};%, 'all-pt'}; 
linecolor = [.5, .5, .5]; 
controlface = [.2, .2, .2]; 
alphas = {.8, .4}; 

for met = 1:2

    subplot(1, 2, met); hold all; 
    ax = gca; 

    % index into right metric 
    met_p = mets_patient{met}; 
    met_c = mets_control{met}; 

    % for each patient level: 
    for level = 1:1 

        mt_lev_p = met_p(lev_ix{level}); 
        jt_lev_p = jts_p(lev_ix{level}); 

        for cat = 1:4
            
            % which joints are acceptable 
            keep_p = []; 
            keep_c = []; 

            % Aggregate joints 
            for j = 1:length(inds{cat})
                tmp = find(jt_lev_p==inds{cat}(j)); 
                keep_p = [keep_p tmp]; 

                tmp2 = find(jts_c == inds{cat}(j)); 
                keep_c = [keep_c tmp2]; 
            end

            % Plot boxplot for controls  
            if level == 1
                draw_boxplot(ax, cat, met_c(keep_c), linecolor, controlface, 0.5)
            end
    
            % patients 
            draw_boxplot(ax, cat + (level*.3), mt_lev_p(keep_p),...
                linecolor, colors_p{cat}/256, alphas{level}); 

            % control vs. patient bar 
            if level == 1
                p = ranksum(met_c(keep_c), mt_lev_p(keep_p)); 
                disp(['Metric ' mets_label{met}]); 
                disp(['Jt cat : ' jt_labels{cat}]); 
                disp(['Level: ' num2str(level)])
                disp(['p = ' num2str(p) ', Np = ' num2str(length(keep_p)) ', Nc = ' num2str(length(keep_c))]); 
                disp(' ')
                disp(' ')

                if p < 0.05
                    plot(cat + .15, max([max(met_c(keep_c)) max(mt_lev_p(keep_p))]), 'k*')
                end
            end

        end
    end

    xlabel('Joint Categories')
    xticks([1:4] + .25)
    xticklabels(jt_labels)
    ylabel(mets_label{met})

end

