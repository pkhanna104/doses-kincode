% Y=[rand(1000,1)];,gamrnd(1,2,1000,1),normrnd(10,2,1000,1),gamrnd(10,0.1,1000,1)];
% violin(Y,'x',[-1 .7 3.4 8.8],'facecolor',[1 1 0;0 1 0;.3 .3 .3;0 0.3 0.1],'edgecolor','none',...
% 'bw',0.3,'mc','k','medc','r-.')
% axis([-2 10 -0.5 20])
% ylabel('\Delta [yesno^{-2}]','FontSize',14)

%function draw_boxplot(ax, xposition, ydata, linecolor, facecolor, boxalpha)

    % Inputs: 
    %   ax: axis object 
    %   xposition: location to plot on x axis 
    %   ydata: array 
    %   linecolor: 1x3 color rgb array 
    %   facecolor: 1x3 color rgb array 
    %   boxalpha: float b/w [0, 1]; 


function draw_violin(ax, xposition, ydata, linecolor, facecolor, boxalpha)

%Get gca
axis(ax); 

% Feed in violin 
ydata = [ydata ydata]; 
ydata(:, 2) = 0; 
violin(ydata, 'x', [xposition, -10], 'facecolor', facecolor, 'edgecolor', linecolor, ...
    'mc','k', 'medc', [])