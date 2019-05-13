function [x, t, v] = curveforward(sensorleft , sensorright, t, first, last)
    meas_x = (sensorleft + sensorright) ./ 2;
    meas_x = meas_x(first:last);
    t = t(first:last);
    for k = 2: length(t)
        t(k) = t(k) + t(k-1)
    end

    meas_x = meas_x - meas_x(1);
    x = meas_x .* -1;
    L = length(x) - 1;
    % Some data conversion functions need to be included
    x_delta = x(2:L)- x(1:L-1); 
    t_delta = t(2:L) - t(1:L-1);
    v_delta = x_delta ./ t_delta;
    L = length(v_delta);
    v = [0, ((v_delta(1:L-1)+ v_delta(2:L))./ 2)]; 
    t = t(1:length(v));
    x = x(1:length(v));
end





