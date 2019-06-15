function updatelocation(goalx, goaly, q)
global x y k d phicar phitogoal maxfield dest m refsignal refsignalStart lengthV eps;
Tr = 0.5;
Fs = 48000;
mic = [2.3, -2.3; -2.3, -2.3; -2.3, 2.3; 2.3, 2.3; 0, 2.3];
mic3D = [2.3, -2.3,0.5; -2.3, -2.3,0.5; -2.3, 2.3,0.5; 2.3, 2.3,0.5; 0, 2.3,0.8];
nmics = 5;
T_meas = 3;  
o = 0; 
n = 0;

location_error_in_error = 5; %Maxium allowed distance if multiple measurements are done
dist_between_points = 30; %Maximum allowed distance between two measured points allowed (after driving)
Max_try = 3; %Maximum tries before the error will be accepted.
error_read = zeros(Max_try , 4);

%Gathering new x(k) and y(k)
if(q ~= 0)
    k = k + 1; 
while(1) %Sometimes only another target is chosen. Therefore the code can update the values to the new target and use q = 0 for that
    Acq_data = pa_wavrecord(1,nmics,T_meas*Fs,Fs);
    [x(k), y(k)] = localization_driving(refsignal, refsignalStart,lengthV,Tr, Fs,mic,mic3D,Acq_data, eps);
    x(k) = x(k) * 100 +230;
    y(k) = y(k) * 100 + 230;
    if(0 > x(k) || maxfield < x(k) ||  0 > y(k) || maxfield < y(k))
        n = n + 1;
        error_read(n,1) = x(k); error_read(n,2) = y(k);
        if(n < Max_try)
            continue
        else
            disp('Error in gathering a correct location (Out of field)')
            input('')
        end
    end
    dx = x(k) - x(k-1);
    dy = y(k) - y(k-1);
    if(dist_between_points < sqrt(dx^2+dy^2))
        o= o+ 1;
        error_read(m,1) = x(k); error_read(m,2) = y(k);
        if(o< Max_try)
            continue
        elseif((max(error_read(:,1)) - min(error_read(:,1))) < location_error_in_error && (max(error_read(:,2)) - min(error_read(:,2))) < location_error_in_error && 0 < x(k) < 400 && 0 < y(k) < 400)
            break 
        else
            disp('Error in gathering a correct location (To far apart)')
            input('')
        end
    else
    break
    end
end
if(k ~= 1 && q == 2) 
    phicar = atan2((y(k) - y(k-1)), (x(k) - x(k - 1))); %Angle of the direction of the car with x-axis on 0 rad
end
end

%Calculating some othervalues after accepting new measurements
deltax = goalx - x(k);
deltay = goaly - y(k);
d(k) = sqrt((x(k) - goalx)^2 + (y(k) - goaly)^2);
phitogoal = atan2(deltay, deltax); %Angle from car to goal with x-axis 0 rad
wall_x = 0;
wall_y = 0;

%update the plot
plotter(x(1:k,1), y(1:k,1), dest(m,1), dest(m,2), goalx, goaly, wall_x, wall_y)
%{
plot(x(1:k), y(1:k), 'r-o')
hold on
plot(goalx, goaly, 'g-x')
plot(dest(m,1), dest(m,2), 'r-x')
axis([0 460 0 460])
hold off
%}
end