function [sensorL,sensorR,delay, voltage] = sensorDistance1
%SENSORDISTANCE Summary of this function goes here
%   Detailed explanation goes here
tic
status = EPOCommunications('transmit','Sd');

rIndex = find(status == 'R');
newline = find(status == 10);

sensorL = status(4:newline(1)-1);
sensorR = status(rIndex+1:newline(2)-1);
voltage = 0;
delay = toc;

end

