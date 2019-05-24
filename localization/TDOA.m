function [distance] = TDOA(ref_sig,rec1, rec2)

h1 = ch2(ref_sig, rec1);
h2 = ch2(ref_sig, rec2);

[pks1, locs1] = findpeaks(h1,'npeaks', 5, 'sortstr', 'descend', 'MinPeakDistance', 500);
[pks2, locs2] = findpeaks(h2,'npeaks', 5, 'sortstr', 'descend', 'MinPeakDistance', 500);

locs1_tot=locs1(1)+locs1(2)+locs1(3)+locs1(4)+locs1(5);
locs2_tot=locs2(1)+locs2(2)+locs2(3)+locs2(4)+locs2(5);

distance= (abs(locs2_tot-locs1_tot)/40000*343)/5;
end

