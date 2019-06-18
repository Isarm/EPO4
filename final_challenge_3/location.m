%{
function [xnew , ynew] = location() 
global x y k z zz phicar
xnew = x(k-1) + z * 20 * cos(phicar + zz*pi/32);
ynew = y(k-1) + z * 20 * sin(phicar + zz*pi/32);
zz = 0;
z = 0;
end
%}