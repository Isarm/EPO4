%Isar Meijer - 4722930
%Geert Jan Meppelink - 4692810
% EE2T11
% 20/3/2019

function [h] = ch3(x,y,eps)
%channel estimation using frequency domain deconvolution

y= y(:);
x=x(:);
Ny = length(y); 
Nx = length(x); 
L = Ny - Nx + 1; 
Y = fft([y; zeros(Nx-Ny,1)]); 
X = fft([x; zeros(Ny - Nx ,1)]); % zero padding to length Ny

% eps = eps*abs(max(X));
H = Y ./ X; % frequency domain deconvolution 
ii = find(abs(X)<eps);
H(ii) = 0;


%H = H(:,2);

h = ifft(H); 
h = real(h);
end