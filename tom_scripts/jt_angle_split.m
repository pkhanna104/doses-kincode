function [u_height,unaffect_all,data_palm,u_time] = jt_angle_split(hand,unaffected,angle_struct,input1);

%%%%%%%%%%
%  Inputs
%%%%%%%%%%
%this function takes as input the structure unaffected or affected from the original
%data file (ex. SB_ctrl_pinch_data.mat)
% the structure angle_struct from data file (ex. SB_jt_angle_un.mat -> produced from
%example_sensors2angles.m -> tom modified), 
% input reference to subject (ex. SB from %SB_ctrl_pinch_data.mat). 


    %This below function splits data into 10 trials based on raw data time stamps
    %in subject .mat files (eg. B8M_pinch_data.mat)
    if any(convertCharsToStrings(hand) == "un")
        [trial] = trial_time_split(unaffected,input1); 
    elseif any(convertCharsToStrings(hand) == "aff")
        [trial] = trial_time_split_aff(unaffected,input1); 
    end
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %taking angle and position data and breaking up into ten trials
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    data_p = unaffected.pos_data;
    data_h = unaffected.obj_height;
   
    for n = 1:10
        
        [tb_mcp] = angle_struct.Thumb_MCP(trial{n});
        [tb_dip] = angle_struct.Thumb_DIP(trial{n});
        [ib_mcp] = angle_struct.Index_MCP(trial{n});
        [ib_pip] = angle_struct.Index_PIP(trial{n});
        [ib_dip] = angle_struct.Index_DIP(trial{n});
        [eb] = angle_struct.Elbow_Flex(trial{n});
        [palm_flex] = angle_struct.Palm_Flex(trial{n});
        [palm_abd] = angle_struct.Palm_Abd(trial{n});
        [palm_prono] = angle_struct.Palm_Prono(trial{n});
        [palm] = [palm_abd' palm_flex' palm_prono'];
        [shoulder_hor_flex] = angle_struct.Shoulder_HorzFlex(trial{n});
        [shoulder_ver_flex] = angle_struct.Shoulder_VertFlex(trial{n});
        [shoulder_roll] = angle_struct.Shoulder_Roll(trial{n});
        [shoulder_ang] = [shoulder_hor_flex' shoulder_ver_flex' shoulder_roll'];
        
        data_palm{n} = data_p(trial{n},:,4);  % pos of palm

        unaffect_all{n} = [tb_mcp' tb_dip' ib_mcp' ib_pip' ib_dip' eb' palm shoulder_ang]; % joint angles per trial
        
         
        u_height{n} = data_h(trial{n}); %palm height data split into ten trials
        u_time{n} = unaffected.T_mat(trial{n});
        u_time{n} = [u_time{n}-u_time{n}(1)]';  %time split into ten trials and first time point per each trial 
        %is subtracted to have each trial start at 0

    end
end