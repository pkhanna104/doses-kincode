subject = "C9K"; 
add_to_task_name = '';
folder = 'patient';
fname = strcat('data/task_data/', folder, '/',subject,...
    add_to_task_name, '_pinch_data.mat');

green = [15, 129, 64]/256; 
blue = [58, 83, 164]/256; 
purple = [165, 63, 151]/256; 
s_palm = 4; %2018 data; 
xlims = [104, 118]; 

ts = [105.156, 113.414]; 
te = [107.735, 116.025]; 

% Load data 
dat = load(fname); 

T_mat = dat.unaffected.T_mat;
obj_height = dat.unaffected.obj_height;
obj_height = obj_height - min(obj_height); 
palmheight = dat.unaffected.pos_data(:, 3, s_palm); 

T_press = dat.unaffected.T_ard_pressure_sensor ; 
obj_press  = dat.unaffected.ard_pressure_sensor;
obj_press = obj_press - min(obj_press); 


% Plot sensors 
figure; 
subplot(2, 1, 1); hold all; 
plot(T_mat, palmheight, '-', 'Color', purple, 'LineWidth', 2); 
ax2 = gca; 
set(ax2,'YTick',[0, 5, 10]);
set(ax2,'YTickLabel',[0, 5, 10],'YColor',purple);
xlim(xlims)
ylabel('Palm lift (cm)')

for i = 1:2
    plot([ts(i), ts(i)], [0, 10], 'k--')
    plot([te(i), te(i)], [0, 10], 'k--')
end

subplot(2, 1, 2); hold all;
[haxes,hline1,hline2] = plotyy(T_press, double(obj_press)/100., T_mat,...
    obj_height); 

set(haxes(1), 'YColor', blue);
set(hline1, 'Color', blue, 'LineWidth', 2); 
set(haxes(1), 'YTick', [0, 2, 4, 6, 8])
ylabel('Force sensor (a. u.)')

set(haxes(2), 'YColor', green);
set(hline2, 'Color',green, 'LineWidth', 2); 
set(haxes(2), 'YTick', [0, 2, 4, 6])
%set(gca, 'ylabel', 'Object height (cm)')

set(haxes(1), 'XLim', xlims)
set(haxes(1), 'YLim', [0, 8])
set(haxes(2), 'XLim', xlims)
set(haxes(2), 'YLim', [0, 6])

for i = 1:2
    plot([ts(i), ts(i)], [0, 8], 'k--')
    plot([te(i), te(i)], [0, 8], 'k--')
end
%saveas(gcf, ['figs/fig1_traces.svg'])

