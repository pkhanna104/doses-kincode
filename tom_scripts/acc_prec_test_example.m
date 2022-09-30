clear; clc;

subjects = ["B8M","C9K","B12J","W16H_small","S13J_small","R15J_small"];

filename = 'C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\Four healthy subject data\data\rom_error_preeya.mat';
load([filename])
accuracy_data = sum_tru_dmnerr;  %struct containing variance or std? of accuracy data per joint -> this should be taken from 
%output from variable "sum_tru_dmnerr" produced from script angle_validatiom_plots.m

filename = 'C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\Four healthy subject data\data\precision_error_preeya.mat';
load([filename])
precision_data = jt_error;  %output from variable "jt_error (beginning and 
% code starting at line 44) ->  produced from script angle_validatiom_plots.m

for s = 1:size(subjects,2)
    input = convertStringsToChars(subjects(s));

    filename = string(strcat('C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\Four healthy subject data\', input,'_res.mat'));
    load([filename]);
        
    [vartest_u,vartest_a,error_u,error_a] = acc_prec_test...
        (input,u_rom_2_pinch,a_rom_2_pinch,accuracy_data,un_raw,aff_raw,precision_data,...
    median_trial_data_u,median_trial_data_a);

    vartest.unaffected.(input) = vartest_u;
    vartest.affected.(input) = vartest_a;
    vartest.joint_names =   {'Thumb_MCP','Thumb_DIP','Index_MCP','Index_PIP','Index_DIP'...
        'Palm_Abd','Palm_Flex','Palm_Pron','Elbow_Flex',...
            'Shoulder_Horz_Flex', 'Shoulder_Vert_Flex'};
    prectest.unaffacted.(input) = error_u;
    prectest.affacted.(input) = error_a;
    prectest.joint_names =   {'Thumb_MCP','Thumb_DIP','Index_MCP','Index_PIP','Index_DIP'...
        'Palm_Abd','Palm_Flex','Palm_Pron','Elbow_Flex',...
            'Shoulder_Horz_Flex', 'Shoulder_Vert_Flex'};

end

save('C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\Four healthy subject data\data\vartest_prectest_tom.mat','vartest','prectest');


function [vartest_u,vartest_a,error_u,error_a] = acc_prec_test...
    (input,u_rom_2_pinch,a_rom_2_pinch,accuracy_data,un_raw,aff_raw,precision_data,...
    median_trial_data_u,median_trial_data_a);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%inputs to function for rom ftest:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%u_rom_2_pinch{n,m} = unaffected std of time series joint angle data of trial 
% n (10 in total), joint m (12 in total)
%a_rom_2_pinch{n,m} = affected std of time series joint angle data of trial 
% n (10 in total), joint m (12 in total)
%above two variables calculated from tom script msq_error_all_subjects_normals.m and
%saved in a file called 'input'_res.mat

%accuracy_data = output from variable "sum_tru_dmnerr" produced from script
%angle_validatiom_plots.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Outputs:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%vartest_u = 12 element array containing values 1 or 0.  1 = rejection of
%null hpothesis for unaffected data -> this means ROM from joint not from
%same normal distrubution as error data from control subjects
%vartest_a = 12 element array containing values 1 or 0.  1 = rejection of
%null hpothesis for affected data -> this means ROM from joint not from
%same normal distrubution as error data from control subjects
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % ROM comparison
    %ftest comparison of std from each joint/unaff/add/trial (10 std per joint) to
    %std of accuracy data (10 per joint)...significance level default value
    %of 0.05

    %tom angle data:

    %thumn mcp, dip; index mcp, pip, dip; palm abd, flex, pron; elbow flex,
    %shoulder horz flex, vert flex, roll

    %preeya angle data as written in struct
    accuracy_data_cell = struct2cell(accuracy_data);
    n = [1 2 5 4 3 7 6 8 9 11 10];  %Preeya angle data re-arranged to match mine for comparison below
    
    
    for  m = [1:11]  %skipping analysis of shoulder roll
         vartest_u(m) = vartest2(cell2mat(u_rom_2_pinch(:,m)),cell2mat(accuracy_data_cell(n(m))));  %rom defined in terms of std
         vartest_a(m) = vartest2(cell2mat(a_rom_2_pinch(:,m)),cell2mat(accuracy_data_cell(n(m))));  %rom defined in terms of std
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%inputs to function for T2TV test:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%un_raw{n,m} = median trial - single trial from start to 
% pinch -> calculted from msq_error_all_subjects_normals.m
%aff_raw{n,m} = median trial - single trial from start to 
% pinch -> calculted from msq_error_all_subjects_normals.m
%median_trial_data_u{m} = unaffected median trial data from start to end of pinch of m joint 
%median_trial_data_a{m} = affected median trial data from start to end of pinch of m joint 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Outputs:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%error_u{n,m} = 0 or 1 -> unaffacted precision error for nth trial and mth joint -> 1 if max(median
%trial data - trial data) is greater than 2.5th percentile of precision
%data and less than 97.5th percentile of precision data, 0 otherwise
%error_a{n,m} = 0 or 1 -> affacted precision error for nth trial and mth joint -> 1 if max(median
%trial data - trial data) is greater than 2.5th percentile of precision
%data and less than 97.5th percentile of precision data, 0 otherwise
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p = prctile(precision_data,[2.5 97.5],"all"); %calculate 2.5th and 97.5th percentile from precision data 
lower = p(1);
upper = p(2);

     % T2TV comparison
     for n = 1:10
         for m = 1:11
            if (max(cell2mat(un_raw(n,m))) >= max(cell2mat(median_trial_data_u(m))-lower)) & ...
                    (max(cell2mat(un_raw(n,m))) <= max(cell2mat(median_trial_data_u(m))-upper))
                error_u{n,m} = 1;
            else
                error_u{n,m} = 0;
            end

             if (max(cell2mat(aff_raw(n,m))) >= max(cell2mat(median_trial_data_a(m))-lower)) & ...
                    (max(cell2mat(aff_raw(n,m))) <= max(cell2mat(median_trial_data_a(m))-upper))
                error_a{n,m} = 1;
            else
                error_a{n,m} = 0;
            end

         end
     end

       

end