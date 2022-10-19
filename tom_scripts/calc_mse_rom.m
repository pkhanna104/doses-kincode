function [mse_rom] = calc_mse_rom(path_to_data,slash,output,input1,hand)

    Filename =  convertStringsToChars(string(strcat(input1,'_st_2_pi_',hand,'.mat')));
    load([path_to_data 'data' slash 'tom_data' slash 'start_2_pinch_data' slash Filename]);
    
    if any(convertCharsToStrings(hand) == "un")
        u_zs = output.u_zs; % z-scored trial 
        u_rom = output.u_rom; % std of unz-scored trial truncated at pinch
    
    elseif any(convertCharsToStrings(hand) == "aff")
        u_zs = output.a_zs; % z-scored trial
        u_rom = output.a_rom;
    end

    for m = 1:12
        
        % moved this line to outside n=1:10 trial loop so not re-written
        % everytime 
        %median angles of zscored data from start to end, same length as median trial
        u_median_zs{m} = median(cell2mat(u_zs(:,m)));% Median z-scored data truncated at pinch
        assert(length(u_median_zs{m}) == size(u_zs{1, m}, 2)) % make sure size of median makes sense
            
            
        for n = 1:10
            %10/10/2022:  Tom changed below.  u variable already contain
            %interpolated trials from start -> end of pinch

            %%% MSE Calculations
            med_s2p = u_median_zs{m}; % Median truncated at pinch
            trl_s2p = u_zs{n,m};  % Individual trial trucated at pinch
            u_mse{n,m} = (1/length(trl_s2p).*sum((trl_s2p-med_s2p).^2));
            
        end

        %%% ROM calculations 
        %median rom of "un" zscored data from start to end of pinch task, same length as
        %median trial
        u_median_rom(m) = median(cell2mat(u_rom(:,m)));

    end

  if any(convertCharsToStrings(hand) == "un")
    umr.u_rom = u_rom;
    umr.u_mse = u_mse;
    umr.u_median_rom = u_median_rom;
    mse_rom = umr;
  elseif any(convertCharsToStrings(hand) == "aff")
    amr.a_rom = u_rom;
    amr.a_mse = u_mse;
    amr.a_median_rom = u_median_rom;
    mse_rom = amr;
  end