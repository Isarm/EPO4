function [brake_t, brake_x, brake_v] = curvereverse(decPosCurve, t, first, last)
    decPosCurve = decPosCurve - decPosCurve(1);
    decPosCurve = decPosCurve(first:last);
    t = t(first:last);
    
    
    x = decPosCurve  .* -1;
    L = length(x) - 1;
    
    
    % Some data conversion functions need to be included
    x_delta = x(2:L) - x(1:L-1);
    t_delta = t(2:L)- t(1:L-1);
    v_delta = abs(x_delta ./ t_delta);
    L = length(v_delta);
    brake_v = [2.1*v_delta(2) - 1.1*v_delta(3),((v_delta(1:L-1)+v_delta(2:L))./ 2), 0]; 
    brake_x = x(1:length(brake_v));
    brake_t = t(1:length(brake_v));
    
end


