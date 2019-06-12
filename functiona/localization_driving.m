function BeaconLocMeas3D = localization_driving(refsignal, refsignalStart,refsignalStop,Tr, Fs,mic,mic3D)
    
nmics = 5;
T_meas = 0.5;
Acq_data = pa_wavrecord(1,nmics,T_meas*Fs,Fs);  %% Acquire Data
    for(n=1:5)
        % generate the channel estimations
        % replace with own channel estimations
        % h2(:,i) = ch2(refsignal(refsignalStart(i):refsignalStop(i),i),Acq_data(:,i),length(Acq_data(:,i)));
        h3(:,n) = ch3(refsignal(refsignalStart(n):refsignalStop(n),n),Acq_data(:,n));
    end
    g=2;
    j = 1;
    for(n=1:4)
        for(k=g:5)
            % generate the TDOA vector (replace TDOA with your own function
            % and store each TDOA in TDOAv(i)
            [~,~,TDOAv(j)] = TDOAv2(h3(:,n),h3(:,k),Tr,Fs);
            j = j+1;
        end
        g = g+1;
    end
    [~,~,BeaconLocMeas3D] = localization_5_3D(340*TDOAv,transpose(mic),transpose(mic3D));
end
