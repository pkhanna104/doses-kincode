function [trial] = trial_time_split(unaffected,input1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%The trial stamps don't always include the full trial length.  Sometimes it
%appears truncated.  The below values allow the trial period to be
%extended such that the full trial could be visualized if plotted.  The below numbers were 
% determined by trial and error :(

    switch input1
        case 'PK_ctrl'
            len = 800;
        case 'SB_ctrl'
            len = 1200;
        case 'AV_ctrl'
            len = 800;
        case 'FR_ctrl'
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
        trial{m} = index3(n):index5(n); % data point at which -> start of button press to start of next button press
        m = m + 1;
    end
end