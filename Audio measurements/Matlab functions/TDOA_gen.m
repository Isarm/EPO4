function [TDOA] = TDOA_gen(beaconLoc, mic,N)
    v = 340;
    i = 1;
    q=0
    for(n=1:4)
        g=2+q;
        for(k=g:N)
        di = sqrt((abs(mic(n,1))-abs(beaconLoc(1)))^2+(abs(mic(n,2))-abs(beaconLoc(2)))^2);
        dj = sqrt((abs(mic(k,1))-abs(beaconLoc(1)))^2+(abs(mic(k,2))-abs(beaconLoc(2)))^2);
        TDOA(i) = dj - di; 
        g = g+1;
        i = i+1;
        end
        
        q = q+1;
    end
end
