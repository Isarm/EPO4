function Brake(D_tofinish, D_tostart, forward_x, forward_v,  forward_t, brake_x, brake_v, brake_t)
%{
forward_x = 
forward_v = 
forward_t =
brake_x = 
brake_v =
brake_t = 
w = waitforbuttonpress
%}
tic
Delay_estimate = 0.1;
d  = D_tostart - D_tofinish;
brake_calc = brake_x + (d - max(brake_x));

%Caluculate when to start braking
Brakestart = polyxpoly(forward_x(1:length(forward_v)), forward_v, brake_calc(1:length(brake_v)),brake_v);
time = polyxpoly([0 10], [Brakestart Brakestart], forward_t, forward_x);
time = time - Delay_estimate;
Brakingstart_corrected  = D_tostart - polyxpoly([0 500], [time time], forward_x, forward_t);

%Calculate when to stop braking
time_stop = max(brake_t) - Delay_estimate;
Brakestop = D_tostart - polyxpoly([0 500], [time_stop time_stop], brake_calc, brake_t);

toc
%Start driving
EPOCommunications('transmit', 'M165')
while(1)
    [sensor_R,sensor_L,~,~] = SensorDistance();
    if((sensor_R - sensorL) > 20)  
        sensor = max([sensor_R, sensor_L]);
    else
        sensor = sensor_L/2 + sensor_R/2;
    end
    if(sensor < Brakingstart_corrected)
        EPOCommunications('transmit', 'M138')
        break
    end
end

while(1)
    [sensor_R,sensor_L,~,~] = SensorDistance();
    if((sensor_R - sensorL) > 20)  
        sensor = max([sensor_R, sensor_L]);
    else
        sensor = sensor_L/2 + sensor_R/2;
    end
    if(sensor < Brakestop)
        EPOCommunications('transmit', 'M150')
        break
end
end





