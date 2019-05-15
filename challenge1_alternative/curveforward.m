function [x, timeaxisNew, v] = curveforward(accCurvePos , timeaxisNew, first, last)
    accCurvePos = accCurvePos(first:last);
    timeaxisNew = timeaxisNew(first:last);
    accCurvePos = accCurvePos - accCurvePos(1);
    x = accCurvePos .* -1;
    L = length(x) - 1;
    % Some data conversion functions need to be included
    x_delta = x(2:L)- x(1:L-1); 
    t_delta = timeaxisNew(2:L)- timeaxisNew(1:L-1);
    v_delta = x_delta ./ t_delta;
    L = length(v_delta);
    v = [0, ((v_delta(1:L-1)+ v_delta(2:L))./ 2)]; 
    timeaxisNew = timeaxisNew(1:length(v));
    x = x(1:length(v));
end





