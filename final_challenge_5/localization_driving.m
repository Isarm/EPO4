function [x,y] = localization_driving(refsignal, refsignalStart,lengthV,Tr, Fs,mic,mic3D, Acq_data,eps)
 clear h3;  
for(n=1:5)
        % generate the channel estimations
        % replace with own channel estimations
        % h2(:,i) = ch2(refsignal(refsignalStart(i):refsignalStop(i),i),Acq_data(:,i),length(Acq_data(:,i)));
        h3(:,n) = ch3(refsignal(refsignalStart:refsignalStart+lengthV),Acq_data(:,n), eps);
    end
    g=2;
    j = 1;
    for(i=1:4)
        for(k=g:5)
            % generate the TDOA vector (replace TDOA with your own function
            % and store each TDOA in TDOAv(i)
            [~,~,TDOAv(j)] = TDOA(h3(:,i),h3(:,k),Tr,Fs);
            j = j+1;
        end
        g = g+1;
    end
    [~,~,BeaconLocMeas3D] = localization_5_3D(343*TDOAv,transpose(mic),transpose(mic3D));
    x = BeaconLocMeas3D(1)
    y = BeaconLocMeas3D(2)
end