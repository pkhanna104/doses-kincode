function [mse_rom] = calc_mse_rom(output,input1,exc_data,hand)

    u_times = exc_data.(hand).t_times;
    excel_u = exc_data.(hand).s2p;
    
    if any(convertCharsToStrings(hand) == "un")
        u = output.u;
        u_unz = output.u_unz;
        u_rom = output.u_rom;
        u_rom_2_pinch = output.u_rom_2_pinch;
    elseif any(convertCharsToStrings(hand) == "aff")
        u = output.a;
        u_unz = output.a_unz;
        u_rom = output.a_rom;
        u_rom_2_pinch = output.a_rom_2_pinch;
    end

    for n = 1:10;
        for m = 1:12
            %median angles of not z scored data from start to end of pinch,
            %same lengths as median trial
            un_raw{n,m} = median(cell2mat(u_unz(:,m))) - cell2mat(u_unz(:,m));
            un_raw{n,m} = un_raw{n,m}(1:excel_u(n,2));
            median_trial_data_u{m} = median(cell2mat(u_unz(:,m)));
    
            %median angles of zscored data from start to end, same length as median trial
            u_median{m} = median(cell2mat(u(:,m)));
            %median rom of "un" zscored data from start to end, same length as
            %median trial
            u_median_rom(m) = median(cell2mat(u_rom(:,m)));
            %median rom of "un" zscored data from start to end of pinch task, same length as
            %median trial
            u_median_rom_2_pinch(m) = median(cell2mat(u_rom_2_pinch(:,m)));
    
    
            %         if any(isnan(u_median{m}))  %some of the u_mean vectors have NaN at the end!!!
            %             ones = find(isnan(u_median{m}));
            %             excel_u(n,2) = ones(1)-1;
            %         end
    
            %for both start through pinch task ---- no return -> mse
            %calculation of zscored data
            u_mse{n,m} = (1/length(u{n,m}(1:excel_u(n,2)))).*sum((u{n,m}(1:excel_u(n,2))-u_median{m}(1:excel_u(n,2))).^2);
            u_mse_2_pinch{n,m} = (1/length(u{n,m}(1:excel_u(n,2)))).*sum((u{n,m}(1:excel_u(n,2))-u_median{m}(1:excel_u(n,2))).^2);
    
        end
    end

  if any(convertCharsToStrings(hand) == "un")
    umr.u_mse = u_mse;
    umr.u_mse_2_pinch = u_mse_2_pinch;
    umr.un_raw = un_raw;
    umr.median_trial_data_u = median_trial_data_u;
    umr.u_median = u_median;
    umr.u_median_rom = u_median_rom;
    umr.u_median_rom_2_pinch = u_median_rom_2_pinch;
    umr.u_rom = u_rom;
    mse_rom = umr;
  elseif any(convertCharsToStrings(hand) == "aff")
    amr.a_mse = u_mse;
    amr.a_mse_2_pinch = u_mse_2_pinch;
    amr.aff_raw = un_raw;
    amr.median_trial_data_a = median_trial_data_u;
    amr.a_median = u_median;
    amr.a_median_rom = u_median_rom;
    amr.a_median_rom_2_pinch = u_median_rom_2_pinch;
    amr.a_rom = u_rom;
    mse_rom = amr;
  end