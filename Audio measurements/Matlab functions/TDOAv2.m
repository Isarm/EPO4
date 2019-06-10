%Isar Meijer - 4722930
%Geert Jan Meppelink - 4692810
% EE2T11
% 20/3/2019

function [T1,T2,dif] = TDOAv2(h1,h2,Tr, Fs)
% TDOA algorithm



% Find the peaks with a distance of more than a third of the repition rate between the
% peaks
[PKS,locs] = findpeaks(h1,'MinPeakDistance',round(Fs*8/340));

% Find the first part of silence
low_threshold = 0.3*max(PKS);
LowPeakIndex = find(PKS<low_threshold);

high_threshold = 0.8*max(PKS(LowPeakIndex(1):end));
peakIndex = find(PKS(LowPeakIndex(1):end)>high_threshold);

peakH1 = PKS(LowPeakIndex(1)+ peakIndex(1)-1);
T1 = locs(LowPeakIndex(1)+ peakIndex(1)-1);

[~,T2] = max(h2(T1-round(Fs*8/340):T1+round(Fs*8/340)))
peakH2 = h2(T2+T1-round(Fs*8/340)-1);
T2 = T2+T1-round(Fs*8/340)-1;
dif = T2-T1;

figure
subplot(211)
plot(h1)
hold on
plot([T1,T1],[-max(h1),max(h1)],'lineWidth',1)
hold on
plot([0,length(h1)],[peakH1(1),peakH1(1)],'lineWidth',1);
axis([T1-round(Fs*10/340),T1+round(Fs*10/340),-max(h1)-0.01,max(h1)+0.01]);
subplot(212)
plot(h2)
hold on
plot([T2,T2],[-max(h2),max(h2)],'lineWidth',1)
hold on
plot([0,length(h2)],[peakH2(1),peakH2(1)],'LineWidth',1);
axis([T1-round(Fs*10/340),T1+round(Fs*10/340),-max(h2)-0.01,max(h2)+0.01]);

T1 = T1./Fs;
T2 = T2./Fs;
dif = dif./Fs;

end


