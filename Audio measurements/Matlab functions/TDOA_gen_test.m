% script to test the 2d and 3d model. 

N = 100;
v = 343;
mic = [2.3, -2.3; -2.3, -2.3; -2.3, 2.3; 2.3, 2.3; 0, 2.3];
mic3D = [2.3, -2.3,0.5; -2.3, -2.3,0.5; -2.3, 2.3,0.5; 2.3, 2.3,0.5; 0, 2.3,0.8];
errD = zeros(N,N)
for(xc = 1:N)
    xc
    for(yc = 1:N)
        beaconLoc = [xc*4.6/N-2.3,yc*4.6/N-2.3,0.28];
        TDOA3D = TDOA_gen3D(beaconLoc,mic3D);

        [~,~,loc2d] = localization_5(TDOA3D*v,transpose(mic));
%         [~,~,loc3d] = localization_5_3D(TDOA3D*v,transpose(mic),transpose(mic3D));

        errD(yc,xc) = norm(beaconLoc(1:2)-transpose(loc2d(1:2)));
    end
end
k = 1:N;
k = k*4.6/N-2.3;
mesh(k,k,errD);

