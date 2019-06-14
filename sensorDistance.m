function [sensorL,sensorR,delay, voltage] = sensorDistance()
%SENSORDISTANCE Summary of this function goes here
%   Detailed explanation goes here
tic
status = EPOCommunications('transmit','Sd');

rIndex = find(status == 'R');
newline = find(status == 10);

sensorL = str2double(status(4:newline(1)-1));
sensorR = str2double(status(rIndex+1:newline(2)-1));

status = EPOCommunications('transmit', 'Sv');

% VIndex = find(status == 'VBATT');
% newline = find(status == 10);

voltage = str2double(status(6:9)) ;

delay = toc;
end