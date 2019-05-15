function [Brakestart, acceltime, braketime] = brakecontrol(d, forward_x, forward_v,  forward_t, brake_x, brake_v, brake_t)
%Calculate the drive time and stop time
shift_amount = max(brake_x) - d;
brake_calc = brake_x - shift_amount;
plot(forward_x(1:length(forward_v)), forward_v, brake_calc(1:length(brake_v)),brake_v)
Brakestart = polyxpoly(forward_x(1:length(forward_v)), forward_v, brake_calc(1:length(brake_v)),brake_v);


%Find the time acceleration time
acceltime = polyxpoly(forward_t, forward_x,[0 10],  [Brakestart, Brakestart]); %Time to stop accelerating is the intersection of the x,t-curve with the line x = Brakestart


%Find the braking time
Stopdistance = d - Brakestart;
braketime = polyxpoly(brake_t, brake_x,[0 10],  [brake_x(end) - Stopdistance, brake_x(end) - Stopdistance]);

end

