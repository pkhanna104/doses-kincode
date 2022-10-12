function paper_fig2_raw(Filename,hand,angle_struct,sub_plot_num,on_off)
    
    load([Filename])
    [input1 input sign] = names_sign(Filename);

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %below is done b/c input1 contains the entire path to the subject!
    if ismac % Preeya computer
        path_to_data = '/Users/preeyakhanna/Dropbox/Ganguly_Lab/Projects/HP_Sensorized_Object/doses-kincode/';
        slash = '/'; 

    else % Tom computer 
        path_to_data = 'C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\doses-kincode-main\'; 
        slash = '\'; 

    end
    level = wildcardPattern + "\";
    pat = asManyOfPattern(level);
    input1 = convertStringsToChars(extractAfter(input1,pat));  %returns only the subject name, not path preeceding!
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if any(convertCharsToStrings(hand) == "un")
        [u_height,unaffect_all,data_palm,u_time] = jt_angle_split(hand,unaffected,angle_struct,input1);
        [output] = interp_raw_n_zscore(path_to_data,slash,u_time,unaffect_all,data_palm, u_height, input1,sign,'un','off');  %does inerpolation and plotting
        ind = output.u_ind;
       
    else
        [a_height,affect_all,aff_data_palm,a_time] = jt_angle_split(hand,affected,angle_struct,input1);
        [aff_output]  = interp_raw_n_zscore(path_to_data,slash,a_time,affect_all,aff_data_palm, a_height, input1, sign,'aff','off');
        ind = aff_output.a_ind;
    end
   
    

    figure(9);
    k = sub_plot_num;
    for m = [1 7 11]  %Thumb MCP, Palm Abd, Shoulder Vert Flex
        for n = 1:10
            subplot(5,3,k)
            
            if any(convertCharsToStrings(hand) == "un")
                t = u_time{n};
                t = t(ind{n});
                t = t-t(1);
                u_orig = unaffect_all{1,n}(:,m);
                u_orig = u_orig(ind{n});
                plot(t,u_orig,'b');hold on;  %plotting original unaf un-interpolated data vs time
            else 
                ta = a_time{n};
                ta = ta(ind{n});
                ta = ta-ta(1);
                a_orig = affect_all{1,n}(:,m);
                a_orig = a_orig(ind{n});
                plot(ta,a_orig,'r');hold on; %plotting original aff un-interpolated data
            end
            label = ["Thumb MCP","Thumb DIP","Index MCP","Index PIP","Index DIP","Elbow Flex","Palm Abd/Add","Palm Flex","Palm Sup/Pron","Shoulder Hor Flex","Shoulder Vert Flex","Shoulder Roll"];
            title(label(m))
            ax = gca;
            ax.XAxis.Visible ='off';
            if any(k == [7:9])
                ax.XAxis.Visible ='on';
                xlabel('Time (sec)','fontweight','bold','FontSize',12);
            end
            box off
            set(gca,'fontweight','bold')
    
        end
        k = k + 3;
    end
    
    ylabel('Angle (deg)','fontweight','bold','FontSize',12);



   
                
               
    
   
    