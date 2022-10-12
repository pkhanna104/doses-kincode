function paper_fig2_norms(norms,row,column);
    
    
    %% Plotting data for Paper Figure 2G
    
    col = [[0.8500 0.3250 0.0980]; [0.4940 0.1840 0.5560];[0.4660 0.6740 0.1880]];
    label = ["Thumb MCP","Thumb DIP","Index MCP","Index PIP","Index DIP","Elbow Flex","Palm Abd/Add","Palm Flex","Palm Sup/Pron","Shoulder Hor Flex","Shoulder Vert Flex","Shoulder Roll"];

    figure(9)
    subplot(5,3,[10:15])

    for sub = 1:3
         if sub == 1
                color = col(1,:);
            elseif sub == 2
                color = col(2,:);
            else
                color = col(3,:);
         end
        for m = setdiff(1:12, [9 12]) % omit 9 and 12, palm and shoulder roll
           if m < 6
                
                s = scatter(norms.a_rom_norm_2_pinch(m,sub),norms.a_mse_norm_2_pinch(m,sub),'filled','MarkerEdgeColor',color,'MarkerFaceColor',color);hold on;
                s.SizeData = 100;
                s.Marker = 's';
                if m == 1
                    text(norms.a_rom_norm_2_pinch(m,sub),norms.a_mse_norm_2_pinch(m,sub),label(m),'color',color,'fontweight','bold','FontSize', 8);
                end
              
            elseif m > 6 && m < 10
              
                s = scatter(norms.a_rom_norm_2_pinch(m,sub),norms.a_mse_norm_2_pinch(m,sub),'filled','MarkerEdgeColor',color,'MarkerFaceColor',color);hold on;
                s.SizeData = 100;
                s.Marker = 'h';
                if m == 7
                    text(norms.a_rom_norm_2_pinch(m,sub),norms.a_mse_norm_2_pinch(m,sub),label(m),'color',color,'fontweight','bold','FontSize', 8);
                end
            else
              
                s = scatter(norms.a_rom_norm_2_pinch(m,sub),norms.a_mse_norm_2_pinch(m,sub),'filled','MarkerEdgeColor',color,'MarkerFaceColor',color);hold on;
                s.SizeData = 100;
                s.Marker = 'd';
                if m == 11
                    text(norms.a_rom_norm_2_pinch(m,sub),norms.a_mse_norm_2_pinch(m,sub),label(m),'color',color,'fontweight','bold','FontSize', 8);
                end
            end
    
            ax = gca;
            ax.FontSize = 10;
            box off
        end
    end

    %% Plotting Max error bars for Unaffected MSE and ROM Norms
    
    hold on;
    subplot(5,3,[10:15])
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
