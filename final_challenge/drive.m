function drive(goalx, goaly)
global d k phicar phitogoal; 
hardturn = 0.11; %In rad
softturn = 0.5 * hardturn; %In rad
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
    if 0.15 < phi && phi < 0.35  %~5 graden  Minimale angle voordat ie gaat sturen
        EPOCommunications('transmit','D170')
        q = 2;
        phicar = phicar - softturn;
    elseif phi > 0.35 % ~20 graden
        EPOCommunications('transmit','D200')
        q = 2;
        phicar = phicar - hardturn;
    elseif  -0.15 > phi && phi > -0.35 %Minimale angle voordat ie gaat sturen
        EPOCommunications('transmit','D130') 
        q = 2;
        phicar = phicar + softturn;
    elseif phi < -0.35 %Minimale angle voordat ie gaat sturen
        EPOCommunications('transmit','D100')
        phicar = phicar + hardturn;
        q = 2;
    else
        EPOCommunications('transmit','D150')
        q = 1;
    end  
    EPOCommunications('transmit','M160')
    pause(0.5)
    EPOCommunications('transmit','M150')
    if(phicar > pi)
        phicar = phicar - 2*pi;
    elseif(phicar < pi)
        phicar = phicar + 2*pi;
    end
    updatelocation(goalx, goaly,q)
end
end