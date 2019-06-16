% script for testing the (xyz) 3d model versus the (xy) 3d model


N = 100;
v = 343;
mic = [2.3, -2.3; -2.3, -2.3; -2.3, 2.3; 2.3, 2.3; 0, 2.3];
mic3D = [2.3, -2.3,0.5; -2.3, -2.3,0.5; -2.3, 2.3,0.5; 2.3, 2.3,0.5; 0, 2.3,0.8];
errZ = zeros(N,N)
for(xc = 1:N)
    xc
    for(yc = 1:N)
        beaconLoc = [xc*4.6/N-2.3,yc*4.6/N-2.3,0.28];
        TDOA3D = TDOA_gen3D(beaconLoc,mic3D);
        % select a random number between 1 and ten
        k = ceil(rand(1)*10);
        
        % add a uniformly distributed absolute error between 1/10 and 1 ms.
        TDOA3D(k) = TDOA3D(k) + 0.001*rand(1);
        % locate the car using the (xyz) and (xy) estimation algorithms. 
        [~,~,loc3dZ] = localization_5(TDOA3D*v,transpose(mic3D));
        [~,~,loc3d] = localization_5_3D(TDOA3D*v,transpose(mic),transpose(mic3D));

        errZ(yc,xc) = norm(beaconLoc(1:2)-transpose(loc3dZ(1:2)));
        z(yc,xc) = loc3dZ(3);
        err(yc,xc) = norm(beaconLoc(1:2)-transpose(loc3d(1:2)));
    end
end

mean(mean(errZ))
mean(mean(err))


