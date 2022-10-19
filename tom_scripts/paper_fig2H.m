function paper_fig2H(norms,row,column);


  %% Plotting data for Paper Figure 2H
    
col = [[0 0 0]; [0.8500 0.3250 0.0980];[0.6350 0.0780 0.1840];[1 0 1]];
%black, orange/red, purple/red, purple
%Distal, palm, elbow, proximal

label = ["Thumb MCP","Thumb DIP","Index MCP","Index PIP","Index DIP","Elbow Flex","Palm Abd/Add","Palm Flex","Palm Sup/Pron","Shoulder Hor Flex","Shoulder Vert Flex","Shoulder Roll"];

    figure(10)
   
    for sub = 1:6
        
        for m = setdiff(1:12, [9 12]) % omit 9 and 12, palm and shoulder roll
           if m < 6 %distal joints
                if sub == 6 & m == 5 %dont inlude R15J index dip as unexplained jumps in data
                    continue;
                end
                
                if norms.a_rom_norm_2_pinch(m,sub) < 3 & norms.a_mse_norm_2_pinch(m,sub) > 7
                    subplot(5,4,[2:3])
                elseif norms.a_rom_norm_2_pinch(m,sub) < 3 & norms.a_mse_norm_2_pinch(m,sub) < 7
                    subplot(5,4,[6 7 10 11])
                    ylim([-1 7])
                else 
                    subplot(5,4,[8 12])
                    ylim([-1 7])
                end

                
                color = col(1,:);
                if any(sub == [7:10]) == 1
                    color = [0 1 0]; %green
                end

                s = scatter(norms.a_rom_norm_2_pinch(m,sub),norms.a_mse_norm_2_pinch(m,sub),'filled','MarkerEdgeColor',color,'MarkerFaceColor',color);hold on;
                s.SizeData = 100;
                s.Marker = 's';

                    
            elseif m == 6  %elbow joint
                
                if norms.a_rom_norm_2_pinch(m,sub) < 3 & norms.a_mse_norm_2_pinch(m,sub) > 7
                    subplot(5,4,[2:3])
                    xlim([-1.5 2.5])
                elseif norms.a_rom_norm_2_pinch(m,sub) < 3 & norms.a_mse_norm_2_pinch(m,sub) < 7
                    subplot(5,4,[6 7 10 11])
                    ylim([-1 7])
                else 
                    subplot(5,4,[8 12])
                    ylim([-1 7])
                end
                
                color = col(3,:);
                
                if any(sub == [7:10]) == 1
                    color = [0 1 0]; %green
                end
                s = scatter(norms.a_rom_norm_2_pinch(m,sub),norms.a_mse_norm_2_pinch(m,sub),'filled','MarkerEdgeColor',color,'MarkerFaceColor',color);hold on;
                s.SizeData = 100;
                s.Marker = 'h';
               
           elseif m > 6 & m < 10 %palm joints
                
                if norms.a_rom_norm_2_pinch(m,sub) < 3 & norms.a_mse_norm_2_pinch(m,sub) > 7
                    subplot(5,4,[2:3])
                    xlim([-1.5 2.5])
                elseif norms.a_rom_norm_2_pinch(m,sub) < 3 & norms.a_mse_norm_2_pinch(m,sub) < 7
                    subplot(5,4,[6 7 10 11])
                    ylim([-1 7])
                else 
                    subplot(5,4,[8 12])
                    ylim([-1 7])
                end
               
                color = col(2,:);
                 if any(sub == [7:10]) == 1
                    color = [0 1 0]; %green
                end
                s = scatter(norms.a_rom_norm_2_pinch(m,sub),norms.a_mse_norm_2_pinch(m,sub),'filled','MarkerEdgeColor',color,'MarkerFaceColor',color);hold on;
                s.SizeData = 100;
                s.Marker = 'o';

           elseif m > 9 %proximal joints

                if norms.a_rom_norm_2_pinch(m,sub) < 3 & norms.a_mse_norm_2_pinch(m,sub) > 7
                    subplot(5,4,[2:3])
                    xlim([-1.5 2.5])
                elseif norms.a_rom_norm_2_pinch(m,sub) < 3 & norms.a_mse_norm_2_pinch(m,sub) < 7
                    subplot(5,4,[6 7 10 11])
                    ylim([-1 7])
                else 
                    subplot(5,4,[8 12])
                    ylim([-1 7])
                end

                color = col(4,:);
                 if any(sub == [7:10]) == 1
                    color = [0 1 0]; %green
                end

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
    subplot(5,4,[6 7 10 11])
    
    p1 = [norms.u_rom_norm_mean(row.mse,column.mse),norms.u_rom_norm_mean(row.mse,column.mse)];
    p2 = [-norms.u_mse_norm_std(row.mse,column.mse), norms.u_mse_norm_std(row.mse,column.mse)];
    plot(p1,p2,'k','LineWidth',2);hold on;
    ylim([-2 7])

    %max range for Unaffacted ROM Norms
    subplot(5,4,[6 7 10 11])
    
    p1 = [-norms.u_rom_norm_std(row.rom,column.rom),norms.u_rom_norm_std(row.rom,column.rom)];
    p2 = [norms.u_mse_norm_mean(row.rom,column.rom), norms.u_mse_norm_mean(row.rom,column.rom)];
    plot(p1,p2,'k','LineWidth',2);hold on;
    ylim([-2 7])

    ylabel('T2TC (Norm)','fontweight','bold','FontSize',12)
    xlabel('ROM (Norm)','fontweight','bold','FontSize',12)
    set(gca,'fontweight','bold')
