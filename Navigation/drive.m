function drive(goalx, goaly, phicar)
[xnew ynew] location();
x = [xnew];
y = [ynew];
EPOcommunications('transmit', 'M160')
while(d > 30)
    [xnew ynew] location();
    x = [x, xnew];
    y = [y, ynew];
    %Find the variables from the car to the goal
    deltay = y(end) - goaly;
    deltax = x(end) - goalx;

    d = sqrt(deltay^2 + deltax^2);  %Distance from car to the goal
    phitogoal = atan2(deltay, deltax); %Angle from car to goal with x-axis 0 rad
    phicar = atan2((x(end) - x(end - 1)), (y(end) - y(end-1))); %Angle of the direction of the car with x-axis on 0 rad

    %Correct steering
    phi1 = phitogoal - phicar; % Difference in angle (positive stering to the left is needed and negative correcting by steering right is needed
    phi2 = phitogoal - phicar + 2*pi;
    phi3 = phitogoal - phicar - 2*pi;
    A = [abs(phi1) abs(phi2) abs(phi3); phi1, phi2, phi3];
    [~,c] = min(angle(A(1,:)
    phi = A(2,c); %So it takes the angle with the absolute minimum value. This could otherwise lead to an error if the goal is at -0.8pi and the car to 0.8pi. Withouth this correction it would take the angle over 1.6 left instead of the faster 0.4 pad to right
   
    
    if d > 30 %Hij stuurt niet meer dichtbij de target
        if phi > 0.15 %Minimale angle voordat ie gaat sturen
        EPOCommunications('transmit','D200')
        elseif phi < -0.15 %Minimale angle voordat ie gaat sturen
        EPOCommunications('transmit','D100') 
        else
        EPOCommunications('transmit','D150')
        end
    end
end
EPOCommunications('transmit', 'M150')
end