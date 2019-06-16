Tr = 0.5;
mic = [2.3, -2.3; -2.3, -2.3; -2.3, 2.3; 2.3, 2.3; 0, 2.3];
mic3D = [2.3, -2.3,0.5; -2.3, -2.3,0.5; -2.3, 2.3,0.5; 2.3, 2.3,0.5; 0, 2.3,0.8];

clear h2;
clear h3;
for(i=1:5)
    % generate the channel estimations
    % replace with own channel estimations
    % h2(:,i) = ch2(refsignal(refsignalStart(i):refsignalStop(i),i),Acq_data(:,i),length(Acq_data(:,i)));
    h3(:,i) = ch3(refsignal(refsignalStart:refsignalStart+lengthV),Acq_data(:,i),eps);
end

for(i=1:5)
    subplot(5,1,i)
    plot(h3(:,i));
    axis([1.6e4 4e4 -max(h3(:,i)) max(h3(:,i))])
end
figure

g=2;
i = 1;
    for(n=1:4)
        for(k=g:5)
            % generate the TDOA vector (replace TDOA with your own function
            % and store each TDOA in TDOAv(i)
            [~,~,TDOAv(i)] = TDOA(h3(:,n),h3(:,k),Tr,Fs);
            i = i+1;
        end
        g = g+1;
    end    
% [~,~,beaconLocMeas] = localization_5(343*TDOAv,transpose(mic(1:5,:))) 
[~,~,beaconLocMeas3D] = localization_5_3D(343*TDOAv,transpose(mic),transpose(mic3D))
        
 
