eps = 1;
micc = 5;
length = 391;

% 4-12-3000
eps1 = 1.05;
eps2 = 0.9;
eps3 = 1;
eps4 = 1.15;
eps5 = 1.2;
lengthV2 = 385;
lengthV5 = 388;


% 4-5.5
% eps1 = 0.09;
% length1 = 396;
% 
% eps2 = 0.12;
% length2 = 411;


while(eps<3)
    h3 = [];
    ii = 1;
    refsignalStopTest = refsignalStart(micc) + length;
    for(ii = 1:8)
        load(['C:\Users\Isar Meijer\OneDrive - student.tudelft.nl\Studie\EPO4\Audio measurements\4-12-3000-standard-mid(12345)\DataMeas' num2str(ii) '.mat']);
        h3 = [h3 ch3(refsignal(refsignalStart(3):refsignalStopTest,3),Acq_data(:,micc),eps)];
        subplot(3,3,ii);
        plot(h3(:,ii));
        axis([0 15000 -0.01 0.01]);
        subplot(339)
        plot(refsignal(refsignalStart(micc):refsignalStopTest),micc);
    end
    
    eps = eps + 0.05
    pause;
end


