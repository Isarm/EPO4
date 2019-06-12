
%- Matlab Script to get measurement data
%- and save in the correct location
%- By: Teun de Smalen

%% Presets
nmeas = 6;          %% Number of Measurements
nmics = 5;          %% Number of Microphones
Port = '\\.\COM10';  %% Outgoing COM port

Tr = 0.5;
Fs = 48000;
mic = [2.3, -2.3; -2.3, -2.3; -2.3, 2.3; 2.3, 2.3; 0, 2.3];
mic3D = [2.3, -2.3,0.3; -2.3, -2.3,0.3; -2.3, 2.3,0.3; 2.3, 2.3,0.3; 0, 2.3,0.5];

%% Student Group Data
Group = 'B10';
B = 'B4000';        %% Bit frequency;           %Standard: B5000
F = 'F12000';       %% Carrier frequency        %Standard: F10000
R = 'R2000';        %% Repitition Count         %Standard: R2500
C = 'C0xD1485066';   %% Audio code               %Standard: C0xaa55aa55

%% Set-up Car
EPOCommunications('open',Port);
EPOCommunications('transmit',B);
EPOCommunications('transmit',F);
EPOCommunications('transmit',R);
EPOCommunications('transmit',C);
EPOCommunications('transmit', 'A1');

while(1)
    
BeaconLocMeas3D = localization_driving(refsignal, refsignalStart,refsignalStop,Tr, Fs,mic,mic3D);
transpose(BeaconLocMeas3D(1:2))
pause;                                        
end
