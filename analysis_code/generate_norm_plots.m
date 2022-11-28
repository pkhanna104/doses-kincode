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


% Assume you're in the doses-kincode directory: 
%nstd = 0.5; 
%load(['data/datatable' num2str(nstd) 'std_acc_samp_prec.mat'])
load('data/datatable_boot_acc_samp_prec.mat')

% light to dark 
%colors_p = {[253,204,138],[252,141,89],[227,74,51],[179,0,0]};
%colors_p = {[228,26,28],[55,126,184],[77,175,74],[152,78,163]}; 
%colors_p = {[237, 32, 36], [28, 117, 188] [118, 172, 66], [127, 47, 141]}; % R/B/G/purple
%colors_p = {[189,201,225], [103,169,207], [28,144,153], [1,108,89]}
%colors_p = {[179,205,227],[140,150,198]*.8, [136,86,250],[121,15,124]}; % purples
colors_p = {[123,50,148],[194,165,207],[166,219,160],[0,136,55]}; 


%% Get out mse_norm and rom_norm
mse_norm = []; % N x 3 
rom_norm = []; % N x 5
jt_ = []; % 1 x N 
id_ = []; % 1 x N: id: 1=aff, 2=unaff, 3=ctrl
subj_nm = {}; 

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
            subj_nm{end+1} = datatable{i}{1}{1}; 

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

% Which data to consider "abnormal" 
load('data/norm_abn_pat_indices.mat', 'save_indices'); 

% key options : 
% 'all_patients', -- all patients' affected jts regardless of whether in the 
% %                   'normal ellipse' or not are used to make
%                       joint-specific ellipses (not used) 
% 'all_mean_outside_ellipse_patients' -- if the mean of the patient / joint
%                       is outside the ellipse, then use this to make joint
%                       specific ellipses (used for fig 2) 
% 'all_error_outside_ellipse_patients' -- if the mean and ALL the error
%                        bars are outside the ellipse, then use this to 
%                        make joint specific ellipses (used for supp fig 3)
abnormal_key = 'all_patients'; 

% Plot points w/ colors
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
    scatter(rom_norm(ix1(ix_jt1), 2), mse_norm(ix1(ix_jt1), 2), 50, repmat(colors_p{c}/256, [n, 1]), 'filled', 'MarkerFaceAlpha', .5);

    % Control (black) 
    n = length(ix_jt3); 
    scatter(rom_norm(ix3(ix_jt3), 2), mse_norm(ix3(ix_jt3), 2), 50, 'k', 'filled');  

    % Unaffected (blue)-- remove this for now 
    %scatter(rom_norm(ix2(ix_jt2), 2), mse_norm(ix2(ix_jt2), 2), 100, 'b', 'filled', mark)  
end

% Confidence ellipse 
[~] = plot_conf_ellipse(ax, rom_norm(ix3, 2), mse_norm(ix3, 2),'k',...
    rom_norm(ix1, 2), mse_norm(ix1, 2));

% Also plot confidence ellipses for abnormal distal/wrist/elbow/shoulder
ellipse_data = {}; 
for c = 1:4
    ellipse_data{c} = []; 
end

% Which jts are abnormal; 
abn_jts = save_indices.(abnormal_key); 

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
    ix_jt1 = find(jt_(abn_jts) == i); 

    % save data for ellipse making later 
    ellipse_data{c} = [ellipse_data{c};...
        [rom_norm(abn_jts(ix_jt1), 2) mse_norm(abn_jts(ix_jt1), 2)]]; 
end

for c = 1:4
    [~] = plot_conf_ellipse(ax, ellipse_data{c}(:, 1),...
        ellipse_data{c}(:, 2), colors_p{c}/256,...
        [], [], 75);
end

xlabel('Norm ROM')
ylabel('Norm T2TV')
xlim([-1, 4])
ylim([-1, 4])
set(gcf, 'Position', [0, 0, 400, 400])
saveas(gcf, ['figs/normROMvMSE_byJtCat.svg'])

%% Plot 2 -- affected/unaffected plus ellipse 
figure; hold all; 
ax = subplot(1,1,1); 
blue = [100, 148, 165]/256; 


% Plot dots 
plot(rom_norm(ix1, 2), mse_norm(ix1, 2), 'r.', 'MarkerSize',15)
plot(rom_norm(ix2, 2), mse_norm(ix2, 2), '.', 'MarkerSize',15, 'Color', blue)

% Plot control subjects 
plot(rom_norm(ix3, 2), mse_norm(ix3, 2), 'k.', 'MarkerSize',15)  

% Confidence ellipse  -- 1 = outside ellipse 
[in_ellipse_aff] = plot_conf_ellipse(ax, rom_norm(ix3, 2), mse_norm(ix3, 2),'k',...
    rom_norm(ix1, 2), mse_norm(ix1, 2));

[in_ellipse_unaff] = plot_conf_ellipse(ax, rom_norm(ix3, 2), mse_norm(ix3, 2),'k',...
    rom_norm(ix2, 2), mse_norm(ix2, 2));

