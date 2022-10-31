function draw_boxplot(ax, xposition, ydata, linecolor, facecolor, boxalpha)

    % Inputs: 
    %   ax: axis object 
    %   xposition: location to plot on x axis 
    %   ydata: array 
    %   linecolor: 1x3 color rgb array 
    %   facecolor: 1x3 color rgb array 
    %   boxalpha: float b/w [0, 1]; 

    boxplot(ax, ydata, 'positions', xposition, 'BoxStyle','outline',...
        'Colors',linecolor);
    
    h = findobj(gca,'Tag','Box');
    
    if length(h) > 1
        h = h(1); % get last addition 
    end

    % Set face value same as color, alpha = alph a
    patch(get(h,'XData'),get(h,'YData'),facecolor,...
            'FaceAlpha',boxalpha);


    % Mark outliers 
    h = findobj(gcf,'tag','Outliers'); 
    if length(h) > 1
        h = h(1); % get last addition 
    end
    set(h,'MarkerEdgeColor',facecolor)
    
end

