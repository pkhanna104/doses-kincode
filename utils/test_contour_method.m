
% Get a grid for support 
gridx1 = -0.25:.05:2;
gridx2 = 3:.5:12;
[x1,x2] = meshgrid(gridx1, gridx2);

% Data distribution 
X = [0+.5*rand(20,1) 5+2.5*rand(20,1);
            .75+.25*rand(10,1) 8.75+1.25*rand(10,1)];

% Fit KS density, sample along data 
[F, xi] = ksdensity(X, [x1(:), x2(:)], 'Function','pdf'); 

% Reshape for pcolor
F2 = reshape(F, [length(gridx2), length(gridx1)]); 
%imagesc(gridx1, gridx2, F2); hold all; 

% Scan through levels: 
for i = .01:.005:.2
    inside = sum(F(F>=i)); 
    total = sum(F); 
    fprintf('Threshold %.4f, p(inside) = %.4f\n', i, inside/total)
end

[M, C] = contour(gridx1, gridx2, F2, 'LevelList',[0.0250], 'color', 'k',...
    'LineWidth', .5);
hold all; 

% in = inpolygon(xq,yq,xv,yv) returns in indicating if the query points 
% specified by xq and yq are inside or on the edge of the polygon area 
% defined by xv and yv.

% Check for 1 curve 
N = M(2,1); 
assert(size(M, 2) == N+1)

for i = 1:length(gridx1)
    for j = 1:length(gridx2)
        in = inpolygon(gridx1(i), gridx2(j), M(1, 2:end), M(2, 2:end)); 
        if in
            plot(gridx1(i), gridx2(j), 'r.')
        else
            plot(gridx1(i), gridx2(j), 'b.')
        end
    end
end

figure; 
pcolor(gridx1, gridx2, F2); hold all; 


% Notes: 
% F=ksdensity(X,YI,...,'function','icdf') computes the
%                     estimated inverse CDF of the values in X, and evaluates
%                     it at the probability values specified in YI.
% 
% 'Support'; 
% two-by-two matrix for
%                     bivariate data, where the first row contains the lower
%                     limits and the second row contains the upper limits.
% 
% Then do integral of points inside vs. outside density map; 