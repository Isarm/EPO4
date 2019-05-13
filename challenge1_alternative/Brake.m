function Brake(D_beforewall, D_starttowall, forward_x, forward_v,  forward_t, brake_x, brake_v, brake_t)
d  = D_starttowall - D_beforewall
[Brakestart, time, time_2] = Brake_control(d, forward_x, forward_v,  forward_t, brake_x, brake_v, brake_t);
Delay_estimate = 0.03
EPOCommunications('transmit', 'M165')
pause(time - Delay_estimate)
EPOCommunications('transmit', 'M145')
pause(time_2)
EPOCommunications('transmit', 'M150')
end

%{
forward_x = 
forward_v = 
forward_t =
brake_x = 
brake_v =
brake_t = 
speed_forward = 
speed_brake = 
Delay estimate = 
%}




