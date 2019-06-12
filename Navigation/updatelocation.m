function updatelocation()
global x y k d m phicar phitogoal dest;
k = k + 1; 
%[x(k) y(k)] location;
deltax = x(k) - dest(m,1);
deltay = y(k) - dest(m,2);
d(k) = sqrt((x(k) - dest(m,1))^2 + (y(k) - dest(m,2))^2);
phitogoal = atan2(deltay, deltax); %Angle from car to goal with x-axis 0 rad
if(k ~= 1) 
    phicar = atan2((x(k) - x(k - 1)), (y(k) - y(k-1))); %Angle of the direction of the car with x-axis on 0 rad
end