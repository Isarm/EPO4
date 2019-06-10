beaconLoc = [2.3,0,0.2];
mic = [2.3, -2.3; -2.3, -2.3; -2.3, 2.3; 2.3, 2.3; 0, 2.3];
mic3D = [2.3, -2.3,0.4; -2.3, -2.3,0.4; -2.3, 2.3,0.4; 2.3, 2.3,0.4; 0, 2.3,0.5];

TDOA3D = TDOA_gen3D(beaconLoc,mic3D,5)

[~,~,loc2d] = localization_5(TDOA3D,transpose(mic));
[~,~,loc3d] = localization_5_3D(TDOA3D,transpose(mic),transpose(mic3D));

transpose(loc2d(1:2))
transpose(loc3d(1:2))