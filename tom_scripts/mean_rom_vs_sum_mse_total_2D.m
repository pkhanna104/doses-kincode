clear;clc;close all;

input = 'C9K';
load 'C9K_pinch_data.mat';
Filename = string(strcat('C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\Four healthy subject data\',input,'_jt_angle_un.mat'));
load ([Filename]);
plot_raw_data_v2(1,input,unaffected,angle_struct,1);hold on; 
Filename = string(strcat('C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\Four healthy subject data\',input,'_jt_angle_aff.mat'));
load ([Filename]);
plot_raw_data_v2(2,input,affected,angle_struct,1);


load 'S13J_small_pinch_data.mat';
input = 'S13J';
Filename = string(strcat('C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\Four healthy subject data\','S13J_small','_jt_angle_un.mat'));
load ([Filename]);
plot_raw_data_v2(1,input,unaffected,angle_struct,2);hold on; 
Filename = string(strcat('C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\Four healthy subject data\','S13J_small','_jt_angle_aff.mat'));
load ([Filename]);
plot_raw_data_v2(2,input,affected,angle_struct,2);

input = 'B12J';
load 'B12J_pinch_data.mat';
Filename = string(strcat('C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\Four healthy subject data\',input,'_jt_angle_un.mat'));
load ([Filename]);
plot_raw_data_v2(1,input,unaffected,angle_struct,3);hold on; 
Filename = string(strcat('C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\Four healthy subject data\',input,'_jt_angle_aff.mat'));
load ([Filename]);
plot_raw_data_v2(2,input,affected,angle_struct,3);


load('C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\Four healthy subject data\C9K_res.mat');
C9K_u_mse = u_mse_sum;
C9K_a_mse = a_mse_sum;

C9K_u_mse_mean = u_mse_norm_mean;
C9K_u_mse_2std = u_mse_norm_std;
C9K_u_rom_mean = u_rom_norm_mean;
C9K_u_rom_2std = u_rom_norm_std;

C9K_u_rom = u_rom_norm;
C9K_a_rom = a_rom_norm;

load('C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\Four healthy subject data\B12J_res.mat');
B12J_u_mse = u_mse_sum;
B12J_a_mse = a_mse_sum;
B12J_u_rom = u_rom_norm;
B12J_a_rom = a_rom_norm;

B12J_u_mse_mean = u_mse_norm_mean;
B12J_u_mse_2std = u_mse_norm_std;
B12J_u_rom_mean = u_rom_norm_mean;
B12J_u_rom_2std = u_rom_norm_std;

load('C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\Four healthy subject data\S13J_small_res.mat');
S13J_u_mse = u_mse_sum;
S13J_a_mse = a_mse_sum;
S13J_u_rom = u_rom_norm;
S13J_a_rom = a_rom_norm;

S13J_u_mse_mean = u_mse_norm_mean;
S13J_u_mse_2std = u_mse_norm_std;
S13J_u_rom_mean = u_rom_norm_mean;
S13J_u_rom_2std = u_rom_norm_std;



load('C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\Four healthy subject data\W16H_small_res.mat');
W16H_u_mse = u_mse_sum;
W16H_a_mse = a_mse_sum;
W16H_u_rom = u_rom_norm;
W16H_a_rom = a_rom_norm;

W16H_u_mse_mean = u_mse_norm_mean;
W16H_u_mse_2std = u_mse_norm_std;
W16H_u_rom_mean = u_rom_norm_mean;
W16H_u_rom_2std = u_rom_norm_std;


load('C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\Four healthy subject data\B8M_res.mat');
B8M_u_mse = u_mse_sum;
B8M_a_mse = a_mse_sum;
B8M_u_rom = u_rom_norm;
B8M_a_rom = a_rom_norm;

B8M_u_mse_mean = u_mse_norm_mean;
B8M_u_mse_2std = u_mse_norm_std;
B8M_u_rom_mean = u_rom_norm_mean;
B8M_u_rom_2std = u_rom_norm_std;

load('C:\Users\toppenheim\Desktop\UCSF\thumb data\Preeya Data\data\collated_data\Four healthy subject data\R15J_small_res.mat');
R15J_u_mse = u_mse_sum;
R15J_a_mse = a_mse_sum;
R15J_u_rom = u_rom_norm;
R15J_a_rom = a_rom_norm;

R15J_u_mse_mean = u_mse_norm_mean;
R15J_u_mse_2std = u_mse_norm_std;
R15J_u_rom_mean = u_rom_norm_mean;
R15J_u_rom_2std = u_rom_norm_std;


mse_u = [C9K_u_mse' B8M_u_mse' W16H_u_mse' S13J_u_mse' B12J_u_mse' R15J_u_mse'];

u_mse_norm_mean = [C9K_u_mse_mean' B8M_u_mse_mean' W16H_u_mse_mean' S13J_u_mse_mean' B12J_u_mse_mean' R15J_u_mse_mean'];
u_mse_norm_std = [C9K_u_mse_2std' B8M_u_mse_2std' W16H_u_mse_2std' S13J_u_mse_2std' B12J_u_mse_2std' R15J_u_mse_2std'];

mse_a = [C9K_a_mse' B8M_a_mse' W16H_a_mse' S13J_a_mse' B12J_a_mse' R15J_a_mse'];
rom = [C9K_a_rom' B8M_a_rom' W16H_a_rom' S13J_a_rom' B12J_a_rom' R15J_a_rom'];

u_rom_norm_mean = [C9K_u_rom_mean' B8M_u_rom_mean' W16H_u_rom_mean' S13J_u_rom_mean' B12J_u_rom_mean' R15J_u_rom_mean'];
u_rom_norm_std = [C9K_u_rom_2std' B8M_u_rom_2std' W16H_u_rom_2std' S13J_u_rom_2std' B12J_u_rom_2std' R15J_u_rom_2std'];


ARAT = [50.3 37.7 36.7 35.7 33.3 21.3];
joint = ['s','h','d'];
joint_c = [1 2 3];
col = [[0 0.4470 0.7410]; [0.8500 0.3250 0.0980]; [0.4660 0.6740 0.1880]; [0.4940 0.1840 0.5560]; [0.4940 0.1840 0.5560]; [0.6350 0.0780 0.1840]];
%black red green blue purple yellow

%actual order needed is red purple green
%sub == 2, col == 2
%sub == 4, col == 5
%sub == 5, col = 3


v = 2;
r = 5;
figure(9)
sub1 = 1;
for m = 1:12
    for sub = [2 4 5]
        if sub == 2
            color = col(2,:);
        elseif sub == 4
            color = col(5,:);
        else
            color = col(3,:);
        end
        
%                figure(1)
%                 if m < 6 
%                     c = 1;
%                     subplot(3,1,1)
%                     plot(rom(m,sub),(mse_a(m,sub)-mse_u(m,sub))./mse_u(m,sub),'s','Color',[col(sub,:)],'LineWidth', 2);hold on;
%                     
%                 elseif m > 6 & m < 10  
%                     c = 2;
%                     subplot(3,1,1)
%                     plot(rom(m,sub),(mse_a(m,sub)-mse_u(m,sub))./mse_u(m,sub),'h','Color',[col(sub,:)],'LineWidth', 2);hold on;
%                     
%                 else
%                     c = 3;
%                     subplot(3,1,1)
%                     plot(rom(m,sub),(mse_a(m,sub)-mse_u(m,sub))./mse_u(m,sub),'d','Color',[col(sub,:)],'LineWidth', 2);hold on;
%                     
%                 end
%                  
% %                scatter(rom(m,sub+1),mse(m,sub+1),[],ARAT(sub+1),'filled');hold on;
% %                
%                label = ["Thumb MCP","Thumb DIP","Index MCP","Index PIP","Index DIP","Elbow Flex","Palm Abd/Add","Palm Flex","Palm Sup/Pron","Shoulder Hor Flex","Shoulder Vert Flex","Shoulder Roll"];
%                ylabel('Sum MSE of Z-Scored Data Norm (Aff-Un)/Un')
%                xlabel('(Aff Std Ave - Un Std Ave) / Un Std Ave')
%                zticks([1:3])
%                zticklabels({'Distal Joints','Palm Joints','Proximal Joints'})
%                axis([-1.5 8 -2 18])
% 
%                grid on
               %axis([-1 1 0 15])
               %legend('C9K Distal','B8M Distal','W16H Distal','S13J Distal','B12J Distal','R15J Distal',...
                   %'C9K Palm','B8M Palm','W16H Palm','S13J Palm','B12J Palm','R15J Palm')
                %legend
                label = ["Thumb MCP","Thumb DIP","Index MCP","Index PIP","Index DIP","Elbow Flex","Palm Abd/Add","Palm Flex","Palm Sup/Pron","Shoulder Hor Flex","Shoulder Vert Flex","Shoulder Roll"];

                if m < 6 
                    c = 1;
                    if rom(m,sub) < 1.5
                        subplot(5,3,[10 11 13 14])
%                         colormap jet
%                         caxis([20 51])
                    else
                        subplot(5,3,[12 15])
                        xlim([3 5.5])
                    end
                    %plot(u_rom_norm_mean(m,sub),u_mse_norm_mean(m,sub),'d','Color',[0 0 0],'LineWidth',4);hold on;
                    e = errorbar(u_rom_norm_mean(m,sub),u_mse_norm_mean(m,sub),-u_mse_norm_std(m,sub),u_mse_norm_std(m,sub),-u_rom_norm_std(m,sub),u_rom_norm_std(m,sub),'LineWidth',2);hold on;
                    e.Color = 'black';
                    e.CapSize = 15;
                    s = scatter(rom(m,sub),(mse_a(m,sub)-mse_u(m,sub))./mse_u(m,sub),'filled','MarkerEdgeColor',color,'MarkerFaceColor',color);hold on;  
                    s.SizeData = 100;
                    s.Marker = 's';
                    if m == 1
                        text(rom(m,sub),(mse_a(m,sub)-mse_u(m,sub))./mse_u(m,sub),label(m),'color',color,'fontweight','bold','FontSize', 8);
                    end
                    ylim([-2 10])
                    
                    %s = scatter(rom_2_pinch(m,sub),(mse_a_2_pinch(m,sub)-mse_u_2_pinch(m,sub))./mse_u_2_pinch(m,sub),[],'ks','filled');hold on;  

                elseif m > 6 && m < 10  
                    c = 2;
                   if rom(m,sub) < 1.5
                        subplot(5,3,[10 11 13 14])
%                         colormap jet
%                         caxis([20 51])
                    else
                        subplot(5,3,[12 15])
                    end
                    %plot(u_rom_norm_mean(m,sub),u_mse_norm_mean(m,sub),'d','Color',[0 0 0],'LineWidth',4);hold on;
                    e = errorbar(u_rom_norm_mean(m,sub),u_mse_norm_mean(m,sub),-u_mse_norm_std(m,sub),u_mse_norm_std(m,sub),-u_rom_norm_std(m,sub),u_rom_norm_std(m,sub),'LineWidth',2);hold on;
                    e.Color = 'black';
                    e.CapSize = 15;
                      s = scatter(rom(m,sub),(mse_a(m,sub)-mse_u(m,sub))./mse_u(m,sub),'filled','MarkerEdgeColor',color,'MarkerFaceColor',color);hold on;  
                    s.SizeData = 100;
                    s.Marker = 'h';
                    if m == 7
                        text(rom(m,sub),(mse_a(m,sub)-mse_u(m,sub))./mse_u(m,sub),label(m),'color',color,'fontweight','bold','FontSize', 8);
                    end
                    ylim([-2 10])
                    
                else
                    c = 3;
                    if rom(m,sub) < 1.5
                        subplot(5,3,[10 11 13 14])
%                         colormap jet
%                         caxis([20 51])
                    else
                        subplot(5,3,[12 15])
                    end
                    %h = breakxaxis([1.5 3]);
                    %plot(u_rom_norm_mean(m,sub),u_mse_norm_mean(m,sub),'d','Color',[0 0 0],'LineWidth',4);hold on;
                    e = errorbar(u_rom_norm_mean(m,sub),u_mse_norm_mean(m,sub),-u_mse_norm_std(m,sub),u_mse_norm_std(m,sub),-u_rom_norm_std(m,sub),u_rom_norm_std(m,sub),'LineWidth',2);hold on;
                    e.Color = 'black';
                    e.CapSize = 15;
                       s = scatter(rom(m,sub),(mse_a(m,sub)-mse_u(m,sub))./mse_u(m,sub),'filled','MarkerEdgeColor',color,'MarkerFaceColor',color);hold on;  
                    s.SizeData = 100;
                    s.Marker = 'd';
                    if m == 11
                        text(rom(m,sub),(mse_a(m,sub)-mse_u(m,sub))./mse_u(m,sub),label(m),'color',color,'fontweight','bold','FontSize', 8);
                    end
                    ylim([-2 10])
                    
                end
                
                
                
                ax = gca;
                %ax.LineWidth = 1.5;
                ax.FontSize = 10; 
                %xticks([0 ceil(max(max(a_times))/10)*10])
                box off
                set(gca,'fontweight','bold')

                
%                 figure(3)
%                 if m < 6 
%                     c = 1;
%                     subplot(3,2,1)
%                     s = scatter(0,(mse_a(m,sub)-mse_u(m,sub))./mse_u(m,sub),[],ARAT(sub),'filled');hold on;  
%                     s.SizeData = 100;
%                     s.Marker = 's';
%                     %axis([-1 1 -1 8])
%                     set(gca,'XTickLabel',[]);
%                     set(gca,'XTickLabel',[]);
%                     set(gca,'xTick',[]);
%                      h = colorbar;
%                 colormap jet
%                 caxis([20 51])
%                 h.Label.String = 'ARAT Score';
%                 title('Normalized MSE Thumb MCP')
%                 
%                     
%                     subplot(3,2,2)
%                     s = scatter(rom(m,sub),0,[],ARAT(sub),'filled');hold on;  
%                     s.SizeData = 100;
%                     s.Marker = 's';
%                     %axis([-1 5 -1 1])
%                      set(gca,'YTickLabel',[]);
%                     set(gca,'yTick',[]);
%                             h = colorbar;
%                 colormap jet
%                 caxis([20 51])
%                 h.Label.String = 'ARAT Score';
%                 title('Normalized Std Thumb MCP')
%                 
%                 elseif m > 6 & m < 10  
%                     c = 2;
%                     subplot(3,2,3)
%                     s = scatter(0,(mse_a(m,sub)-mse_u(m,sub))./mse_u(m,sub),[],ARAT(sub),'filled');hold on;
%                     s.SizeData = 100;
%                     s.Marker = 'h';
%                     set(gca,'XTickLabel',[]);
%                     
%                      subplot(3,2,4)
%                     s = scatter(rom(m,sub),0,[],ARAT(sub),'filled');hold on;
%                     s.SizeData = 100;
%                     s.Marker = 'h';
%                     set(gca,'YTickLabel',[]);
%                 else
%                     c = 3;
%                     subplot(3,2,5)
%                     s = scatter(0,(mse_a(m,sub)-mse_u(m,sub))./mse_u(m,sub),[],ARAT(sub),'filled');hold on;
%                     s.SizeData = 100;
%                     s.Marker = 'h';
%                     set(gca,'XTickLabel',[]);
%                     set(gca,'xTick',[]);
%                     
%                      subplot(3,2,6)
%                     s = scatter(rom(m,sub),0,[],ARAT(sub),'filled');hold on;
%                     s.SizeData = 100;
%                     s.Marker = 'h';
%                     set(gca,'YTickLabel',[]);
%                 end
                %grid on;
               sub1 = sub1 + 1;
                
                
    end
    sub1 = 1;
end
                
                %grid on;
%                 h = colorbar;
%                 colormap jet
%                 caxis([20 51])
%                 h.Label.String = 'ARAT Score';
                ylabel('T2TC (Norm)','fontweight','bold','FontSize',12)
                xlabel('ROM (Norm)','fontweight','bold','FontSize',12)
                xlim([3 5.5])
                set(gca,'fontweight','bold')
                %break_axis('axis','x','position',1.2)

               
%                  plot([-1.5 8],[0 0],'k--');hold on;
%                 plot([0 0],[-2 18],'k--');hold on;
                %axis([-1.5 8 -2 35])


% figure(10)
% 
% %subplot(4,3,[7:12]);
% 
% %figure(4)
% rom = rom(:,v:r);
% mse_t = (mse_a(:,v:r)-mse_u(:,v:r))./mse_u(:,v:r);
% 
% X = [rom(:) mse_t(:)];
% idx = kmeans(X,4);
% h = gscatter(X(:,1),X(:,2),idx,'rmgb',[],30);hold on;
% z = repmat([ones(1,5) 2.*ones(1,3) 3.*ones(1,4)],1,(v+r)-1);
% 
% %e.Color = 'black';
% %e.CapSize = 15;
% 
% %gscatter3(X(:,1),X(:,2),z,idx,'rkgb',{'o','o','o','o'},8,'auto');
% 
% ylabel('Norm Precision')
% xlabel('Norm ROM')
% zticks([1:3])
% zticklabels({'Distal Joints','Palm Joints','Proximal Joints'})
% %legend('Normal','High Variance, Poor Joint Control','Extremely Poor Joint Control','Joint Overcompensation')
% label = ["Thumb MCP","Thumb DIP","Index MCP","Index PIP","Index DIP","Elbow Flex","Palm Abd/Add","Palm Flex","Palm Sup/Pron","Shoulder Hor Flex","Shoulder Vert Flex","Shoulder Roll"];
% plot([-1.5 9],[0 0],'k--','LineWidth',3);hold on;
% plot([0 0],[-5 35],'k--','LineWidth',3);hold on;
% 
% %plot(u_rom_norm_mean,u_mse_norm_mean,'Color',[0 0 0],'LineWidth',4);hold on;
% %e = errorbar(u_rom_norm_mean,u_mse_norm_mean,-u_mse_norm_std,u_mse_norm_std,-u_rom_norm_std,u_rom_norm_std,'k','LineWidth',2);
% 
% x = [-15*max(max(u_rom_norm_mean)):0.001:15*max(max(u_rom_norm_mean))];
% 
% %y =  sqrt(max(max(u_mse_norm_mean)).^2 .*(1 - ((x - max(max(u_rom_norm_std))).^2 ./ max(max(u_rom_norm_mean)).^2))) + max(max(u_mse_norm_std));
% h =  0;%max(max(u_rom_norm_mean));
% k = 0;%max(max(u_mse_norm_mean));
% a = max(max(u_rom_norm_std)); 
% b = max(max(u_mse_norm_std)); 
% 
% y = nonzeros(real(sqrt(b.^2 .* (1 - (x - h).^2 ./ a.^2)) + k));
% 
% x = linspace(-15*max(max(u_rom_norm_mean)),15*max(max(u_rom_norm_mean)),length(y));
% x = max(max(u_rom_norm_mean))+[x x];
% z = max(max(u_mse_norm_mean))+[y; -y]';
% 
% %plot(x,y);hold on;
% %plot(x,-y)
% 
% patch(x,z,'k','FaceAlpha',.6)
% %patch(x,-y,'r','FaceAlpha',.3)
% 
% % h = ellipse(max(max(u_rom_norm_std)),max(max(u_mse_norm_std)),0,max(max(u_rom_norm_mean)),max(max(u_mse_norm_mean)),'k',1000);
% % h.FaceColor = 'blue';
% % h.FaceAlpha = 0.5;
% 
% 
% %axis([-1.5 8 -2 18])
% % for m = 1:12
% %     for sub = 1:4
% %                 if m < 6 
% %                     c = 1;
% %                     text(rom(m,sub),mse_t(m,sub),append(label(m),' ',num2str(ARAT(sub+1))),'FontSize',8)
% %                 elseif m > 6 & m < 10  
% %                     c = 2;
% %                     text(rom(m,sub),mse_t(m,sub),append(label(m),' ',num2str(ARAT(sub+1))),'FontSize',8)
% %                 else
% %                     c = 3;
% %                     text(rom(m,sub),mse_t(m,sub),append(label(m),' ',num2str(ARAT(sub+1))),'FontSize',8)
% %                 end
% %     end
% % end
% 
