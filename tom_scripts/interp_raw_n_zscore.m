function [output] = interp_raw_n_zscore(unaffect_all,data_palm,height,input1,sign,exc_data,hand,on_off);

excel_ut_real = exc_data.(hand).raw; % full trial length
excel_ut_length = exc_data.(hand).median; % trial length to interpolate to
excel_u = exc_data.(hand).s2p; % in new interpolated data pts for start2pinch
u_times = exc_data.(hand).t_times;

if any(convertCharsToStrings(hand) == "un")
    fn3 = 3;
elseif any(convertCharsToStrings(hand) == "aff")
    fn3 = 6;
end


for n = 1:10 % Trials
    dp = sign.*data_palm{n}(:,3);
    indices = excel_ut_real(n,1):excel_ut_real(n,2);
    dp_new = dp(indices);  %full trial length
    
    t0 = 1:length(dp_new); % original time axis
    t1 = linspace(1, length(dp_new), excel_ut_length); % new time axis that still varies between 1 and length(u_new) but has more datapoints;
    
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
        plot(dp(1:excel_u(n,2)),'r','LineWidth',3)
        
        yyaxis right
        plot(obj_height, 'g'); hold on;
        plot(obj_height(1:excel_u(n,2)),'c-','LineWidth',3)
        
        yyaxis left;
        ylabel('Palm Z-Height (cm)')
        xlabel('Point in Array')
    end
    
    %interpolate original angle data and zscored data to have same length as
    %median trial length.  u_rom is std of each trial/each joint , u_rom_2_pinch
    % is std of each trial/joint from start to end of   %pinch task
    for m = 1:12 % joint angles
        u_o = unaffect_all{1,n}(:,m);
        u_new = u_o(indices);  %raw joint angle data from trial start to trial end
        u{n,m} = interp1(t0,u_new,t1); %interpolated raw joint angle data to be used for zscoring
        
        u_unz{n, m} = u{n, m}; % Store un-zscored raw joint angle data
        u_unz_2_pinch{n, m} = u{n, m}(1:excel_u(n,2)); % Truncated interpolated raw joint angle data
        
        % For ROM calculate based on u_unz
        u_rom{n,m} = std(u_unz{n,m});
        u_rom_2_pinch{n,m} = nanstd(u_unz_2_pinch{n,m});
        
        % Make sure no nans;
        assert(~isnan(u_rom{n,m}))
        assert(~isnan(u_rom_2_pinch{n,m}))
        
    end
end


% Now that all entries of u{n, m} have been assigned, compute mean and std to z-score for each joint
for m = 1:12
    
    % mean / std for joint: %
    jt_data = cell2mat(u(:, m)); 
    resh_jt_data = reshape(jt_data, [1, size(jt_data, 1)*size(jt_data, 2)]); 
    
    mu{m} = mean(resh_jt_data); 
    sigma{m} = std(resh_jt_data); 
    
    for n = 1:10
        
        % Use the mean / std computed over all trials to z-score each
        % trial:
        u{n, m} = (u{n, m} - mu{m}) / sigma{m};
        
    end
end


if any(convertCharsToStrings(hand) == "un")
    unaf.u = u; % z-scored trial 
    unaf.u_unz = u_unz; % un-zscored trial 
    unaf.u_rom = u_rom; % std of un-zscored trial 
    unaf.u_rom_2_pinch = u_rom_2_pinch; % std of unz-scored trial truncated at pinch
    output = unaf;
elseif any(convertCharsToStrings(hand) == "aff")
    affe.a = u;
    affe.a_unz = u_unz;
    affe.a_rom = u_rom;
    affe.a_rom_2_pinch = u_rom_2_pinch;
    output = affe;
end





