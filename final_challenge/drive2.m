function drive2(destination, phicarstart, startx, starty)
edgetresh =  60;
r = 50; %Boogstraal van de auto wanneer hij maximaal stuurt in cm
%tolinemargin = 5; %Little safety margin in case the system works to slow
 %This is a line with al the x value that are in the field
global x y k d z zz phicar phitogoal maxfield m dest refsignal refsignalStart lengthV eps;
for j = 1:size(destination,1)
    if(destination(j,1) == 0 && destination(j,2) == 0)
        j = j-1;
        break
    end
end
dest = destination(1:j,:);
maxfield = 460;
z = 0;
zz = 0;
x = zeros(1000,1);
x(1) = startx;
y = zeros(1000,1);
y(1) = starty;
d = zeros(1000,1);
k = 1; %This is a loop paramater to store the driven directory
m = 1; %This is the loop parameter to indicate the current goal
x_des = linspace(0,maxfield);
updatelocation(dest(m,1), dest(m,2),0);
phicar = phicarstart;


%% Student Group Data
Group = 'B10';
B = 'B4000';        %% Bit frequency;           %Standard: B5000
F = 'F12000';       %% Carrier frequency        %Standard: F10000
R = 'R1500';        %% Repitition Count         %Standard: R2500
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
    Acq_data = pa_wavrecord(1,nmics,T_meas*Fs,Fs);
    if(phitosecond > pi/2)
        if(y(k) > dest(m,1))
          refline = -refline;
        end
        grade_desired = tan(refline);
        if(grade_desired > 10^-10 && grade_desired < 10^10)
            y_desired = dest(m,2) + grade_desired*(x_des - dest(m,1)); 
            grade_car = tan(phicar);
            y_car = y(k) + grade_car * (x_des - x(k)); 
            x_intersection = polyxpoly(x_des, y_desired, x_des, y_car);
            if ~isempty(x_intersection)
                y_intersection = dest(m,2) + grade_desired*(x_intersection - dest(m,1));    
                if(edgetresh < x_intersection && x_intersection < (maxfield - edgetresh) && edgetresh < y_intersection && y_intersection < (maxfield - edgetresh))
                    drive(x_intersection, y_intersection)
                end
            end
        end
        drive(dest(m,1),dest(m,2));
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
                    drive(r3radius1_x, r3radius1_y) %Has to drive to radius 1.
                    updatelocation(dest(m,1),dest(m,2),0);
                elseif(edgetresh < r3radius2_x && r3radius2_x < (maxfield - edgetresh) && edgetresh < r3radius2_y && r3radius2_y < (maxfield - edgetresh))
                    drive(r3radius2_x, r3radius2_y) %Has to drive to radius 2.
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
                    drive(r1_5radius1_x, r1_5radius1_y) %Has to drive to radius 1
                elseif(edgetresh < r1_5radius2_x && r1_5radius2_x < (maxfield - edgetresh) && edgetresh < r1_5radius2_y && r1_5radius2_y < (maxfield - edgetresh))
                    drive(r1_5radius2_x, r1_5radius2_y) %Has to drive to radius 2.
                end
        end
    end
    drive(dest(m,1), dest(m,2))
    disp('Intermediate goal is reached')
    disp('Press Enter to continue')
    input('')
    m = m + 1;
end
drive(dest(m,1), dest(m,2)); %This is the drive to the finish
disp('Reached Final Destination')
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
