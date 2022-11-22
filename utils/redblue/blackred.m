function c = blackred(m)
%REDBLUE    Shades of red and blue color map
%   REDBLUE(M), is an M-by-3 matrix that defines a colormap.
%   The colors begin with black to bright red.


if nargin < 1, m = size(get(gcf,'colormap'),1); end

% From [0 0 0] to [1 0 0]
r = (0:m-1)'/max(m-1,1);
g = zeros(length(r), 1); 
b = g; 

c = [r g b]; 

