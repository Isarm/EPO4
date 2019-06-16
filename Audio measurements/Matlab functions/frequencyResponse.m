f = 500;
i = 1;
clear x;
while(f < 16500)
    load(['C:\Users\Isar Meijer\OneDrive - student.tudelft.nl\Studie\EPO4\Audio measurements\frequencyResponse2\DataMeas' num2str(f) '.mat']);
    
    plot(sum(transpose(Acq_data)));
    hold on
    Y = fft(sum(transpose(Acq_data)));
    
    powY = Y.*conj(Y);
    
    fr(i) = sum(powY(round((f-100)/Fs*length(powY)):round((f+100)/Fs*length(powY))));
    x(i) = f;
    f = f+500;
    i = i+1;
end

plot(x,fr);