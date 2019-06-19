function [interx, intery, wallfound] =wallfinder(locationx, locationy, firstpointx, firstpointy, angle)
    [sensorleft, sensorright, delay, voltage] = sensorDistance();
    walldistance = min(sensorleft, sensorright)
%     walldistance = 100;
    x_coordinate = locationx + walldistance*cos(angle);
    y_coordinate = locationy + walldistance*sin(angle);
    if(min(x_coordinate,y_coordinate) > 0) && (max(x_coordinate,y_coordinate) < 460) && (walldistance > 10)
        wallx = x_coordinate;
        wally = y_coordinate;
        wallfound=1;
        radius = 48 + 38;
        for k = 1:20
            forbidden_areax(k) = wallx+ radius*cos(2*pi*k/19);
            forbidden_areay(k) = wally+ radius*sin(2*pi*k/19);
        end
        lookangle1 = angle +0.5*pi;
        lookangle2 = angle - 0.5*pi;
        interx1 = wallx + radius*cos(lookangle1);
        intery1 = wally + radius*sin(lookangle1);
        interx2 = wallx + radius*cos(lookangle2);
        intery2 = wally + radius*sin(lookangle2);
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
        if walldistance < 100
        signal = ['M','140'];
        EPOCommunications('transmit',signal);
        pause(2);
        signal = ['M','150'];
        EPOCommunications('transmit',signal);
        end
% plot(forbidden_areax, forbidden_areay, 'm');
% plot([interx1 interx2],[intery1 intery2], 'b-x', 'Markersize',20);
% plot(wallx, wally, 'k x','Markersize',10 ,'Linewidth', 3)
    else
        wallfound =0;
        interx = 0;
        intery = 0;
    end
end
