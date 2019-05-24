

mic = [-3,1;4,1;4,5;1,6;1,2]; 
Fs = 5000; 
Beacon = 'A1'; 
BeaconCode = 'C0x12345678';
BitFreq = ['B', Fs];
CarrierFreq = 'F15000';
RepetitionCount = 'R2500';



% result = EPOCommunications('close'); %Check the value of result
Port = '.\\COM3'; %Outgoing COM port 
result = EPOCommunications('open',Port); %Check the value of result 

EPOCommunications('transmit', BitFreq);
EPOCommunications('transmit', CarrierFreq);
EPOCommunications('transmit', RepetitionCount);
EPOCommunications('transmit', BeaconCode);
tic
EPOCommunications('transmit', Beacon);


pause(2);
Trec = toc;
result = EPOCommunications('close'); %Check the value of result

%inputbuffer = pa_wavrecord(beginchannel, endchannel, nsamples);
rec = pa_wavrecord(1, 5, Fs*Trec, Fs, 'asio');

 i = 1;
 q = 0;
    for(n=1:4)
       g=2+q;
       for(k=g:5)          
       TDOA_value(i) = TDOA(ref_sig, rec(:,n), rec(:,k));
       g = g+1;
       i = i+1;
       end
       q = q+1;
    end

[A,B,beaconLocMeasured] = localization_5(TDOA,transpose(mic));