%Isar Meijer - 4722930
%Geert Jan Meppelink - 4692810
% EE2T11
% 20/3/2019

function [T1,T2,dif] = TDOA(h1,h2,Tr, Fs)
% TDOA algorithm

% Find the peaks with a distance of more than a third of the repition rate between the
% peaks
[PKS,locs] = findpeaks(h1,'MinPeakDistance',Fs*Tr/3);


% Find the first part of silence
low_threshold = 0.4*max(PKS)
LowPeakIndex = find(PKS<low_threshold);

% Search for peaks after the first part of silence
threshold = 0.9*max(PKS);
PeakIndex = max(PKS(LowPeakIndex(1):LowPeakIndex+3));

% Select the first peak and search for peaks in an interval around it for
% both signals
T1 = locs(PeakIndex);
[PKSh1,locsh1] = findpeaks(h1(T1-700:T1+700), 'MinPeakDistance',10);
[PKSh2,locsh2] = findpeaks(h2(T1-700:T1+700), 'MinPeakDistance',10);

% Select the first high peak and calculate the time this peak occurs
threshold = 0.95*max(PKSh1);
PeakIndexh1 = find(PKSh1>threshold);
T1new = locsh1(PeakIndexh1(1))+T1-700;
threshold = 0.95*max(PKSh2);
PeakIndexh2 = find(PKSh2>threshold);
T2new = locsh2(PeakIndexh2(1))+T1-700;

figure
subplot(211)
stem(PKSh1)
hold on
plot(PeakIndexh1(1),PKSh1(PeakIndexh1(1)),'*','MarkerSize',20);
subplot(212)
stem(PKSh2)
hold on
plot(PeakIndexh2(1),PKSh2(PeakIndexh2(1)),'*','MarkerSize',20);

% Convert to seconds
T1 = T1new./Fs;
T2 = T2new./Fs;
dif = T2-T1;
end


