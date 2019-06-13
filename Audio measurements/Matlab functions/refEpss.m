eps = 0.01;;
micc = 1;
length = 398;

% 4-5.5
eps1 = 0.09;
length1 = 396;

eps2 = 0.12;
length2 = 411;


while(eps<0.3)
    h3 = [];
    ii = 1;
    refsignalStopTest = refsignalStart(micc) + length;
    for(ii = 1:8)
        load(['C:\Users\Isar Meijer\OneDrive - student.tudelft.nl\Studie\EPO4\Audio measurements\4-5.5-2000-standard\DataMeas' num2str(ii) '.mat']);
        h3 = [h3 ch3(refsignal(refsignalStart(micc):refsignalStopTest,micc),Acq_data(:,micc),eps)];
        subplot(3,3,ii);
        plot(h3(:,ii));
        subplot(339)
        plot(refsignal(refsignalStart(micc):refsignalStopTest),micc);
    end
    
    eps = eps + 0.005
    pause;
end


