function [mse_rom] = calc_mse_rom(path_to_data,slash,output,input1,hand)

    Filename =  convertStringsToChars(string(strcat(input1,'_st_2_pi_',hand,'.mat')));
    load([path_to_data 'data' slash 'tom_data' slash 'start_2_pinch_data' slash Filename]);
    
    if any(convertCharsToStrings(hand) == "un")
        u_zs = output.u_zs; % z-scored trial 
        u_rom = output.u_rom; % std of unz-scored trial truncated at pinch
        u_unzs = output.u; % Un-zscored; 

    elseif any(convertCharsToStrings(hand) == "aff")
        u_zs = output.a_zs; % z-scored trial
        u_rom = output.a_rom;
        u_unzs = output.a; % Un-zscored; 
    end

    % Load accuracy / precision data % 
    acc = load([path_to_data 'data' slash 'rom_error_preeya.mat']); 
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
    
    skip_jt_bc_var_too_low = {}; 
    
    for m = 1:12
        
        % moved this line to outside n=1:10 trial loop so not re-written
        % everytime 
        %median angles of zscored data from start to end, same length as median trial
        u_median_zs{m} = median(cell2mat(u_zs(:,m)));% Median z-scored data truncated at pinch
        assert(length(u_median_zs{m}) == size(u_zs{1, m}, 2)) % make sure size of median makes sense
            
        % check whether this subject / jt variation is >> expected
        % concatenat un-zscored trial; 
        u_cat = []; 
        for n = 1:10
            u_cat = [u_cat u_unzs{n, m}]; 
        end

        % Compare this to accuracy variation: 
        if m < 12
            acc_data = acc.accuracy_data.(jt_names{m}); 

            %if pv < 0.05: variance of u_cat is greater than variance of
            %acc_data, so we can safely proceed to analyze; 
            %[~,pv] = vartest2(u_cat, acc_data, 'alpha', 0.05,...
            %    'tail', 'right'); 

            %if pv >= 0.05: variance of acc_data is NOT greater than variance of
            %u_cat, so we can slightly less safely proceed to analyze; 
            [~,pv] = vartest2(u_cat, acc_data, 'alpha', 0.05,...
                'tail', 'left'); 

            if pv >= 0.05
                skip_jt_bc_var_too_low{m} = 0; 
            else
                skip_jt_bc_var_too_low{m} = 1;
                disp(['Var of jt sig lower than acc ' jt_names{m}])
            end
        end
        
        % Get z-scored params 
        zsc_mu = output.zsc_mu{m}; 
        zsc_std = output.zsc_std{m};

        if m < 12
            % 95th percentile of precision error; 
            max_imprec = prctile(abs(prec.jt_error_all.(jt_names{m})), 95); 
        
            % z-score: 
            % don't need to subtract mean bc already an error; 
            max_imprec_z = (max_imprec) / zsc_std; 
        else
            max_imprec_z = 0; 
        end 

        for n = 1:10
            %10/10/2022:  Tom changed below.  u variable already contain
            %interpolated trials from start -> end of pinch

            %%% MSE Calculations
            med_s2p = u_median_zs{m}; % Median truncated at pinch
            trl_s2p = u_zs{n,m};  % Individual trial trucated at pinch
    
            % 10/18/22: preeya additions
            % Diff b/w/ trl and median (z-scored); 
            diff_ = abs(trl_s2p-med_s2p);

            % Make sure minimum of diff isnt less than precision estima
            diff_(diff_ < max_imprec_z) = max_imprec_z; 

            u_mse{n,m} = (1/length(trl_s2p).*sum(diff_.^2));
            
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
    umr.u_skip_jt_bc_var_too_low = skip_jt_bc_var_too_low; 
    mse_rom = umr;
  elseif any(convertCharsToStrings(hand) == "aff")
    amr.a_rom = u_rom;
    amr.a_mse = u_mse;
    amr.a_median_rom = u_median_rom;
    amr.a_skip_jt_bc_var_too_low = skip_jt_bc_var_too_low; 
    mse_rom = amr;
  end