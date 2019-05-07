%Authors: Folkert de Ronde (4591852) & Youri Blom (4694147)
%Date: 26-02-2019
%ch2
%This function can reconstruct the transfer function

function [h] = ch2(x,y)
Ny = length(y);         %Length of the output signal
Nx = length(x);         %Length of the input signal
L = Ny - Nx + 1;        %Length of the transfer function

%x and y are made to colomn vectors
x = x(:);
y = y(:);

%xr is the x reversed
xr = flipud(x);
h = filter(xr,1,y);
h = h(Nx:end);
alpha = x'*x;
h = h/alpha;
end

