function drive2(destination, phicarstart, startx, starty, challenge3)
edgetresh =  60;
r = 50; %Boogstraal van de auto wanneer hij maximaal stuurt in cm
%tolinemargin = 5; %Little safety margin in case the system works to slow
 %This is a line with al the x value that are in the field
global x y k d phicar phitogoal maxfield m dest refsignal refsignalStart lengthV eps;
load('SingleReference.mat');
for j = 1:size(destination,1)
    if(destination(j,1) == 0 && destination(j,2) == 0)
        j = j-1;
        break
    end
end
dest = destination(1:j,:);
maxfield = 460;
x = zeros(1000,1);
x(1) = startx;
y = zeros(1000,1);
y(1) = starty;
d = zeros(1000,1);
k = 1; %This is a loop paramater to store the driven directory
m = 1; %This is the loop parameter to indicate the current goal
x_des = linspace(0,maxfield);
updatelocation(dest(m,1), dest(m,2),0);
phicar(k) = phicarstart;

%% Student Group Data
Group = 'B10';
B = 'B4000';        %% Bit frequency;           %Standard: B5000
F = 'F12000';       %% Carrier frequency        %Standard: F10000
R = 'R1000';        %% Repitition Count         %Standard: R2500
C = 'C0xD1485066';   %% Audio code               %Standard: C0xaa55aa55

%% Set-up Car
%EPOCommunications('open',Port);
EPOCommunications('transmit',B);
EPOCommunications('transmit',F);
EPOCommunications('transmit',R);
EPOCommunications('transmit',C);
EPOCommunications('transmit','A1');
pause(0.2);

while((size(dest,1) - m) ~= 0)
    EPOCommunications('transmit', 'D150')
    phitosecond = angle3points(x(k), y(k), dest(m+1,1), dest(m+1,2), dest(m,1), dest(m,2));
    %        refline = phitosecond /2 + phigoaltosecondgoal(x(k), y(k), maxfield, dest(m,2), dest(m,1), dest(m,2));
    phigoaltosecondgoal = atan2(dest(m+1,2) - dest(m,2), dest(m+1,1) - dest(m,1));
    phimiddlecarsecondgoal = phigoaltosecondgoal/2 + phitogoal/2;
    A = [abs(phigoaltosecondgoal - phimiddlecarsecondgoal + pi), abs(phigoaltosecondgoal - phimiddlecarsecondgoal), abs(phigoaltosecondgoal - phimiddlecarsecondgoal - pi) ; (phigoaltosecondgoal - phimiddlecarsecondgoal + pi) ,(phigoaltosecondgoal - phimiddlecarsecondgoal),(phigoaltosecondgoal - phimiddlecarsecondgoal - pi)]; 
    [~,c] = min(A(1,:));
    refline = A(2,c);
    if(phitosecond > pi/2)
        if(y(k) > dest(m,1))
          refline = -refline;
        end
        grade_desired = tan(refline);
        if(grade_desired > 10^-10 && grade_desired < 10^10)
            y_desired = dest(m,2) + grade_desired*(x_des - dest(m,1)); 
            grade_car = tan(phicar(k));
            y_car = y(k) + grade_car * (x_des - x(k)); 
            x_intersection = polyxpoly(x_des, y_desired, x_des, y_car);
            if ~isempty(x_intersection)
                y_intersection = dest(m,2) + grade_desired*(x_intersection - dest(m,1));    
                if(edgetresh < x_intersection && x_intersection < (maxfield - edgetresh) && edgetresh < y_intersection && y_intersection < (maxfield - edgetresh))
                    [wallfound] = drive(x_intersection, y_intersection, challenge3);
                    if(wallfound == 1)
                        continue
                    end
                end
            end
        end
        [wallfound] = drive(dest(m,1),dest(m,2), challenge3);
        if(wallfound == 1)
            continue
        end
    elseif(phitosecond <= pi/2) %Note that the box of the last challenge can be on one of this radii and then you're screwed so you must be able to find a way past that in some way.
        if(d(k) > 3*r)
            refline = -refline; %NOTE: Is alleen goed in enkel geval
                r3radius1_x =  dest(m,1) + 3 * r * cos(refline + pi/2);
                r3radius1_y =  dest(m,2) + 3 * r * sin(refline + pi/2);
                r3radius2_x =  dest(m,1) + 3 * r * cos(refline - pi/2);
                r3radius2_y =  dest(m,2) + 3 * r * sin(refline - pi/2);
                d_3_radius1 = sqrt((r3radius1_x - x(k))^2 + (r3radius1_y - y(k))^2);
                d_3_radius2 = sqrt((r3radius2_x - x(k))^2 + (r3radius2_y - y(k))^2);
                if(d_3_radius1 < d_3_radius2 && edgetresh < r3radius1_x && r3radius1_x < (maxfield - edgetresh) && edgetresh < r3radius1_y && r3radius1_y < (maxfield - edgetresh) )  
                    [wallfound] = drive(r3radius1_x, r3radius1_y, challenge3); %Has to drive to radius 1.
                    if(wallfound == 1)
                        continue
                    end
                    updatelocation(dest(m,1),dest(m,2),0);
                elseif(edgetresh < r3radius2_x && r3radius2_x < (maxfield - edgetresh) && edgetresh < r3radius2_y && r3radius2_y < (maxfield - edgetresh))
                    [wallfound] = drive(r3radius2_x, r3radius2_y, challenge3); %Has to drive to radius 2.
                    if(wallfound == 1)
                        continue
                    end
                    updatelocation(dest(m,1),dest(m,2),0);
                end
        end
        if(d(k) > 1.5*r)
                r1_5radius1_x =  dest(m,1) + 1.5 * r * cos(refline + pi/2);
                r1_5radius1_y =  dest(m,2) + 1.5 * r * sin(refline + pi/2);
                r1_5radius2_x =  dest(m,1) + 1.5 * r * cos(refline - pi/2);
                r1_5radius2_y =  dest(m,2) + 1.5 * r * sin(refline - pi/2);
                d_1_5_radius1 = sqrt((r1_5radius1_x - x(k))^2 + (r1_5radius1_y - y(k))^2);
                d_1_5_radius2 = sqrt((r1_5radius2_x - x(k))^2 + (r1_5radius2_y - y(k))^2);
                if(d_1_5_radius1 < d_1_5_radius2 && edgetresh < r1_5radius1_x && r1_5radius1_x < maxfield - edgetresh && edgetresh < r1_5radius1_y && r1_5radius1_y < (maxfield - edgetresh))
                    [wallfound] = drive(r1_5radius1_x, r1_5radius1_y, challenge3); %Has to drive to radius 1
                    if(wallfound == 1)
                        continue
                    end
                elseif(edgetresh < r1_5radius2_x && r1_5radius2_x < (maxfield - edgetresh) && edgetresh < r1_5radius2_y && r1_5radius2_y < (maxfield - edgetresh))
                    [wallfound] = drive(r1_5radius2_x, r1_5radius2_y, challenge3); %Has to drive to radius 2.
                    if(wallfound == 1)
                        continue
                    end
                end
        end
    end
    [wallfound] = drive(dest(m,1), dest(m,2), challenge3);
    if(wallfound == 1)
        drive(dest(m,1), dest(m,2), challenge3);
    end
    disp('Intermediate goal is reached')
    disp('Press Enter to continue')
    input('')
    m = m + 1;
end
[wallfound] = drive(dest(m,1), dest(m,2), challenge3); %This is the drive to the finish
if(wallfound == 1)
    drive(dest(m,1), dest(m,2), challenge3);
end
disp('Reached Final Destination')
end


