%Isar Meijer - 4722930
%Geert Jan Meppelink - 4692810
% EE2T11
% 20/3/2019

function [h] = ch1(x,y,Ny)
%channel estimation using matrix inversion in time domain

y = transpose(y(:));
x = transpose(x(:));

y = [y zeros(1,Ny-length(y))];
y = y(1:Ny);

toepX = toep(x, Ny, Ny-length(x)+1);
h = pinv(toepX)*transpose(y);
end

