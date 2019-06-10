function drive2(dest, phicar)
r = 50; %Boogstraal van de auto wanneer hij maximaal stuurt in cm
tolinemargin = 5; %Little safety margin in case the system works to slow
global x y k d l; 
x = zeros(1000,1);
y = zeros(1000,1);
d = zeros(1000,1);
k = 0; %This is a loop paramater to store the driven directory
l = 1; %This is the loop parameter to indicate the current goal
updatelocation();
deltay = y(k) - goaly;
deltax = x(k) - goalx;
d(k) = sqrt(deltay^2 + deltax^2);  %Distance from car to the goal
phitogoal = atan2(deltay, deltax); %Angle from car to goal with x-axis 0 rad
EPOcommunications('transmit', 'M160');

while((l - length(destinations)) ~= 0)
    EPOCommunications('transmit', 'D150')
    phigoaltosecondgoal = atan2(dest(2:k) - des(2:k+1),dest(1:k) - des(1:k+1)); 
    grade_desired = -arctan(phitogoal/2 + phigoaltosecondgoal/2); %Phi to goal klopt niet moet eigenlijk van goal 2 naar goal 1 zijn
    x_des = linespace(0,4);
    y_desired = dest(2:l) + grade_desired(x - dest(1:l)); 
    grade_car = arctan(phicar);
    y_car = y(k) + grade_car(x_des - x(k)); 
    x_intersection = polyxpoly(x_des, y_desired, x_des, y_car);
    
    if(r >  sqrt((y_car(x_intersection) - y(k))^2 + (x_intersection - x(k))^2)) 
    while(1)
      radius1_x = x(k) + r * cos(phicar + pi/2);
      radius1_y = y(k) + r * sin(phicar + pi/2);
      radius2_x = x(k) + r * cos(phicar - pi/2);
      radius2_y = y(k) + r * sin(phicar - pi/2);
      d_radius1 = sqrt((radius1_x - dest(1:l))^2 + (radius1_y - dest(2:l))^2);
      d_radius2 = sqrt((radius2_x - dest(1:l))^2 + (radius2_y - dest(2:l))^2);
      if(d_radius1 < d_radius2) 
          toline = abs(-grade_desired * radius1_x + radius1_y + dest(1:l) * grade_desired - dest(2:l))/ sqrt(grade_desired^2 + 1);
      else
          toline = abs(-grade_desired * radius1_x + radius1_y + dest(1:l) * grade_desired - dest(2:l))/ sqrt(grade_desired^2 + 1);
      end
      updatelocation();
      if(toline + tolinemargin > r)
          break;
      end
    end
    end
    drive()
    w = waitforbuttonpress;
    l = l + 1;
end
drive() %This is the drive to the finish
end

    
function drive()
global x y k d l;
while(d(k) > 30)
    %Correct steering - if you don't correct steering the car may choose to
    %take a lager corner for instance 1.8pi instead of 0.2pi. Therefore you
    %have to extend the circle so that it can choose the shortest corner.
    Phi_nocorrection = phitogoal - phicar; % Difference in angle (positive stering to the left is needed and negative correcting by steering right is needed
    A = [abs(Phi_nocorrection) abs(Phi_nocorrection + 2*pi) abs(Phi_nocorrection - 2*pi); Phi_nocorrection, (Phi_nocorrection + 2*pi), (Phi_nocorrection - 2*pi)];
    [~,c] = min(A(1,:));
    phi = A(2,c); %So it takes the angle with the absolute minimum value, but with this rule it keeps the sign of the value which is needed to know whether you must steer to the right or to the left.
        
    %Send steering signals
        %Minimale angle voordat ie gaat sturen
    if 0.15 > phi && phi < 0.35  %~5 graden 
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
    updatelocation();
   
    
    %Find the variables from the car to the goal
    deltay = y(k) - goaly;
    deltax = x(k) - goalx;
    d(k) = sqrt(deltay^2 + deltax^2);  %Distance from car to the goal
    phitogoal = atan2(deltay, deltax); %Angle from car to goal with x-axis 0 rad
    phicar = atan2((x(k) - x(k - 1)), (y(k) - y(k-1))); %Angle of the direction of the car with x-axis on 0 rad
end
EPOCommunications('transmit', 'M150')
end

function updatelocation()
global x y k d l;
k = k + 1;
%[x(k) y(k)] location;
d(k) = sqrt((x(k) - dest(1:l))^2 + (y(k) - dest(2:l))^2);
end