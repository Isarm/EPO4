function [sensorL,sensorR,delay, voltage] = sensorDistance1
%SENSORDISTANCE Summary of this function goes here
%   Detailed explanation goes here
tic
status = EPOCommunications('transmit','Sd');

rIndex = find(status == 'R');
newline = find(status == 10);

sensorL = str2int(status(4:newline(1)-1));
sensorR = str2int(status(rIndex+1:newline(2)-1));

status = EPOcommuncations('transmit', 'Sv');

voltage = str2int(status((find(status == 'VBATT')+2):(find(status == 10)-1))) ;
delay = toc;

end

