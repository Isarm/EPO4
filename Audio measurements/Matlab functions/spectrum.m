clear all
% Input: Ncodebits,Timer0,Timer1,Timer2,code, as for the AVR
%       Extension: If Timer0 == -1, then no carrier modulation
%       Fs: sample rate at which to generate the template (e.g., 40e3)
%
% The default parameters of the audio beacon are obtained using
%     x = refsignal(32,3,8,2,'92340f0faaaa4321',Fs);
%
% Output:
%     x: the transmitted signal (including silence period)
%     last: the last sample before the silence period
Fs = 48000;
code =  'D1485066'
Ncodebits = 32;

% arrays to match Timerx to frequencies (Hz)
FF0 = [12 5 10 15 20 25 30]*1e3;
FF1 = [1 1.5 2 2.5 3 3.5 4 4.5 5]*1e3;
FF3 = [1 2 3 4 5 6 7 8 9 10];

% compute corresponding frequencies (Hz)
f0 = 12e3
f1 = 4e3
f3 = 1

% convert hex code string into binary string
bincode = [];
for ii = 1:length(code)
    symbol = code(ii);
    bits = dec2bin(hex2dec(symbol),4);	% 4 bits for a hex symbol
    bincode = strcat(bincode , bits);
end

% Generate template
Nx = round(Fs/f3);	% number of samples in template vector (integer)
x = zeros(Nx,1);

Np = Fs/f1;		% number of samples of one "Timer1" period (noninteger)
for ii = 1:Ncodebits,
   index = [round((ii-1)*Np+1) : round(ii*Np)];
   bit = bincode(ii) == '1';	% convert from char '0' or '1' to integer 0 or 1
   x( index ) = ones(length(index),1) * bit;
end

% modulate x on a carrier with frequency f0
carrier = cos(2*pi*f0/Fs*[0:Nx-1]);
x = x .* transpose(carrier);
xid = x;

f = [-(length(x)-1)/length(x)/2:1/length(x):(length(x)-1)/length(x)/2]*Fs;
plot(f,log(fftshift(abs(fft(x)))));

load('SingleReference.mat')

f2 = [-(lengthV)/lengthV/2:1/lengthV:(lengthV)/lengthV/2]*Fs;
hold on
plot(f2,log(fftshift(abs(fft(refsignal(refsignalStart:refsignalStart+lengthV))))));
axis([0 2.5e4 -5 10]);
f = 500;
i = 1;
clear x;
while(f < 16500)
    load(['C:\Users\Isar Meijer\OneDrive - student.tudelft.nl\Studie\EPO4\Audio measurements\frequencyResponse2\DataMeas' num2str(f) '.mat']);
    
%     plot(sum(transpose(Acq_data)));
%     hold on
    Y = fft(sum(transpose(Acq_data)));
    
    powY = Y.*conj(Y);
    
    fr(i) = sum(powY(round((f-250)/Fs*length(powY)):round((f+250)/Fs*length(powY))));
    x(i) = f;
    f = f+500;
    i = i+1;
end
hold on
yyaxis right
plot(x,log(fr));

legend('Spectrum of the audio code', 'Spectrum of the reference signal', 'Frequency response of the beacon');
xlabel('Frequency (Hz)');
yyaxis left
ylabel('Magnitude (dB)')
yyaxis right
ylabel('Magnitude (dB)');

