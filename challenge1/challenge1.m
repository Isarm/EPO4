function challenge1(stopDistance)
%CHALLENGE1 Summary of this function goes here
%   Detailed explanation goes here

accDelay = 0;
interMeasurementDelay = 0;
clear x;
clear speed;
clear position;
clear sensor
clear delay 
clear realdelay
delay = [];
realdelay = [];

load('accCurve159.mat')
load('decCurve159.mat')

% speed = 159;
% s = int2str(speed); 
% signal = ['M',s]; 
EPOCommunications('transmit','M159');
clear speed


initial = 0;

while(1)
    tic
    [sensorL,sensorR,~,~] = sensorDistance1();
    sensor = sensorL/2+sensorR/2;
    if(sensor<350)
        break
    end
end


while(1)
    tic
    
    [sensorL,sensorR,~,~] = sensorDistance1()
    sensor = sensorL/2+sensorR/2

    
    if(initial)    
        x = [x sensor]
        if(x(end-1)-x(end)>0) % check if the position has been updated
            speed = [speed ((x(end-1)-x(end))/realdelay(end))] % assign speed if this is the case
        end
    else
        x = sensor
        initial = 1
        speed = 0
    end
    
    
    % find this speed in the acceleration curve
    speedIndex = find(accCurve >= speed(end));
    if isempty(speedIndex)
        actualSpeed = max(accCurve)
    else
        speedIndex = min(speedIndex);
    
        % the real speed will be a certain delay in this curve higher than the 
        % measured speed.
        actualSpeed = accCurve(speedIndex + accDelay)
    end
    
    
    % find this speed in the deceleration curve
    speedIndex = find(decCurve >= actualSpeed)
    
    if isempty(speedIndex)
        position = max(decPosCurve) - decPosCurve(end);
    else
        speedIndex = max(speedIndex);
    
        % now plug this 'time' into the decelaration position curve
        position = decPosCurve(speedIndex) - decPosCurve(end) % compensate for the curve offset.
    end
    
    
    % add a safety margin depending on the speed
    position = position + actualSpeed*interMeasurementDelay
    
    % add the stopping distance to this position
    position = position + stopDistance
               
    if(any(x(1:end)<position))
        EPOCommunications('transmit', 'D150')
        break
    end
    if isempty(delay)
        delay = toc
    else
        delay = [delay toc]
    end
    if(delay(end)<0.07)
        pause(0.07 - delay(end))
    end
    
    if isempty(realdelay)
        realdelay = toc
    else
        realdelay = [realdelay toc]
    end
end