[in_ellipse_intact] = plot_conf_ellipse(ax, rom_norm(ix3, 2), mse_norm(ix3, 2),'k',...
    rom_norm(ix3, 2), mse_norm(ix3, 2));
% [~] = plot_conf_ellipse(ax, rom_norm(ix1, 2), mse_norm(ix1, 2),'r',...
%     rom_norm(ix1, 2), mse_norm(ix1, 2));
% 
% [~] = plot_conf_ellipse(ax, rom_norm(ix2, 2), mse_norm(ix2, 2),blue,...
%     rom_norm(ix1, 2), mse_norm(ix1, 2));

% Labels 
xlabel('Norm ROM'); xlim([-1, 4])
ylabel('Norm T2TV'); ylim([-1, 4])
set(gcf, 'Position', [0, 0, 300, 300])
saveas(gcf, ['figs/normROMvMSE_wAffUnaffCtrl.svg'])

%% Plot 2.5 -- normal / patients for individual joints
close all; 
jts_ids = [5, 6, 10]; % from generate_fig2
jt_nms = {'Index DIP', 'Elbow Flex/Ext', 'Shoulder Abd/Add'}; 

%jt_cols = {[237, 32, 36], [118, 172, 66], [127, 47, 141]}; % R/G/purple
%jt_cols = {[123,50,148],[166,219,160],[0,136,55]}; 
jt_cols = {colors_p{1}, colors_p{3}, colors_p{4}}; 
subjects = {'B8M', 'B12J', 'S13J'}; 

for i_j = 1:length(jts_ids)
    figure(i_j); hold all; 

    % Plot the 'normals' ellipse 
    ax = gca; 
    [~] = plot_conf_ellipse(ax, rom_norm(ix3, 2), mse_norm(ix3, 2),'k',...
        [], []);
    
    % Now plot the individual normal points for this joint; 
    jix3 = find(jt_(ix3) == jts_ids(i_j));
    plot(rom_norm(ix3(jix3), 2), mse_norm(ix3(jix3), 2), 'k.','MarkerSize', 20)

    % Now plot the affected patient jts for this joint 
    jix1 = find(jt_(ix1) == jts_ids(i_j));

    for subj = 1:length(subjects)
        subjid = subjects{subj}; 

        for j = 1:length(jix1)
            ogix = ix1(jix1(j)); 
            if contains(subj_nm{ogix}, subjid)
                plot(rom_norm(ogix, 2), mse_norm(ogix, 2), '.', 'Color', jt_cols{i_j}/256, 'MarkerSize', 20)
                text(rom_norm(ogix, 2), mse_norm(ogix, 2), subjid, 'Color', jt_cols{i_j}/256)
            end
        end
    end
    xlim([-1, 1.5])
    ylim([-1, 3.5])

    % save 
    set(gcf, 'Position', [0, 0, 300, 300])
    title(jt_nms{i_j})
    xlabel('Norm. ROM')
    ylabel('Norm. T2TV')
    saveas(figure(i_j), ['figs/jt_id' num2str(jts_ids(i_j)) '_normROMvMSE.svg'])

end

%% Plot 3 -- Median values for normal, borderline, abnormal points
% inside or outside the ellipse 
close all; 
ax = gca; 
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

% Save these indices
save_indices = struct(); 
save_indices.('all_patients') = ix1; 
save_indices.('all_mean_outside_ellipse_patients') = ix1(ix_med); 
save_indices.('all_error_outside_ellipse_patients') = ix1(ix_abn); 
%save('data/norm_abn_pat_indices.mat', 'save_indices')

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

%% Plot 3.5 -- plot normROM vs. normMSE w/ ERROR bars 
figure; hold all; 
ax = subplot(1,1,1); 

inds_red = save_indices.('all_error_outside_ellipse_patients') ; 

% Plot errors 
for j = ix1
    if ~isempty(find(inds_red == j))
        col='r'; 
    else
        col = [.5, .5, .5]; 
    end

    plot(rom_norm(j, 2), mse_norm(j, 2), '.', 'MarkerSize', 15, 'Color', col)
    plot([rom_norm(j, 1), rom_norm(j, 3)], [mse_norm(j, 2), mse_norm(j, 2)], '-', 'Color', col)
    plot([rom_norm(j, 2), rom_norm(j, 2)], [mse_norm(j, 1), mse_norm(j, 3)], '-', 'Color', col)
end 

% Plot control subjects 
plot(rom_norm(ix3, 2), mse_norm(ix3, 2), 'k.', 'MarkerSize',15)  

% Confidence ellipse 
[~] = plot_conf_ellipse(ax, rom_norm(ix3, 2), mse_norm(ix3, 2),'k',...
    rom_norm(ix1, 2), mse_norm(ix1, 2));

% Labels 
xlabel('Norm ROM'); xlim([-1, 4])
ylabel('Norm T2TV'); ylim([-1, 4])
set(gcf, 'Position', [0, 0, 400, 400])
saveas(gcf, ['figs/normROMvMSE_wAffUnaffCtrl_werror.svg'])

%% Plot 3.75 -- distributions of ROM and MSE ERROR bars 
rom_lt_gt = []; % 2 x N of LT / GT 
mse_lt_gt = []; % 2 x N of LT / GT 

