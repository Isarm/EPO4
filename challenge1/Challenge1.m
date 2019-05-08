function Challenge1(stopDistance)
%CHALLENGE1 Summary of this function goes here
%   Detailed explanation goes here

accDelay = 0;
interMeasurementDelay = 0;

speed = '160';
s = int2str(speed); 
signal = ['D',d]; 
EPOCommunications('transmit',signal);

while(1)
    [sensorL,sensorR,~] = SensorDistance();
    sensor = sensorL/2+sensorR/2;
    if(sensor<270)
        break
    end
end


while(1)
    [sensorL,sensorR,~] = SensorDistance();
    sensor = sensorL/2+sensorR/2;
    x = [x sensor];
    
    if(x(end)-x(end-1)>0) % check if the position has been updated
        speed = [speed (x(end)-x(end-1))]; % assign speed if this is the case
    end
    
    % find this speed in the acceleration curve
    speedIndex = find(accCurve >= speed(end));
    speedIndex = min(speedIndex);
    
    % the real speed will be a certain delay in this curve higher than the 
    % measured speed.
    actualSpeed = accCurve(speedIndex + accDelay);
    
    % find this speed in the deceleration curve
    speedIndex = find(decCurve >= actualSpeed);
    speedIndex = max(speedIndex);
    
    % now plug this 'time' into the decelaration position curve
    position = decPosCurve(speedIndex);
    
    % add a safety margin depending on the speed
    position = position + actualSpeed*interMeasurementDelay;
    
    % add the stopping distance to this position
    position = position + stopDistance;
               
    if(any(x(end-5:end)<position))
        EPOCommunications('transmit', 'D150');
        break
    end
end

