

mic = [-3,1;4,1;4,5;1,6;1,2];

 i = 1;
 q = 0;
    for(n=1:4)
       g=2+q;
       for(k=g:5)          
       TDOA_value(i) = TDOA(ref_sig, rec(n), rec(k));
       g = g+1;
       i = i+1;
       end
       q = q+1;
    end

[A,B,beaconLocMeasured] = localization_5(TDOA_value,transpose(mic));
