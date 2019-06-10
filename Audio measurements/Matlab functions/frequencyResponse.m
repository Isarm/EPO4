f = 1000;
i = 1;
while(f < 20000)
    load(['C:\Users\Isar Meijer\OneDrive - student.tudelft.nl\Studie\EPO4\Audio measurements\frequencyResponse\DataMeas' num2str(f) '.mat']);
    
    
    Y = fft(sum(transpose(Acq_data)));
    
    powY = Y.*conj(Y);
    
    fr(i) = sum(powY(round((f-100)/Fs*length(powY)):round((f+100)/Fs*length(powY))));
    x(i) = f;
    f = f+200;
    i = i+1;
end

plot(x,fr);