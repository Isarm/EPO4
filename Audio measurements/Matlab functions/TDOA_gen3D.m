function [TDOA] = TDOA_gen3D(beaconLoc, mic,N)
    v = 343;
g=2;
i = 1;
    for(n=1:4)
        for(k=g:5)
        di = sqrt(((mic(n,1))-(beaconLoc(1)))^2+((mic(n,2))-(beaconLoc(2)))^2+((mic(n,3))-(beaconLoc(3)))^2);
        dj = sqrt(((mic(k,1))-(beaconLoc(1)))^2+((mic(k,2))-(beaconLoc(2)))^2+((mic(k,3))-(beaconLoc(3)))^2);
        TDOA(i) = dj/v - di/v; 
        i = i+1;
        end
        g = g+1;
    end
end
