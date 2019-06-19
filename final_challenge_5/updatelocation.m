function updatelocation(goalx, goaly, q)
global toc1 toc2 x y k d phicar phitogoal maxfield dest m refsignal refsignalStart lengthV eps;
Tr = 0.5;
Fs = 48000;
mic = [2.3, -2.3; -2.3, -2.3; -2.3, 2.3; 2.3, 2.3; 0, 2.3];
mic3D = [2.3, -2.3,0.5; -2.3, -2.3,0.5; -2.3, 2.3,0.5; 2.3, 2.3,0.5; 0, 2.3,0.8];
nmics = 5;
T_meas = 2*1000/4000;  
o = 0; 
Max_try = 5; %Maximum tries before the error will be accepted.
error_read = zeros(Max_try,2);
dist_between_points = 30; %Maximum allowed distance between two measured points allowed (after driving)


%Gathering new x(k) and y(k)
if(q ~= 0)
    k = k + 1; 
while(1) %Sometimes only another target is chosen. Therefore the code can update the values to the new target and use q = 0 for that
    tic
    Acq_data = pa_wavrecord(1,nmics,T_meas*Fs,Fs);
    toc1 = [toc1 toc];
    [x(k), y(k)] = localization_driving(refsignal, refsignalStart,lengthV,Tr, Fs,mic,mic3D,Acq_data, eps);
    toc2 = [toc2 toc];
    x(k) = x(k) * 100 + 230;
    y(k) = y(k) * 100 + 230;
    if(0 > x(k) || maxfield < x(k) ||  0 > y(k) || maxfield < y(k))
            disp('Error: Measurment out of field')
            continue
    end
    dx = x(k) - x(k-1);
    dy = y(k) - y(k-1);
    
    if(dist_between_points < sqrt(dx^2+dy^2))
        o= o+ 1;
        error_read(o,1) = x(k); 
        error_read(o,2) = y(k);
        if(o< Max_try)
            continue
        else
         errd = zeros(1,5);
         avgerrx =  sum(error_read(:,1)) / 5;
         avgerry =  sum(error_read(:,2)) / 5;
         for t = 1:5
             errd(t) = sqrt((avgerrx - error_read(t,1))^2 + (avgerry - error_read(t,2))^2);
         end
         [~,omitrow] = max(errd);
         error_read(omitrow,:) = [];
         avgerrx =  sum(error_read(:,1)) / 4;
         avgerry =  sum(error_read(:,2)) / 4;
         clear errd
         for t = 1:4
             errd(t) = sqrt((avgerrx - error_read(t,1))^2 + (avgerry - error_read(t,2))^2);
         end
         [~,omitrow] = max(errd);
         error_read(omitrow,:) = [];
         x(k) = sum(error_read(:,1)) / 3;
         y(k) = sum(error_read(:,2)) / 3;
         clear errd
         clear error_read
         break
        end
    else
    break
    end
end
if(k ~= 1 && q == 2) 
    phicar(k) = atan2((y(k) - y(k-1)), (x(k) - x(k - 1))); %Angle of the direction of the car with x-axis on 0 rad
end
end

%Calculating some othervalues after accepting new measurements
deltax = goalx - x(k);
deltay = goaly - y(k);
d(k) = sqrt((x(k) - goalx)^2 + (y(k) - goaly)^2);
phitogoal(k) = atan2(deltay, deltax); %Angle from car to goal with x-axis 0 rad
wall_x = 0;
wall_y = 0;

%update the plot
plotter(x(1:k,1), y(1:k,1), dest(m,1), dest(m,2), goalx, goaly, wall_x, wall_y)
end