%% MSE median bars left of main plots



distal = [1:5];
elbow = [6 NaN NaN NaN NaN];
palm = [7 8 NaN NaN NaN];
prox = [10 11 NaN NaN NaN];

jts = [distal;elbow;palm;prox];
mark = ['s', 'h', 'o', 'd'];
c = [1 3 2 4];

for j = 1:4
    subplot(5,4,[5 9]) 
    j_val = jts(j,:);
    j_val = j_val(~isnan(j_val));
    
    s = scatter(median(norms.a_mse_norm_2_pinch(j_val,:),'all'),0,...
        'filled','MarkerEdgeColor',col(j,:),'MarkerFaceColor',col(j,:));hold on;
    s.Marker = mark(j);
    
    range = reshape(norms.a_mse_norm_2_pinch(j_val,:),[],1);
    mse = norms.u_mse_norm_std(row.mse,column.mse);
    range = range(range > -mse & range < mse);
    
    s = scatter(median(range,'all'),1,...
        'filled','MarkerEdgeColor',col(j,:),'MarkerFaceColor',col(j,:));hold on;
    s.Marker = mark(j);

end

s.SizeData = 100;
xlim([-1 7])
ylim([0 1])
camroll(90)

%% ROM median bars below main plots




for j = 1:4
    subplot(5,4,[14 15 18 19])  
    j_val = jts(j,:);
    j_val = j_val(~isnan(j_val));
    
    s = scatter(median(norms.a_rom_norm_2_pinch(j_val,:),'all'),1,...
        'filled','MarkerEdgeColor',col(j,:),'MarkerFaceColor',col(j,:));hold on;
    s.Marker = mark(j);
    
    range = reshape(norms.a_rom_norm_2_pinch(j_val,:),[],1);
    mse = norms.u_mse_norm_std(row.mse,column.mse);
    range = range(range > -mse & range < mse);
    
    s = scatter(median(range,'all'),0,...
        'filled','MarkerEdgeColor',col(j,:),'MarkerFaceColor',col(j,:));hold on;
    s.Marker = mark(j);

end

xlim([-1.5 2.5])
ylim([0 1])
s.SizeData = 100;
    
