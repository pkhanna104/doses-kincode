function [trial] = trial_time_split_aff(unaffected,input)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 
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
        index4 = find(round(unaffected.T_mat,1)  == round(unaffected.T_state(n),1))+1000; %added 1000 so that entire trial could be seen
        index5(n) = index4(1);
    end
    
    m = 1;
    for n = 2:2:20;  %bc of the way task_state is organized!!
        trial{m} = index3(n)-10:index3(n+1)+70;  %% data point at which -> start of button press to start of next button press
        m = m + 1;
    end
      

end