function [out_of_contour] = plot_conf_contour(ax, x, y, color, test_x, test_y)

% modeled off of plot_conf_ellipse, but now plot confidence contour
% use ksdensity to estimate kernel density of distribution 
% then plot contour associated w/ 95% confidence interval 

minx = min(x) - 3; 
maxx = max(x) + 3; 
gridx = minx:.05:maxx; 

miny = min(y) - 3;  
maxy = max(y) + 3; 
gridy = miny:.05:maxy; 

[x1,x2] = meshgrid(gridx, gridy);

% 'Support'; 
% two-by-two matrix for
%                     bivariate data, where the first row contains the lower
%                     limits and the second row contains the upper limits.
support = [minx miny; maxx, maxy]; 

[F, ~, ~] = ksdensity([x, y], [x1(:), x2(:)], 'Function', 'pdf');%,...
    %'Support', support); 

% Scan through levels to find the right contour value: 
val_perc = []; 
for test_val = 0:(max(F)/100):max(F) 
    inside = sum(F(F>=test_val)); 
    total = sum(F); 
    val_perc = [val_perc; test_val, inside/total]; 
end

% Find value closest to 95th percentile; 
%ix_all = find((0.95 - val_perc(:, 2)) > 0); 
%ix_fav = ix_all(1); 
[~, ix_fav] = min(abs(0.95 - val_perc(:, 2)));

% Get contour value; 
contour_value = val_perc(ix_fav, 1);

% Draw contour: 
% Reshape for contour: 
F2 = reshape(F, [length(gridy), length(gridx)]); 
[M, ~] = contour(ax, gridx, gridy, F2, 'LevelList', [contour_value],...
    'EdgeColor',color, 'LineWidth', 0.5); 

% Test if points are inside/outside
% Check for 1 curve 
N = M(2,1); 
assert(size(M, 2) == N+1)

% Make sure these match; 
assert(length(test_x) == length(test_y))

out_of_contour = []; 

for i = 1:length(test_x)
    in = inpolygon(test_x(i), test_y(i), M(1, 2:end), M(2, 2:end)); 
    
    if in
        out_of_contour = [out_of_contour 0]; 
    else 
        out_of_contour = [out_of_contour 1]; 
    end
end

