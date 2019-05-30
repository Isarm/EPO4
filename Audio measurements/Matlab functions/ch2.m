%Isar Meijer - 4722930
%Geert Jan Meppelink - 4692810
% EE2T11
% 20/3/2019

function [h] = ch2(x,y,Ny)
%channel estimation using the matched filter approach

y = y(:);
x = x(:);
szy = size(y);

y = [y;zeros(Ny-length(y),szy(2))];
y = y(1:Ny,:);
Nx = length(x); L = Ny - Nx + 1; 


xr = flipud(x);     % reverse the sequence x (assuming a col vector) 
h = filter(xr,1,y); % matched filtering 
h = h(Nx:end,:);    % skip the first Nx samples, so length(h) = L 
alpha = x'*x;       % estimate scale 
h = h./alpha;        % scale down
end