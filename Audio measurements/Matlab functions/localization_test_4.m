beaconLoc = [1,1];
N = 4;
mic = [-3,1;4,1;4,5;1,6];

TDOA = TDOA_gen(beaconLoc,mic,N);

[A,B,beaconLocMeasured] = localization_4(TDOA,transpose(mic));

beaconLocMeasured