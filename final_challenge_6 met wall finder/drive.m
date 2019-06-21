function drive(goalx, goaly, w)
global d k phicar phitogoal phi dest; 
updatelocation(goalx, goaly,0);
while(d(k) > 30)
    %Correct steering - if you don't correct steering the car may choose to
    %take a lager corner for instance 1.8pi instead of 0.2pi. Therefore you
    %have to extend the circle so that it can choose the shortest corner.
    Phi_nocorrection = phitogoal(k) - phicar(k); % Difference in angle (positive stering to the left is needed and negative correcting by steering right is needed
    A = [abs(Phi_nocorrection) abs(Phi_nocorrection + 2*pi) abs(Phi_nocorrection - 2*pi); Phi_nocorrection, (Phi_nocorrection + 2*pi), (Phi_nocorrection - 2*pi)];
    [~,c] = min(A(1,:));
    phi(k) = A(2,c); %So it takes the angle with the absolute minimum value, but with this rule it keeps the sign of the value which is needed to know whether you must steer to the right or to the left.
        
    %Send steering signals
    if 0.15 < phi(k) && phi(k) < 0.35  %~5 graden  Minimale angle voordat ie gaat sturen
        EPOCommunications('transmit','D170')
        q = 2;
        %phicar(k+1) = phicar - softturn;
    elseif phi(k) > 0.35 % ~20 graden
        EPOCommunications('transmit','D200')
        q = 2;
        %phicar(k+1) = phicar(k) - hardturn;
    elseif  -0.15 > phi(k)&& phi(k)> -0.35 %Minimale angle voordat ie gaat sturen
        EPOCommunications('transmit','D130') 
        q = 2;
        %phicar(k+1) = phicar(k) + softturn;
    elseif phi(k)< -0.35 %Minimale angle voordat ie gaat sturen
        EPOCommunications('transmit','D100')
        %phicar(k+1) = phicar(k) + hardturn;
        q = 2;
    else
        EPOCommunications('transmit','D150')
        q = 2;
    end  
    EPOCommunications('transmit','M160')
    pause(0.5)
    EPOCommunications('transmit','M150')
    if(w == 1)
        [interx, intery, wallfound] = wallfinder(x(k), y(k), dest(m,1), dest(m,2), phicar)
        if(wallfound == 1)
            drive(interx, intery, 0)
            updatelocation(goalx, goaly,0)
            continue
        end
    end  
    updatelocation(goalx, goaly,q)
    if(phicar(k) > pi)
        phicar(k) = phicar(k) - 2*pi;
    elseif(phicar(k) < -pi)
        phicar(k) = phicar(k) + 2*pi;
    end
end
end