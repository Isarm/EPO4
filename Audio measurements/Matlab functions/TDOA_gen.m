function [TDOA] = TDOA_gen(beaconLoc, mic)
% this function generates ideal (3D) TDOA pairs.
    v = 340;
g=2;
i = 1;
    for(n=1:4)
        for(k=g:5)
        di = sqrt(((mic(n,1))-(beaconLoc(1)))^2+((mic(n,2))-(beaconLoc(2)))^2);
        dj = sqrt(((mic(k,1))-(beaconLoc(1)))^2+((mic(k,2))-(beaconLoc(2)))^2);
        TDOA(i) = dj - di; 
        i = i+1;
        end
        g = g+1;
    end
end
