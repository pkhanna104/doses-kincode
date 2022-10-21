function test_result = plot_conf_ellipse(ax, x_og, y_og, col, test_x, test_y)

% Make sure column matrices
assert(size(x_og, 2) == 1)
assert(size(y_og, 2) == 1)

% Calculate mean 
X0 = mean(x_og);
Y0 = mean(y_og);

% Subtract mean 
x = x_og - X0; 
y = y_og - Y0; 

test_x = test_x - X0; 
test_y = test_y - Y0; 

% Get out orientation radius;
loadings = PCA([x, y]); 

% Angle of ellipse
theta =-atan(loadings(2,1)/loadings(1,1));

% Make rotation matrix based on this angle
R = [cos(theta) -sin(theta);
     sin(theta)  cos(theta)]; 

% Un-rotate the data to find sigmaX/sigmaY
X_unrot = (R*[x, y]')'; 

%https://www.visiondummy.com/2014/04/draw-error-ellipse-representing-covariance-matrix/
x_dem = std(X_unrot(:, 1))*sqrt(5.991); 
y_dem = std(X_unrot(:, 2))*sqrt(5.991); 

% Plot the ellipse
x_e_opts = -x_dem:.01:x_dem; 

% Get coordinates of the ellipse 
x_e = []; y_e = []; 
for i=1:length(x_e_opts)
    xi = x_e_opts(i); 
    x_e = [x_e; xi xi];

    y1 = y_dem*sqrt(1 - ((xi/x_dem).^2)); 
    y2 = -1*y_dem*sqrt(1 - ((xi/x_dem).^2)); 
    y_e = [y_e; y1 y2];
end

rev_ix = size(x_e, 1):-1:1; 
E = [x_e(:,1) y_e(:, 1); x_e(rev_ix,2) y_e(rev_ix,2)]; 

% Rotate the coordinates 
R_e = (R'*E')'; 
R_e(:, 1) = R_e(:, 1) + X0; 
R_e(:, 2) = R_e(:, 2) + Y0;

% Plot the coordinates 
plot(ax, R_e(:,1), R_e(:,2), '-', 'Color', col);

% Test out which points are inside vs outside the ellipse

% Rotate points: 
X_R_test = (R*[test_x test_y]')';

test_result = []; 
N = length(test_x); 

for n = 1:N
    if ((X_R_test(n, 1)/x_dem).^2 + (X_R_test(n, 2)/y_dem).^2) <= 1
        test_result = [test_result 0]; 
    else
        test_result = [test_result 1]; 
    end
end

end

function loadings = PCA(X)

    % Make sure demeaned 
    assert(abs(mean(X(:, 1))) < 1e-12)
    assert(abs(mean(X(:, 2))) < 1e-12)
    
    % Get covariance matrix 
    C = X'*X; 

    % Get eigenvalues/vectors 
    % H is diag matrix of eigenvectors
    % V columns eigenvectors 
    [eigVect, eigVals] = eig(C); 

    % Sort by eigenvalue 
    [~, ix] = sort(diag(eigVals), 'descend'); 

    % Get eigenvectors out 
    loadings = eigVect(:, ix); 
    
end



    


    