function drive(goalx, goaly, phicar)
x = zeros(1000,1);
y = zeros(1000,1);
d = zeros(1000,1);
k = 1;
[x(k) y(k)]location();
deltay = y(k) - goaly;
deltax = x(k) - goalx;
d(k) = sqrt(deltay^2 + deltax^2);  %Distance from car to the goal
phitogoal = atan2(deltay, deltax); %Angle from car to goal with x-axis 0 rad
EPOcommunications('transmit', 'M160')

while(d(k) > 30)
    k = k+1;
    %Correct steering - if you don't correct steering the car may choose to
    %take a lager corner for instance 1.8pi instead of 0.2pi. Therefore you
    %have to extend the circle so that it can choose the shortest corner.
    Phi_nocorrection = phitogoal - phicar; % Difference in angle (positive stering to the left is needed and negative correcting by steering right is needed
    A = [abs(Phi_nocorrection) abs(Phi_nocorrection + 2*pi) abs(Phi_nocorrection - 2*pi); Phi_nocorrection, (Phi_nocorrection + 2*pi), (Phi_nocorrection - 2*pi)];
    [~,c] = min(A(1,:));
    phi = A(2,c); %So it takes the angle with the absolute minimum value, but with this rule it keeps the sign of the value which is needed to know whether you must steer to the right or to the left.
        
    %Send steering signals
    if 0.15 > phi && phi < 0.35 < %~5 graden  %Minimale angle voordat ie gaat sturen
    EPOCommunications('transmit','D180')
    elseif phi > 0.35 % ~20 graden
    EPOCommunications('transmit','D200')
    elseif phi < -0.15 && phi > -0.35 %Minimale angle voordat ie gaat sturen
    EPOCommunications('transmit','D120')
    elseif phi < -0.35 %Minimale angle voordat ie gaat sturen
    EPOCommunications('transmit','D100') 
    else
    EPOCommunications('transmit','D150')
    end
    [x(k) y(k)]location();
   
    
    %Find the variables from the car to the goal
    deltay = y(k) - goaly;
    deltax = x(k) - goalx;
    d(k) = sqrt(deltay^2 + deltax^2);  %Distance from car to the goal
    phitogoal = atan2(deltay, deltax); %Angle from car to goal with x-axis 0 rad
    phicar = atan2((x(k) - x(k - 1)), (y(k) - y(k-1))); %Angle of the direction of the car with x-axis on 0 rad
end
EPOCommunications('transmit', 'M150')
end