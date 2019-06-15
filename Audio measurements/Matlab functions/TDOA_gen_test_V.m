N = 1000;
v = 0.01*343+343;
mic = [2.3, -2.3; -2.3, -2.3; -2.3, 2.3; 2.3, 2.3; 0, 2.3];
mic3D = [2.3, -2.3,0.5; -2.3, -2.3,0.5; -2.3, 2.3,0.5; 2.3, 2.3,0.5; 0, 2.3,0.8];
errV = zeros(N,N);
for(xc = 1:N)
    xc
    for(yc = 1:N)
        beaconLoc = [xc*4.6/N-2.3,yc*4.6/N-2.3,0.28];
        TDOA3D = TDOA_gen3D(beaconLoc,mic3D,5);

        [~,~,loc3dV] = localization_5_3D(TDOA3D*v,transpose(mic),transpose(mic3D));
%         [~,~,loc3dV2] = localization_5_3D(TDOA3D*v2,transpose(mic),transpose(mic3D));

        errV(yc,xc) = norm((loc3dV(1:2))-transpose(beaconLoc(1:2)));
    end
end
k = 1:N;
k = k*4.6/N-2.3;
mesh(k,k,errV);

