function Brake(D_beforewall, D_starttowall, forward_x, forward_v,  forward_t, brake_x, brake_v, brake_t)
%{
forward_x = 
forward_v = 
forward_t =
brake_x = 
brake_v =
brake_t = 
w = waitforbuttonpress
%}
d  = D_starttowall - D_beforewall;
[Brakestart, acceltime, braketime] = Brake_control(d, forward_x, forward_v,  forward_t, brake_x, brake_v, brake_t);
Delay_estimate = 0.03;
EPOCommunications('transmit', 'M165')
pause(acceltime - Delay_estimate)
EPOCommunications('transmit', 'M138')
pause(braketime)
EPOCommunications('transmit', 'M150')
end






