function [mse_rom] = calc_mse_rom(path_to_data,slash,output,input1,hand)

    Filename =  convertStringsToChars(string(strcat(input1,'_st_2_pi_',hand,'.mat')));
    load([path_to_data 'data' slash 'tom_data' slash 'start_2_pinch_data' slash Filename]);
    
    if any(convertCharsToStrings(hand) == "un")
        u_zs = output.u_zs; % z-scored trial 
        u_rom = output.u_rom; % std of unz-scored trial truncated at pinch
        u_rom_max = output.u_rom_max; 
        u_rom_min = output.u_rom_min; 
        %u_unzs = output.u; % Un-zscored; 

    elseif any(convertCharsToStrings(hand) == "aff")
        u_zs = output.a_zs; % z-scored trial
        u_rom = output.a_rom;
        u_rom_max = output.a_rom_max; 
        u_rom_min = output.a_rom_min; 
        %u_unzs = output.a; % Un-zscored; 
    end

    % Load precision data % 
    prec = load([path_to_data 'data' slash 'precision_error_preeya.mat']); 
    
    % Joint names in accuracy; 
    % jts 1:12:
    % [eb] = angle_struct.Elbow_Flex(trial{n});
    % [palm] = [palm_abd' palm_flex' palm_prono'];
    % [shoulder_ang] = [shoulder_hor_flex' shoulder_ver_flex' shoulder_roll'];
    % unaffect_all{n} = [tb_mcp' tb_dip' ib_mcp' ib_pip' ib_dip' eb' palm shoulder_ang]; 
    jt_names = {'Thumb_MCP', 'Thumb_DIP', 'Index_MCP', 'Index_PIP', 'Index_DIP',...
        'Elbow_Flex', 'Palm_Abd', 'Palm_Flex', 'Palm_Prono', 'Shoulder_HorzFlex',...
        'Shoulder_VertFlex'}; 
    
    for m = 1:12
        
        % moved this line to outside n=1:10 trial loop so not re-written
        % everytime 
        %median angles of zscored data from start to end, same length as median trial
        u_median_zs{m} = median(cell2mat(u_zs(:,m)));% Median z-scored data truncated at pinch
        assert(length(u_median_zs{m}) == size(u_zs{1, m}, 2)) % make sure size of median makes sense
        
        % Get z-scored params 
        zsc_mu = output.zsc_mu{m}; 
        zsc_std = output.zsc_std{m};

        if m < 12
            % 95th percentile of precision error; 
            %max_imprec = prctile(abs(prec.jt_error_all.(jt_names{m})), 95); 
            %max_imprec = mean(abs(prec.jt_error_all.(jt_names{m}))); 
            max_imprec = std(prec.jt_error_all.(jt_names{m})); 
            
            % z-score: 
            % don't need to subtract mean bc already an error; 
            max_imprec_z = (max_imprec) / zsc_std; 
            % disp(['Jt ' jt_names{m} ', ' num2str(max_imprec), ': Z : ' num2str(max_imprec_z)])
        else
            max_imprec_z = 0; 
        end 

        for n = 1:10
            %10/10/2022:  Tom changed below.  u variable already contain
            %interpolated trials from start -> end of pinch

            %%% MSE Calculations
            med_s2p = u_median_zs{m}; % Median truncated at pinch
            trl_s2p = u_zs{n,m};  % Individual trial trucated at pinch
    
            [mse_min, mse_max, mse] = calc_mse_w_error_randsamp(trl_s2p, med_s2p, max_imprec_z); 
            
            u_mse{n,m} = mse; %sqrt(1/length(trl_s2p).*sum(diff_.^2));
            u_mse_min{n, m} = mse_min; 
            u_mse_max{n, m} = mse_max; 
        end

        %%% Median ROM calculations 
        %median rom of "un" zscored data from start to end of pinch task, same length as
        %median trial
        u_median_rom(m) = median(cell2mat(u_rom(:,m)));

        %%% use accuracy data to add error bars to u_rom: 
        u_median_rom_min(m) = median(cell2mat(u_rom_min(:,m)));
        u_median_rom_max(m) = median(cell2mat(u_rom_max(:,m)));
        assert(u_median_rom_min(m) <= u_median_rom_max(m))
        assert(u_median_rom_min(m) <= u_median_rom(m))

        %%%% Median MSE calculations 
        u_median_mse(m) = median(cell2mat(u_mse(:,m)));
        u_median_mse_min(m) = median(cell2mat(u_mse_min(:,m)));
        u_median_mse_max(m) = median(cell2mat(u_mse_max(:,m)));

        assert(u_median_mse_min(m) <= u_median_mse(m))
        assert(u_median_mse(m) <= u_median_mse_max(m))

    end

  if any(convertCharsToStrings(hand) == "un")
    umr.u_rom = u_rom;
    umr.u_median_mse = u_median_mse;
    umr.u_median_mse_min = u_median_mse_min;
    umr.u_median_mse_max = u_median_mse_max;

    umr.u_median_rom = u_median_rom;
    umr.u_median_rom_min = u_median_rom_min;
    umr.u_median_rom_max = u_median_rom_max; 
    mse_rom = umr;

  elseif any(convertCharsToStrings(hand) == "aff")
    amr.a_rom = u_rom;
    amr.a_median_mse = u_median_mse;
    amr.a_median_mse_min = u_median_mse_min;
    amr.a_median_mse_max = u_median_mse_max;

    amr.a_median_rom = u_median_rom;
    amr.a_median_rom_min = u_median_rom_min;
    amr.a_median_rom_max = u_median_rom_max; 
    mse_rom = amr;
    
  end