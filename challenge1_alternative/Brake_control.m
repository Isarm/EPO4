function [Brakestart, time, time_2] = brakecontrol(d, forward_x, forward_v,  forward_t, brake_x, brake_v, brake_t)
%Calculate the drive time and stop time
shift_amount = max(brake_x) - d;
brake_calc = brake_x - shift_amount;
plot(forward_x(1:length(forward_v)), forward_v, brake_calc(1:length(brake_v)),brake_v)
Brakestart = polyxpoly(forward_x(1:length(forward_v)), forward_v, brake_calc(1:length(brake_v)),brake_v)


%Find the Braketime
low = int16(0); high = int16(length(forward_x));
while(low ~= high)
    mid = int16((low + high) / 2);
    if forward_x(mid) < Brakestart
        low = mid;
    else
        high = mid-1;
    end
end
time = forward_t(high); %or forward_time(low) they're equal
time_2 = brake_t(end) - brake_t(high)
end

