function plot_raw_data(value,input,hand,angle_struct,b)

input = input;

if value == 1;

    unaffected = hand;

    [zscore_mean, zscore_std,u_height,unaffect_all,data_palm,force,unaffect,u_time,sam_p_sec] = jt_angle_calc(unaffected,angle_struct,input);
    excel_ut_real = xlsread('discrete trial points 1 through 10_single_average', input, 'Z3:AA12');
    excel_ut_length = median(excel_ut_real(:,2));
    excel_u = xlsread('discrete trial points 1 through 10_single_average', input, 'AG3:AH12');
    u_times = xlsread('discrete trial points 1 through 10', input, 'B3:E22');
    
    a = 1;
    for n = 1:10;
       dp = data_palm{n}(:,3);
       dp_new = dp(excel_ut_real(n,1):excel_ut_real(n,2));
       dp = interp1([1:length(dp_new)],dp_new,[1:excel_ut_length]);
       u_trial = linspace(0,u_times(a+1,4),length(dp)); a = a + 2;
       
       ms = [1 7 11];
       f = figure(9);
       k = b;
       for m = 1:12
            %below two lines because some bend angles were greater than 180
            %degrees!!!
           u_n = unaffect_all{1,n}(:,m);
           %u_n(u_n > 180) = abs(u_n(u_n > 180) - 360);
           
           u_unz{n,m} = interp1([1:length(u_n(excel_ut_real(n,1):excel_ut_real(n,2)))],u_n(excel_ut_real(n,1):excel_ut_real(n,2)),[1:excel_ut_length]);
            if any(m == ms)
                subplot(5,3,k)
                plot(u_trial(1:excel_u(n,2)),u_unz{n,m}(1:excel_u(n,2)),'b');hold on;
                label = ["Thumb MCP","Thumb DIP","Index MCP","Index PIP","Index DIP","Elbow Flex","Palm Abd/Add","Palm Flex","Palm Sup/Pron","Shoulder Hor Flex","Shoulder Vert Flex","Shoulder Roll"];
                k = k + 3;
                set(gca,'fontweight','bold')
            end
       end
    end

else

    affected = hand;
    %%%%%%%%%%%%%%%  affected hand %%%%%%%%%%%%%%%%%%%%%%%%%
    
    [zscore_mean, zscore_std,u_height,unaffect_all,data_palm,force,unaffect,u_time,sam_p_sec] = jt_angle_calc_aff(affected,angle_struct,input);
    excel_a = xlsread('discrete trial points 1 through 10_single_average', input, 'O15:T24');
    excel_a_t = xlsread('discrete trial points 1 through 10_single_average', input, 'S15:P24');
    excel_a_real = xlsread('discrete trial points 1 through 10_single_average', input, 'W16:X25');
    excel_at_real = xlsread('discrete trial points 1 through 10_single_average', input, 'Z16:AA25');
    excel_at_length = median(excel_at_real(:,2));
    excel_a = xlsread('discrete trial points 1 through 10_single_average', input, 'AG16:AH25');
    a_times = xlsread('discrete trial points 1 through 10', input, 'I3:L22');
    
    a = 1;
    for n = 1:10;
    %    figure(11)
       dp = data_palm{n}(:,3);
       dp_new = dp(excel_at_real(n,1):excel_at_real(n,2));
       dp = interp1([1:length(dp_new)],dp_new,[1:excel_at_length]);
       a_trial = linspace(0,a_times(a+1,4),length(dp)); a = a + 2;
       
        ms = [1 7 11];
        k = b;
       figure(9)
       
        for m = 1:12
            %below two lines because some bend angles were greater than 180
            %degrees!!!
            a_n = unaffect_all{1,n}(:,m);
            %a_n(a_n > 180) = abs(a_n(a_n > 180) - 360);
            
                
            a_unz{n,m} = interp1([1:length(a_n(excel_at_real(n,1):excel_at_real(n,2)))],a_n(excel_at_real(n,1):excel_at_real(n,2)),[1:excel_at_length]);
            a_start = a_unz{n,m};
            a_unz_2_pinch{n,m} = a_start(1:excel_a(n,2));
              if any(m == ms)
                subplot(5,3,k)
                plot(a_trial(1:excel_a(n,2)-10),a_unz{n,m}(1:excel_a(n,2)-10),'r');hold on;
                %pbaspect([2 1 1])
                label = ["Thumb MCP","Thumb DIP","Index MCP","Index PIP","Index DIP","Elbow Flex","Palm Abd/Add","Palm Flex","Palm Sup/Pron","Shoulder Hor Flex","Shoulder Vert Flex","Shoulder Roll"];
                title(label(m))
                %set(ax,'fontweight','bold')
                ax = gca;
                ax.XAxis.Visible ='off';
                if any(k == [7:9])
                    ax.XAxis.Visible ='on';
                    xlabel('Time (sec)','fontweight','bold','FontSize',12); 
                end
                box off
                set(gca,'fontweight','bold')
                k = k + 3;
            end
       end
    end      
    
     ylabel('Angle (deg)','fontweight','bold','FontSize',12);
 
end

end