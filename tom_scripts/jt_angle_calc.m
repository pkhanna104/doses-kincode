function [zscore_mean, zscore_std,u_height,unaffect_all,data_palm,force,unaffect,u_time,sam_p_sec] = jt_angle_calc(unaffected,angle_struct,input);

%%%%%%%%%%
%  Inputs
%%%%%%%%%%
%this function takes as input the structure unaffected or affected from the original
%data file (ex. SB_ctrl_pinch_data.mat), the structure angle_struct from
%data file (ex. SB_jt_angle_un.mat -> produced from
%example_sensors2angles.m -> tom modified), and input reference to subject (ex. SB from
%SB_ctrl_pinch_data.mat).  

%%%%%%%%%%
%  Ouputs
%%%%%%%%%%

%Two main things cacluated here are joint angles per trial (ten of them) and palm position data per
%trial (ten of them)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%The trial stamps don't always include the full trial length.  Sometimes it
%appears truncated.  The below values allow the trial period to be
%extended such that the full trial could be visualized if plotted.  The below numbers were 
% determined by trial and error :(

    switch input
        case 'PK'
            len = 800;
        case 'SB'
            len = 1200;
        case 'AV'
            len = 800;
        case 'FR'
            len = 1200;
        case 'C9K'
            len = 80;
        case 'B12J'
            len = 80;
        case 'B8M'
            len = 80;
        case 'S13J'
            len = 250;
        case 'W16H'
            len = 250;
        case 'R15J'
            len = 250;
        case 'affected'
            len = 1000;
     end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Placing time data into ten separate trials
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    s = size(unaffected.T_mat);
    
    sam_p_sec = s(2)/max(unaffected.T_mat);
    
    s = size(unaffected.T_state);
    
    
    for n = 2:s(2)
        index(n) = floor(sam_p_sec .* unaffected.T_state(n));
        index2 = find(round(unaffected.T_mat,1)  == round(unaffected.T_state(n),1))-20;%-20 originally 
        
        index3(n) = index2(1);
        index4 = find(round(unaffected.T_mat,1)  == round(unaffected.T_state(n),1))+len; %80 (C9K,B8M,B12J), 250, 800 (all normals except sb), or 1200 (sb) 
        
        index5(n) = index4(1);
    end
    
    m = 1;
    for n = 2:2:20;  %bc of the way task_state is organized!!
        %trial{m} = index3(n):index3(n+1); %start of button press to start of next button press
        trial{m} = index3(n):index5(n); %start of button press to start of next button press
        m = m + 1;
    end
      
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %taking angle and position data and breaking up into ten trials
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    data = unaffected.angle_data;
    data_p = unaffected.pos_data;
    data_h = unaffected.obj_height;
    u_T_mat = unaffected.T_mat;
    data_f = unaffected.ard_pressure_sensor;


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
        force{n} = 0;%data_f(trial{n});
            
        unaffect{n} = [tb_mcp' tb_dip' ib_pip' ib_dip' eb'  palm shoulder_ang];
        
        [unaffect_a,zscore_mean{n}, zscore_std{n}] = zscore(abs([tb_mcp'-tb_mcp(1) tb_dip'-tb_dip(1) ib_mcp'-ib_mcp(1) ib_pip'-ib_pip(1) ib_dip'-ib_dip(1) eb'-eb(1) palm-palm(1,:) shoulder_ang-shoulder_ang(1,:)]));
        unaffect_a = abs([tb_mcp'-tb_mcp(1) tb_dip'-tb_dip(1) ib_mcp'-ib_mcp(1) ib_pip'-ib_pip(1) ib_dip'-ib_dip(1) eb'-eb(1) palm-palm(1,:) shoulder_ang-shoulder_ang(1,:)]);
    
        unaffect_all{n} = unaffect_a; % - unaffect_a(1,:)  ->  why did i substract since I already did in previous line????????????
      
        u_height{n} = data_h(trial{n});
        u_time{n} = u_T_mat(trial{n});
        u_time{n} = [u_time{n}-u_time{n}(1)]'; 

    end
end