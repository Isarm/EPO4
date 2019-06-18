function [interx, intery, wallfound] = wallfinder(locationx, locationy, firstpointx, firstpointy, angle)
    [sensorleft, sensorright, delay, voltage] = sensorDistance();
    walldistance = min(sensorleft, sensorright)
    x_coordinate = locationx + walldistance*cos(angle);
    y_coordinate = locationy + walldistance*sin(angle);
    if(min(x_coordinate,y_coordinate) > 0) && (max(x_coordinate,y_coordinate) < 460)
        wallx = x_coordinate;
        wally = y_coordinate;
        wallfound = 1;
        radius = 48 + 38;
        for k = 1:20
            forbidden_areax(k) = wallx+ radius*cos(2*pi*k/19);
            forbidden_areay(k) = wally+ radius*sin(2*pi*k/19);
        end
        lookangle1 = angle +0.5*pi;
        lookangle2 = angle - 0.5*pi;
        interx1 = wallx + 48*cos(lookangle1);
        intery1 = wally + 48*sin(lookangle1);
        interx2 = wallx + 48*cos(lookangle2);
        intery2 = wally + 48*sin(lookangle2);
        distance1 = sqrt((firstpointx - interx1)^2+(firstpointy - intery1)^2);
        distance2 = sqrt((firstpointx - interx2)^2+(firstpointy - intery2)^2);
        if (min(interx1, intery1) < 0) && (max(interx1, intery1) > 460)
            interx = interx2;
            intery = intery2;
        elseif (min(interx2, intery2) < 0) && (max(interx2, intery2) > 460)
            interx = interx1;
            intery = intery1;
        elseif (distance1 < distance2)
             interx = interx1;
            intery = intery1;
        else
            interx = interx2;
            intery = intery2;
        end
        signal = ['M','140'];
        EPOCommunications('transmit',signal);
        wait(0.5);
        EPOCommincatios('transmit', 'M150')
    else
        wallfound =0;
        interx = 0;
        intery = 0;
    end
end
