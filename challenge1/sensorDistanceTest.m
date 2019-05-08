function [sensorL,sensorR,delay] = sensorDistanceTest(reset)
%SENSORDISTANCETEST Summary of this function goes here
%   Detailed explanation goes here
persistent i;
persistent q;

if (isempty(i)||reset)
    i = 250;
end
if (isempty(q)||reset)
    q = 1;
end



delay = 0;
sensorL = i;
sensorR = i;
i = i-q;

q = q+1;

end

