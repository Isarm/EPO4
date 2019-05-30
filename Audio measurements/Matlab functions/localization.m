Fs = 44100;
Tr = 0.5;
refsignalStart = 16670;
refsignalStop = 17030;
%plot(refsignal(refsignalStart:refsignalStop));

mic = [2.3, -2.3; -2.3, -2.3; -2.3, 2.3; 2.3, 2.3; 0, 2.3; 0,0; 1.08-2.3, 2.3-0.48; 2.3-1.11, 0.2;-1.3, -1.3; 2.3-1.46, 0.57-2.3];

for(i=1:5)
    % generate the channel estimations
    % replace with own channel estimations
    h2(:,i) = ch2(refsignal(refsignalStart:refsignalStop),Acq_data(:,i),length(Acq_data(:,i)));
    h3(:,i) = ch3(refsignal(refsignalStart:refsignalStop),Acq_data(:,i));
end

g=2;
i = 1;
    for(n=1:4)
        for(k=g:5)
            % generate the TDOA vector (replace TDOA with your own function
            % and store each TDOA in TDOAv(i)
            [~,~,TDOAv(i)] = TDOA(h3(:,n),h2(:,k),Tr,Fs);
            i = i+1;
        end
        g = g+1;
    end
   
    
[A,b,beaconLocMeas] = localization_5(340*TDOAv,transpose(mic(1:5,:))) 
        
          