% Plot errors 
for j = ix1
    
    rom_ = rom_norm(j, [1, 3]) - rom_norm(j, 2); 
    rom_lt_gt = [rom_lt_gt rom_']; 

    mse_ = mse_norm(j, [1, 3]) - mse_norm(j, 2); 
    mse_lt_gt = [mse_lt_gt mse_']; 
    
end

mts = {rom_lt_gt, mse_lt_gt}; 
mts_lab = {'norm ROM', 'norm T2TV'}; 
bds = {'Lower', 'Upper'}; 
for m=1:2
    met = mts{m}; 
    figure; hold all; 
    title(mts_lab{m}); 

    for i = 1:2
        subplot(1, 2, i); hold all; 
        [prob,eds] = histcounts(met(i, :), 15, 'Normalization', 'probability'); 
        eds_plt = eds(1:end-1) + 0.5*(eds(2)-eds(1)); 
        plot(eds_plt, prob, 'k-', 'LineWidth',1); 
        mn = mean(met(i, :)); 
        plot([mn, mn], [0, .4], 'b-', 'LineStyle','--')
        ylim([0, .4])
        ylabel('Fraction of Jts')
        xlabel([bds{i} ' bound of 95% CI for ' mts_lab{m}])
    end
    
    set(gcf, 'Position', [0, 0, 800, 300])
    saveas(gcf, ['figs/CI_dist_' mts_lab{m} '.svg'])
end

%% Plot 4 -- plot out violin plot distr of normROM / normMSE vs control
figure; 

% doing this to avoid needing to index by ix1 (bc already done in
% "norm_abn_pat_indices.mat" 
mets_patient = {rom_norm(:, 2), mse_norm(:, 2)}; 

% still want to index by ix3; 
mets_control = {rom_norm(ix3, 2), mse_norm(ix3, 2)}; 
mets_label = {'Norm ROM', 'Norm T2TV'}; 

% Joint labels 
jts_p = jt_; 
jts_c = jt_(ix3); 
jt_labels = {'Distal', 'Wrist', 'Elbow', 'Shoulder'}; 

% Jt indices to count as distal/palm/elb/shouder
dist_ix = 1:5; % index/thumb
palm_ix =7:9;% palm abd / flex / prono
elb_ix = 6; % elbow 
shoul_ix = 10:11; % shoulder 

inds = {dist_ix, palm_ix, elb_ix, shoul_ix}; 

% any patient w/ mean outside ellipse, all patients
%lev_ix = {ix_med};%, ix_all}; 

% Which data to consider "abnormal" 
load('data/norm_abn_pat_indices.mat', 'save_indices'); 

% key options : 
% 'all_patients', -- all patients' affected jts regardless of whether in the 
% %                   'normal ellipse' or not are used to make
%                       joint-specific ellipses (not used) 
% 'all_mean_outside_ellipse_patients' -- if the mean of the patient / joint
%                       is outside the ellipse, then use this to make joint
%                       specific ellipses (used for fig 2) 
% 'all_error_outside_ellipse_patients' -- if the mean and ALL the error
%                        bars are outside the ellipse, then use this to 
%                        make joint specific ellipses (used for supp fig 3)
abnormal_key = 'all_patients'; 
lev_ix = {save_indices.(abnormal_key)}; 


lev_color = {'r'};%,'b'}; 
lev_label = {'abn-pt'};%, 'all-pt'}; 
linecolor = [.5, .5, .5]; 
controlface = [.2, .2, .2]; 
alphas = {.8, .4}; 

dprimes = zeros(2, 4); 

for met = 1:2

    subplot(2, 1, met); hold all; 
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
                %draw_boxplot(ax, cat, met_c(keep_c), linecolor, controlface, 0.5)
                draw_violin(ax, cat*2, met_c(keep_c), linecolor, controlface, 0.5)
                control_dist = met_c(keep_c); 
            end
    
            % patients 
            %draw_boxplot(ax, cat + (level*.3), mt_lev_p(keep_p),...
            %    linecolor, colors_p{cat}/256, alphas{level}); 
            draw_violin(ax, cat*2 + (level*.6), mt_lev_p(keep_p),...
                linecolor, colors_p{cat}/256, alphas{level})
            stroke_dist = mt_lev_p(keep_p); 

            % Get d-prime distance (from Veuthey et. al. 2020)
            dprime = (mean(stroke_dist) - mean(control_dist)) / (0.5*(sqrt(std(control_dist) + std(stroke_dist)))); 
            assert(dprimes(met, cat) == 0)
            dprimes(met, cat) = dprime; 
           

        end
    end

    xlabel('Joint Categories')
    xticks([1:2:8] + 1.2)
    xticklabels(jt_labels)
    ylabel(mets_label{met})
    xlim([.5, 10])

end

set(gcf, 'Position', [0, 0, 300, 400])
saveas(gcf, ['figs/normROM_normMSE_violins.svg'])

for met = 1:2
    for cat = 1:4
        fprintf('Metric %s, Jt category %s, Dprime=%.2f\n', mets_label{met}, jt_labels{cat}, dprimes(met, cat))
    end
end
