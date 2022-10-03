function [output] = interp_raw_n_zscore(unaffect_all,data_palm,input1,sign,exc_data,hand,on_off);

excel_ut_real = exc_data.(hand).raw;
excel_ut_length = exc_data.(hand).median;
excel_u = exc_data.(hand).s2p;
u_times = exc_data.(hand).t_times;

if any(convertCharsToStrings(hand) == "un")
    fn3 = 3;
elseif any(convertCharsToStrings(hand) == "aff")
    fn3 = 6;
end

k = 1;
    for n = 1:10;
        dp = sign.*data_palm{n}(:,3);
        dp_new = dp(excel_ut_real(n,1):excel_ut_real(n,2));  %full trial length
        t0 = 1:length(dp_new); % original time axis
        t1 = linspace(1, length(dp_new), excel_ut_length); % new time axis that still varies between 1 and length(u_new) but has more datapoints;
        dp = interp1(t0,dp_new,t1); %data to be used for zscoring

        %dp = interp1([1:length(dp_new)],dp_new,[1:excel_ut_length]);  %interpolate data so all same length to median trial
        %a lot of interpolated arrays contain NaN's even though all same length
        %now for all ten trials...all we care about is values in array starting
        %at 1st point to end of pinch test

        u_trial = linspace(0,u_times(k+1,4)-u_times(1,1),length(dp)); k = k + 2;
        k = 3;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
        %below figure 3 showing palm region for analysis in red -> palm height vs.
        %location in array -> start of task to end of pinch task -> trial now shifted so time 0 starts
        %at location 1 in array
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if any(convertCharsToStrings(on_off) == "on") 
            figure(fn3)
            subplot(5,2,n)
            plot(dp,'b');hold on;
            plot(dp(1:excel_u(n,2)),'r','LineWidth',3)
            ylabel('Palm Z-Height (cm)')
            xlabel('Point in Array')
        end

        %interpolate original angle data and zscored data to have same length as
        %median trial length.  u_rom is std of each trial/each joint , u_rom_2_pinch
        % is std of each trial/joint from start to end of   %pinch task
        for m = 1:12
            u_o = unaffect_all{1,n}(:,m);
            u_new = u_o(excel_ut_real(n,1):excel_ut_real(n,2));  %zscored data from trial start to trial end
            t0 = 1:length(u_new); % original time axis
            t1 = linspace(1, length(u_new), excel_ut_length); % new time axis that still varies between 1 and length(u_new) but has more datapoints;
            u{n,m} = interp1(t0,u_new,t1); %data to be used for zscoring
            u_unz{n,m} = u{n,m}; %interpolated un-zcored data
            u_start = u_unz{n,m};

            %z-scoring concatenated data (10 trials stacked together so
            %average and std used in zscore calc same for every trial
            mu{m} = mean(cell2mat(u(:,m))); % 1 x 241 array
            sigma{m} = std(cell2mat(u(:,m))); %1 x 241 array
            u{n,m} = (cell2mat(u(n,m)) - cell2mat(mu(m))) ./ cell2mat(sigma(m)); %zscored data all same length

            

            %data from start to end of pinch task with length of array = median trial
            %lenth
            u_unz_2_pinch{n,m} = u_start(1:excel_u(n,2));

            %calculate standard deviation (what we are calling rom) not taking into account nan at end of
            %array (not all arrays same length so median trial might be longer
            %than a couple of the trials

            u_rom{n,m} = nanstd(u_unz{n,m});
            u_rom_2_pinch{n,m} = nanstd(u_unz_2_pinch{n,m});

        end
        
    end
    
    if any(convertCharsToStrings(hand) == "un")
        unaf.u = u;
        unaf.u_unz = u_unz;
        unaf.u_rom = u_rom;
        unaf.u_rom_2_pinch = u_rom_2_pinch;
        output = unaf;
    elseif any(convertCharsToStrings(hand) == "aff")
        affe.a = u;
        affe.a_unz = u_unz;
        affe.a_rom = u_rom;
        affe.a_rom_2_pinch = u_rom_2_pinch;
        output = affe;
    end

   
    

      
