

for i = 1:10
    theta = randn()*pi; 
    R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
    x_theta = abs(randn());
    y_theta = abs(randn());
    x = randn(100, 1)*x_theta; 
    y = randn(100, 1)*y_theta; 
    X = (R*[x y]')'; 
    figure; hold all; 
    plot_conf_ellipse(X(:, 1), X(:, 2))
end