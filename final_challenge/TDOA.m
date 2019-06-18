%Isar Meijer - 4722930
%Geert Jan Meppelink - 4692810
% EE2T11
% 20/3/2019

function [T1,T2,dif] = TDOA(h1,h2,Tr, Fs)
% TDOA algorithm

% Find the peaks with a distance of more than a third of the repition rate between the
% peaks
[PKS,locs] = findpeaks(h1,'MinPeakDistance',round(Fs*8/343));


% Find the first part of silence
low_threshold = 0.4*max(PKS);
LowPeakIndex = find(PKS<low_threshold);

% Search for peaks after the first part of silence
threshold = 0.8*max(PKS(LowPeakIndex(1):end));
PeakIndex = find(PKS(LowPeakIndex(1):end)>threshold);

% Select the first peak and search for peaks in an interval around it for
% both signals
T1 = locs(PeakIndex(1));
[PKSh1,locsh1] = findpeaks(h1(T1-round(Fs*8/343):T1+round(Fs*8/343)), 'MinPeakDistance',3);
[PKSh2,locsh2] = findpeaks(h2(T1-round(Fs*8/343):T1+round(Fs*8/343)), 'MinPeakDistance',3);

% Select the first high peak and calculate the time this peak occurs
threshold = 0.8*max(PKSh1);
PeakIndexh1 = find(PKSh1>threshold);
T1new = locsh1(PeakIndexh1(1))+T1-round(Fs*8/343)-1;
peakH1 = h1(T1new);
threshold = 0.8*max(PKSh2);
PeakIndexh2 = find(PKSh2>threshold);
T2new = locsh2(PeakIndexh2(1))+T1-round(Fs*8/343)-1;
peakH2 = h2(T2new);

% figure
% subplot(211)
% plot(h1)
% hold on
% plot([T1new,T1new],[-max(h1),max(h1)],'lineWidth',1)
% hold on
% plot([0,length(h1)],[peakH1(1),peakH1(1)],'lineWidth',1);
% axis([T1-round(Fs*8/340),T1+round(Fs*8/340),-max(h1)-0.01,max(h1)+0.01]);
% subplot(212)
% plot(h2)
% hold on
% plot([T2new,T2new],[-max(h2),max(h2)],'lineWidth',1)
% hold on
% plot([0,length(h2)],[peakH2(1),peakH2(1)],'LineWidth',1);
% axis([T1-round(Fs*8/340),T1+round(Fs*8/340),-max(h2)-0.01,max(h2)+0.01]);

% Convert to seconds
T1 = T1new./Fs;
T2 = T2new./Fs;
dif = T2-T1;
end