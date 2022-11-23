function [output] = interp_raw_n_zscore(path_to_data,slash,u_time,unaffect_all,data_palm,height,input1,sign,hand,on_off)

%string to pinch indices obtained using data_height_plot.m and ginput.m
Filename =  convertStringsToChars(string(strcat(input1,'_st_2_pi_',hand,'.mat')));
load([path_to_data 'data' slash 'tom_data' slash 'start_2_pinch_data' slash Filename]);

% Load accuracy data for use in ROM calc
% Jt_names correspond to joints as they are ordered in Tom's
% "jt_angle_split" fcn
% [palm] = [palm_abd' palm_flex' palm_prono'];
% [shoulder_ang] = [shoulder_hor_flex' shoulder_ver_flex' shoulder_roll'];
% [tb_mcp' tb_dip' ib_mcp' ib_pip' ib_dip' eb' palm shoulder_ang]; % joint angles per trial
jt_names = {'Thumb_MCP', 'Thumb_DIP', 'Index_MCP', 'Index_PIP', 'Index_DIP',...
        'Elbow_Flex', 'Palm_Abd', 'Palm_Flex', 'Palm_Prono', 'Shoulder_HorzFlex',...
        'Shoulder_VertFlex'}; 

%acc = load([path_to_data 'data' slash 'rom_error_preeya.mat']);

% Load ROM bootstrap 
boots = load([path_to_data 'data' slash 'bootstrapped_roms.mat']); 

if any(convertCharsToStrings(hand) == "un")
    fn3 = 3;
elseif any(convertCharsToStrings(hand) == "aff")
    fn3 = 6;
end

for n = 1:10
    %start to end of pinch trial length
    %st_2_pi is rounded because ginput selects decimal values 
    trial_lengths(n) = round(st_2_pi{n}(2,1))-round(st_2_pi{n}(1,1)); 
end

% Edited PK on 10/20/22 -- changed all trial lengths to 100 after doing
% simulations to show effects of "N" on MSE/ROM
mtl = 100; %median(trial_lengths); %median trial length of all ten trials

for n = 1:10 % Trials
    dp = sign.*data_palm{n}(:,3);
    indices = round(st_2_pi{n}(1,1)):round(st_2_pi{n}(2,1));
    ind{n} = indices;
    dp_new = dp(indices);  %full trial length
    
    t0 = 1:length(dp_new); % original time axis
    t1 = linspace(1, length(dp_new), mtl); % new time axis that still varies between 1 and length(u_new) but has more datapoints;
    
    dp = interp1(t0,dp_new,t1); %data to be used for zscoring
    obj_height = interp1(t0, height{n}(indices), t1);
    assert(isempty(find(isnan(dp)))); % added assertion to make sure no nans;
    assert(isempty(find(isnan(obj_height))));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    %below figure 3 showing palm region for analysis in red -> palm height vs.
    %location in array -> start of task to end of pinch task -> trial now shifted so time 0 starts
    %at location 1 in array
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if any(convertCharsToStrings(on_off) == "on")
        figure(fn3)
        subplot(5,2,n)
        plot(dp,'b');hold on; % new interpolated DP
        %plot(dp(1:excel_u(n,2)),'r','LineWidth',3)
        
        yyaxis right
        plot(obj_height, 'g'); hold on;
        %plot(obj_height(1:excel_u(n,2)),'c-','LineWidth',3)
        
        yyaxis left;
        ylabel('Palm Z-Height (cm)')
        xlabel('Point in Array')
    end
    
    %interpolate original angle data and zscored data to have same length as
    %median trial length.  
    
    for m = 1:12 % joint angles
        u_o = unaffect_all{1,n}(:,m);
        u_new = u_o(indices);  %raw joint angle data from trial start to trial end
        u_raw{n, m} = u_new; % raw jt angle, uninterpolated 
        u{n,m} = interp1(t0,u_new,t1); %interpolated raw joint angle data to be used for zscoring, same length median trial
        
        % For ROM calculate based on u
        if m < 12 % ignore shoulder roll -- no error data saved for this; 
            min_ratio = boots.jt_rom_ratio_range.(jt_names{m})(1); 
            max_ratio = boots.jt_rom_ratio_range.(jt_names{m})(2); 
            [rom_min, rom_max, rom] =  calc_rom_w_bootstrapped_error(u{n,m}, min_ratio, max_ratio); 

        else % Shoulder roll; 
            rom = std(u{n, m}); 
            rom_min = rom; 
            rom_max = rom; 
        end
        u_rom{n,m} = rom; 
        u_rom_min{n,m} = rom_min; 
        u_rom_max{n,m} = rom_max; 
                
        % Make sure no nans;
        assert(~isnan(u_rom{n,m}))
        assert(~isnan(u_rom_max{n,m}))
        assert(~isnan(u_rom_min{n,m}))
               
    end
end


% Now that all entries of u{n, m} have been assigned, compute mean and std to z-score for each joint
for m = 1:12
    
    % mean / std for joint: %
    jt_data = cell2mat(u(:, m));  %u same length median trial

    % Turn this data into a concatenated row: 
    resh_jt_data = reshape(jt_data, [1, size(jt_data, 1)*size(jt_data, 2)]); 
    
    mu{m} = mean(resh_jt_data); 
    sigma{m} = std(resh_jt_data); 
    
    for n = 1:10
        
        % Use the mean / std computed over all trials to z-score each
        % trial:
        u_zs{n, m} = (u{n, m} - mu{m}) / sigma{m};       
    end
end


if any(convertCharsToStrings(hand) == "un")
    unaf.u = u; % un z-scored trial
    unaf.u_ind = ind;
    unaf.u_zs = u_zs; % z-scored trial 
    unaf.u_rom = u_rom; % std of unz-scored trial truncated at pinch
    unaf.u_rom_max = u_rom_max; 
    unaf.u_rom_min = u_rom_min; 
    unaf.zsc_mu = mu; % zscore parameters 
    unaf.zsc_std = sigma; % zscore parameters 
    unaf.mtl = mtl; %median trial length from start to end of pinch task 
    unaf.raw = u_raw; % un z-scored uninterpolated trial 
    output = unaf;
    
elseif any(convertCharsToStrings(hand) == "aff")
    affe.a = u; % un z-scored trial
    affe.a_ind = ind;
    affe.a_zs = u_zs; % z-scored trial 
    affe.a_rom = u_rom; % std of unz-scored trial truncated at pinch
    affe.a_rom_max = u_rom_max; 
    affe.a_rom_min = u_rom_min; 
    affe.zsc_mu = mu; % zscore parameters 
    affe.zsc_std = sigma; % zscore parameters 
    affe.mtl = mtl; %median trial length from start to end of pinch task 
    affe.raw = u_raw; % un z-scored uninterpolated trial 
    output = affe;
end





