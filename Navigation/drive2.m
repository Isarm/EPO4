function drive2(destination, phicarstart)
r = 50; %Boogstraal van de auto wanneer hij maximaal stuurt in cm
tolinemargin = 5; %Little safety margin in case the system works to slow
x_des = linspace(0,400); %This is a line with al the x value that are in the field
global x y k d m phicar phitogoal dest; 
dest = destination; 
x = zeros(1000,1);
y = zeros(1000,1);
d = zeros(1000,1);
k = 0; %This is a loop paramater to store the driven directory
m = 1; %This is the loop parameter to indicate the current goal
updatelocation();
phicar = phicarstart;
EPOCommunications('transmit', 'M160');

while((m - size(dest,1)) ~= 0)
    EPOCommunications('transmit', 'D150')
    phigoaltosecondgoal = atan2(dest(m,2) - dest(m+1,2), dest(m,1) - dest(m+1,1)); 
    grade_desired = -tan(phitogoal/2 + phigoaltosecondgoal/2);
    y_desired = dest(m,2) + grade_desired*(x_des - dest(m,1)); 
    grade_car = tan(phicar);
    y_car = y(k) + grade_car * (x_des - x(k)); 
    x_intersection = polyxpoly(x_des, y_desired, x_des, y_car);
    y_intersection = dest(m,2) + grade_desired*(x_intersection - dest(m,1));
    if(phigoaltosecondgoal == pi/2)
        
    end
    if(phigoaltosecondgoal > pi/2)
        if(r >  sqrt((y_intersection - y(k))^2 + (x_intersection - x(k))^2)) 
            while(1)
              radius1_x = x(k) + r * cos(phicar + pi/2);
              radius1_y = y(k) + r * sin(phicar + pi/2);
              radius2_x = x(k) + r * cos(phicar - pi/2);
              radius2_y = y(k) + r * sin(phicar - pi/2);
              d_radius1 = sqrt((radius1_x - dest(m,1))^2 + (radius1_y - dest(m,2))^2);
              d_radius2 = sqrt((radius2_x - dest(m,1))^2 + (radius2_y - dest(m,2))^2);
              if(d_radius1 < d_radius2) 
                  toline = abs(-grade_desired * radius1_x + radius1_y + dest(m,1) * grade_desired - dest(m,2))/ sqrt(grade_desired^2 + 1);
              else
                  toline = abs(-grade_desired * radius1_x + radius1_y + dest(m,1) * grade_desired - dest(m,2))/ sqrt(grade_desired^2 + 1);
              end
              updatelocation();
              if(toline + tolinemargin > r)
                  break;
              end
            end
       elseif(phigoaltosecondgoal < pi/2) %Note that the box of the last challenge can be on one of this radii and then you're screwed so you must be able to find a way past that in some way.
            if(d > 3*r)
                r3radius1_x =  dest(m,1) + 3 * r * cos(phigoaltosecondgoal + pi/2);
                r3radius1_y =  dest(m,2) + 3 * r * sin(phigoaltosecondgoal + pi/2);
                r3radius2_x =  dest(m,1) + 3 * r * cos(phigoaltosecondgoal - pi/2);
                r3radius2_y =  dest(m,2) + 3 * r * sin(phigoaltosecondgoal - pi/2);
                d_3_radius1 = sqrt((r3radius1_x - x(k))^2 + (r3radius1_y - y(k))^2);
                d_3_radius2 = sqrt((r3radius2_x - x(k))^2 + (r3radius2_y - y(k))^2);
                if(d_3_radius1 < d_3_radius2)
                    drive() %Has to drive to radius 1.
                else
                    drive() %Has to drive to radius 2.
                end
            end
            if(d > 1.5*r)
                r1_5radius1_x =  dest(m,1) + 1.5 * r * cos(phigoaltosecondgoal + pi/2);
                r1_5radius1_y =  dest(m,2) + 1.5 * r * sin(phigoaltosecondgoal + pi/2);
                r1_5radius2_x =  dest(m,1) + 1.5 * r * cos(phigoaltosecondgoal - pi/2);
                r1_5radius2_y =  dest(m,2) + 1.5 * r * sin(phigoaltosecondgoal - pi/2);
                d_1_5_radius1 = sqrt((r1_5radius1_x - x(k))^2 + (r1_5radius1_y - y(k))^2);
                d_1_5_radius2 = sqrt((r1_5radius2_x - x(k))^2 + (r1_5radius2_y - y(k))^2);
                if(d_1_5_radius1 < d_1_5_radius2)
                    drive() %Has to drive to radius 1.
                else
                    drive() %Has to drive to radius 2.
                end
            end
       end
    drive()
    while (w==0)
    w = waitforbuttonpress;
    end
    m = m + 1;
end
drive(); %This is the drive to the finish
end

%{
function drive()
    global x y k d m phicar phitogoal dest;
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
    end
    EPOCommunications('transmit', 'M150')
end
%}
