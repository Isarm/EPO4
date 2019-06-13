eps = 1/16;
micc = 1;
length = 370;
increment = 3;
offset = 0;


while(length<10000)
    h3 = [];
    ii = 1;
    refsignalStopTest = refsignalStart(micc) + length;
    for(ii = 1:8)
        load(['C:\Users\Isar Meijer\OneDrive - student.tudelft.nl\Studie\EPO4\Audio measurements\4-5.5-2000-standard\DataMeas' num2str(ii) '.mat']);
        h3 = [h3 ch3(refsignal(refsignalStart(micc)+offset:refsignalStopTest,micc),Acq_data(:,micc),eps)];
        subplot(3,3,ii);
        plot(h3(:,ii));
        axis([3000 11000 -0.01 0.01]);
        subplot(339)
        plot(refsignal(refsignalStart(micc):refsignalStopTest,micc));
        
    end
    
    length = length + increment
    pause;
end


