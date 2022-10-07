function [mse_rom] = calc_mse_rom(output,input1,exc_data,hand)

    excel_u = exc_data.(hand).s2p; % times from start to pinch that can be used after interpolation
    
    if any(convertCharsToStrings(hand) == "un")
        u = output.u; % z-scored trial 
        %u_unz = output.u_unz; % un-zscored trial 
        u_rom = output.u_rom; % std of un-zscored trial 
        u_rom_2_pinch = output.u_rom_2_pinch; % std of unz-scored trial truncated at pinch
    
    elseif any(convertCharsToStrings(hand) == "aff")
        u = output.a;
        %u_unz = output.a_unz;
        u_rom = output.a_rom;
        u_rom_2_pinch = output.a_rom_2_pinch;
    end

    for m = 1:12
        
        % moved this line to outside n=1:10 trial loop so not re-written
        % everytime 
        %median angles of zscored data from start to end, same length as median trial
        u_median{m} = median(cell2mat(u(:,m)));
        assert(length(u_median{m}) == size(u{1, m}, 2)) % make sure size of median makes sense
            
            
        for n = 1:10
            % Preeya changes 10/6/22: commenting these lines to avoid confusion
            %median angles of not z scored data from start to end of pinch,
            %same lengths as median trial
            %un_raw{n,m} = median(cell2mat(u_unz(:,m))) - cell2mat(u_unz(n,m)); % single trial residual
            %un_raw{n,m} = un_raw{n,m}(1:excel_u(n,2)); % single trial residual form start to pinch 
            %median_trial_data_u{m} = median(cell2mat(u_unz(:,m)));
    
            %median angles of zscored data from start to end, same length as median trial
            %u_median{m} = median(cell2mat(u(:,m)));
            
            %for both start through pinch task ---- no return -> mse
            %calculation of zscored data
            % Preeya changes 10/6/22: commeneting u_mse to avoid confusion
            % since identical to u_mse_2_pinch: 
            %u_mse{n,m} =         (1/length(u{n,m}(1:excel_u(n,2)))).*sum((u{n,m}(1:excel_u(n,2))-u_median{m}(1:excel_u(n,2))).^2);
            
            med_s2p = u_median{m}(1:excel_u(n, 2)); % Median truncated at pinch
            trl_s2p = u{n,m}(1:excel_u(n,2));  % Individual trial trucated at pinch
            u_mse_2_pinch{n,m} = (1/length(trl_s2p).*sum((trl_s2p-med_s2p).^2));
            
            
            %%% ROM calculations 
            %median rom of "un" zscored data from start to end, same length as
            %median trial
            %u_median_rom(m) = median(cell2mat(u_rom(:,m)));
            %median rom of "un" zscored data from start to end of pinch task, same length as
            %median trial
            u_median_rom_2_pinch(m) = median(cell2mat(u_rom_2_pinch(:,m)));
    
    
    
        end
    end

  if any(convertCharsToStrings(hand) == "un")
    %umr.u_mse = u_mse;
    umr.u_mse_2_pinch = u_mse_2_pinch;
    %umr.un_raw = un_raw;
    %umr.median_trial_data_u = median_trial_data_u;
    %umr.u_median = u_median;
    %umr.u_median_rom = u_median_rom;
    umr.u_median_rom_2_pinch = u_median_rom_2_pinch;
    umr.u_rom_2_pinch = u_rom_2_pinch; % PK: changed u_rom --> u_rom_2_pinch
    mse_rom = umr;
  elseif any(convertCharsToStrings(hand) == "aff")
    %amr.a_mse = u_mse;
    amr.a_mse_2_pinch = u_mse_2_pinch;
    %amr.aff_raw = un_raw;
    %amr.median_trial_data_a = median_trial_data_u;
    %amr.a_median = u_median;
    %amr.a_median_rom = u_median_rom;
    amr.a_median_rom_2_pinch = u_median_rom_2_pinch;
    amr.a_rom_2_pinch = u_rom_2_pinch;% PK: changed u_rom --> u_rom_2_pinch 
    mse_rom = amr;
  end