function drive(goalx, goaly)
global d k phicar phitogoal z zz; 
test = 0;
updatelocation(goalx, goaly,0);
while(d(k) > 30)
    %Correct steering - if you don't correct steering the car may choose to
    %take a lager corner for instance 1.8pi instead of 0.2pi. Therefore you
    %have to extend the circle so that it can choose the shortest corner.
    Phi_nocorrection = phitogoal - phicar; % Difference in angle (positive stering to the left is needed and negative correcting by steering right is needed
    A = [abs(Phi_nocorrection) abs(Phi_nocorrection + 2*pi) abs(Phi_nocorrection - 2*pi); Phi_nocorrection, (Phi_nocorrection + 2*pi), (Phi_nocorrection - 2*pi)];
    [~,c] = min(A(1,:));
    phi = A(2,c); %So it takes the angle with the absolute minimum value, but with this rule it keeps the sign of the value which is needed to know whether you must steer to the right or to the left.
        
    %Send steering signals
    if test == 1
        if 0.15 < phi && phi < 0.35  
            zz = 3;
        elseif phi > 0.35
            zz = 5;
        elseif  -0.15 > phi && phi > -0.35 
            zz = -3; 
        elseif phi < -0.35 
            zz = -5;
        else
            zz = 0; 
        end
        z = 1;
    else
        if 0.15 < phi && phi < 0.35  %~5 graden  Minimale angle voordat ie gaat sturen
            EPOCommunications('transmit','D170')
        elseif phi > 0.35 % ~20 graden
            EPOCommunications('transmit','D200')
        elseif  -0.15 > phi && phi > -0.35 %Minimale angle voordat ie gaat sturen
            EPOCommunications('transmit','D130') 
        elseif phi < -0.35 %Minimale angle voordat ie gaat sturen
            EPOCommunications('transmit','D100') 
        else
            EPOCommunications('transmit','D150')
        end
        EPOCommunications('transmit','M160')
        pause(0.5)
        EPOCommunications('transmit','M150')
    end
    updatelocation(goalx, goaly,1)
end
end