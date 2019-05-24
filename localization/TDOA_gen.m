function [TDOA] = TDOA_gen(beaconLoc, mic,N)
    v = 340;
    i = 1;
    q=0;
    for(n=1:4)
        g=2+q;
        for(k=g:N)
        di = sqrt((mic(n,1)-beaconLoc(1))^2+(mic(n,2)-beaconLoc(2))^2);
        dj = sqrt((mic(k,1)-beaconLoc(1))^2+(mic(k,2)-beaconLoc(2))^2);
        TDOA(i) = di - dj; 
        g = g+1;
        i = i+1;
        end
        
        q = q+1;
    end
end
