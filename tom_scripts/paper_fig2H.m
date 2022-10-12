function paper_fig2H(norms,row,column);


  %% Plotting data for Paper Figure 2H
    
col = [[0 0 0]; [0.8500 0.3250 0.0980];[0.6350 0.0780 0.1840];[1 0 1]];
%black, orange/red, purple/red, purple
%Distal, palm, elbow, proximal

label = ["Thumb MCP","Thumb DIP","Index MCP","Index PIP","Index DIP","Elbow Flex","Palm Abd/Add","Palm Flex","Palm Sup/Pron","Shoulder Hor Flex","Shoulder Vert Flex","Shoulder Roll"];

    figure(10)
   
    for sub = 1:6
        
        for m = setdiff(1:12, [9 12]) % omit 9 and 12, palm and shoulder roll
           if m < 6
                color = col(1,:);
                s = scatter(norms.a_rom_norm_2_pinch(m,sub),norms.a_mse_norm_2_pinch(m,sub),'filled','MarkerEdgeColor',color,'MarkerFaceColor',color);hold on;
                s.SizeData = 100;
                s.Marker = 's';
                    
            elseif m == 6 
                color = col(3,:);

                s = scatter(norms.a_rom_norm_2_pinch(m,sub),norms.a_mse_norm_2_pinch(m,sub),'filled','MarkerEdgeColor',color,'MarkerFaceColor',color);hold on;
                s.SizeData = 100;
                s.Marker = 'h';
               
           elseif m > 6 & m < 10
                color = col(2,:);

                s = scatter(norms.a_rom_norm_2_pinch(m,sub),norms.a_mse_norm_2_pinch(m,sub),'filled','MarkerEdgeColor',color,'MarkerFaceColor',color);hold on;
                s.SizeData = 100;
                s.Marker = 'o';

           elseif m > 9
                color = col(4,:);

                s = scatter(norms.a_rom_norm_2_pinch(m,sub),norms.a_mse_norm_2_pinch(m,sub),'filled','MarkerEdgeColor',color,'MarkerFaceColor',color);hold on;
                s.SizeData = 100;
                s.Marker = 'd';
         
            end
    
            ax = gca;
            ax.FontSize = 10;
            box off
        end
    end

    %% Plotting Max error bars for Unaffected MSE and ROM Norms
    
    hold on;
    u_mse_norm_mean = norms.u_mse_norm_mean;
    u_mse_norm_std = norms.u_mse_norm_std;
     
    u_rom_norm_mean = norms.u_rom_norm_mean;
    u_rom_norm_std = norms.u_rom_norm_std;

    %max range for Unaffacted MSE Norms
    p1 = [norms.u_rom_norm_mean(row.mse,column.mse),norms.u_rom_norm_mean(row.mse,column.mse)];
    p2 = [-norms.u_mse_norm_std(row.mse,column.mse), norms.u_mse_norm_std(row.mse,column.mse)];
    plot(p1,p2,'k','LineWidth',2);hold on;

    %max range for Unaffacted ROM Norms
    p1 = [-norms.u_rom_norm_std(row.rom,column.rom),norms.u_rom_norm_std(row.rom,column.rom)];
    p2 = [norms.u_mse_norm_mean(row.rom,column.rom), norms.u_mse_norm_mean(row.rom,column.rom)];
    plot(p1,p2,'k','LineWidth',2);hold on;
        
    ylabel('T2TC (Norm)','fontweight','bold','FontSize',12)
    xlabel('ROM (Norm)','fontweight','bold','FontSize',12)
    set(gca,'fontweight','bold')

    ylim([-6 18])
