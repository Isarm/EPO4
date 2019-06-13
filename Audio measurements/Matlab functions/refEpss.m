eps = 1;;
micc = 5;
length = 391;

% 4-5.5
eps1 = 0.09;
length1 = 396;

eps2 = 0.12;
length2 = 411;


while(eps<3)
    h3 = [];
    ii = 1;
    refsignalStopTest = refsignalStart(micc) + length;
    for(ii = 1:8)
        load(['C:\Users\Isar Meijer\OneDrive - student.tudelft.nl\Studie\EPO4\Audio measurements\4-12-2500-C0xD1485066\DataMeas' num2str(ii) '.mat']);
        h3 = [h3 ch3(refsignal(refsignalStart(micc):refsignalStopTest,micc),Acq_data(:,micc),eps)];
        subplot(3,3,ii);
        plot(h3(:,ii));
        axis([15000 30000 -0.01 0.01]);
        subplot(339)
        plot(refsignal(refsignalStart(micc):refsignalStopTest),micc);
    end
    
    eps = eps + 0.05
    pause;
end


