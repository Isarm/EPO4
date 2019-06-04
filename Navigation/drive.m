function drive(goalx, goaly, phicar)
[xnew ynew] location();
x = [xnew];
y = [ynew];
EPOcommunications('transmit', 'M150')
while(1)
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
phi = phitogoal - phicar; % Difference in angle (positive stering to the left is needed and negative correcting by steering right is needed

if d > 30 %Hij stuurt niet meer dichtbij de target
if phi > 0.15 %Minimale angle voordat ie gaat sturen
    EPOCommunications('transmit','D175')
elseif phi > pi/2    
    EPOCommunications('transmit','D200') 
elseif phi < -0.15 %Minimale angle voordat ie gaat sturen
    EPOCommunications('transmit','D100') 
end
end


end

end