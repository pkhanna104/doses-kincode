clear;clc;close all;

input = 'B8M';
load 'B8M_pinch_data.mat';
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

        label = ["Thumb MCP","Thumb DIP","Index MCP","Index PIP","Index DIP","Elbow Flex","Palm Abd/Add","Palm Flex","Palm Sup/Pron","Shoulder Hor Flex","Shoulder Vert Flex","Shoulder Roll"];

        if m < 6
            c = 1;
            if rom(m,sub) < 1.5
                subplot(5,3,[10 11 13 14])
            else
                subplot(5,3,[12 15])
                xlim([3 5.5])
            end
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
        elseif m > 6 && m < 10
            c = 2;
            if rom(m,sub) < 1.5
                subplot(5,3,[10 11 13 14])
            else
                subplot(5,3,[12 15])
            end
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
            else
                subplot(5,3,[12 15])
            end
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
        ax.FontSize = 10;
        box off
        set(gca,'fontweight','bold')


        sub1 = sub1 + 1;
           
    end
    sub1 = 1;
end

ylabel('T2TC (Norm)','fontweight','bold','FontSize',12)
xlabel('ROM (Norm)','fontweight','bold','FontSize',12)
xlim([3 5.5])
set(gca,'fontweight','bold')
              