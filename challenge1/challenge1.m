function challenge1(stopDistance)
%CHALLENGE1 Summary of this function goes here
%   Detailed explanation goes here


clear x;
clear speed;
clear position;
clear sensor
clear delay 
clear realdelay
delay = [];

realdelay = [];

debug = 0;

% if(debug == 1)
%     global sensor
%     global delay
%     global speed
%     global sensorL
%     global sensorR
%     global x
%     global actualSpeed
%     global position
%     global realdelay
% end



accDelay = 0;
interMeasurementDelay = 0.35;


load('accCurve165.mat')
load('decCurve165.mat')

% speed = 159;
% s = int2str(speed); 
% signal = ['M',s]; 
EPOCommunications('transmit','M165');
clear speed


initial = 0;

while(1)
    tic
    [sensorL,sensorR,~,~] = sensorDistance();
    sensor = sensorL/2+sensorR/2;
    if(sensor<350)
        break
    end
end


while(1)
    tic
    
    [sensorL,sensorR,~,~] = sensorDistance();
    sensor = sensorL/2+sensorR/2;

    
    if(initial)    
        x = [x sensor];
        if(x(end-1)-x(end)>0) % check if the position has been updated
            speed = [speed ((x(end-1)-x(end))/realdelay(end))]; % assign speed if this is the case
            speed(end)
        end
    else
        x = sensor;
        initial = 1;
        speed = 0;
    end
    
    
    % find this speed in the acceleration curve
    speedIndex = find(accCurve >= speed(end));
    if isempty(speedIndex)
        actualSpeed = max(accCurve);
    else
        speedIndex = min(speedIndex);;
    
        % the real speed will be a certain delay in this curve higher than the 
        % measured speed.
        if(speedIndex+accDelay<length(accCurve))
            actualSpeed = accCurve(speedIndex + accDelay);
        end
    end
    
    
    % find this speed in the deceleration curve
    speedIndex = find(decCurve >= actualSpeed);
    
    if isempty(speedIndex)
        position = max(decPosCurve) - decPosCurve(end);
    else
        speedIndex = max(speedIndex);
    
        % now plug this 'time' into the decelaration position curve
        position = decPosCurve(speedIndex) - decPosCurve(end); % compensate for the curve offset.
    end
    
    
    % add a safety margin depending on the speed
    position = position + actualSpeed*interMeasurementDelay
    
    % add the stopping distance to this position
    position = position + stopDistance;
               
    if(any(x(1:end)<position))
        brake = 1;
        EPOCommunications('transmit', 'M145');
        break
    end
    if isempty(delay)
        delay = toc;
    else
        delay = [delay toc];
    end
    if(delay(end)<0.07)
        pause(0.07 - delay(end));
    end
    
    if isempty(realdelay)
        realdelay = toc;
    else
        realdelay = [realdelay toc];
    end
end

