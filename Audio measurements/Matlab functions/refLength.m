eps = 1.2;
micc = 5;
length = 382;
increment = 3;
offset = 0;

%4-12-3000
lengthV = [389 390 410 403 412];
eps = [0.115 0.08 0.2 0.125 0.12];

% 4-12-2500
eps1 = 1;
length1 = 391;
eps2 = 1.4
length2 = 391;
eps3 = 1.5;
length3 = 391;
eps4 = 1;
length4 = 394
eps5 = 1.05;
length5 = 391;




while(length<10000)
    h3 = [];
    ii = 1;
    refsignalStopTest = refsignalStart(micc) + length;
    for(ii = 1:8)
        load(['C:\Users\Isar Meijer\OneDrive - student.tudelft.nl\Studie\EPO4\Audio measurements\4-12-3000-standard-mid(12345)\DataMeas' num2str(ii) '.mat']);
        h3 = [h3 ch3(refsignal(refsignalStart(micc)+offset:refsignalStopTest,micc),Acq_data(:,micc),eps)];
        subplot(3,3,ii);
        plot(h3(:,ii));
        axis([10000 50000 -0.01 0.01]);
        subplot(339)
        plot(refsignal(refsignalStart(micc):refsignalStopTest,micc));
        
    end
    
    length = length + increment
    pause;
end


