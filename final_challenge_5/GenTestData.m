%- Matlab Script to get measurement data
%- and save in the correct location
%- By: Teun de Smalen

%% Presets
nmeas = 12 ;          %% Number of Measurements
nmics = 5;          %% Number of Microphones
Port = '\\.\COM6';  %% Outgoing COM port


%% Student Group Data
Group = 'B10';
B = 'B4000';        %% Bit frequency;           %Standard: B5000
F = 'F12000';       %% Carrier frequency        %Standard: F10000
R = 'R1500';        %% Repitition Count         %Standard: R2500
C = 'C0xD1485066';   %% Audio code               %Standard: C0xaa55aa55

%% Set-up Car
EPOCommunications('open',Port);
EPOCommunications('transmit',B);
EPOCommunications('transmit',F);
EPOCommunications('transmit',R);
EPOCommunications('transmit',C);

%% Set-up Variables
mkdir(Group)
Fs = 48000;     %% Sample Rate (44100 is default)
T_meas = 3;     %% Measurement Time in Seconds
Acq_data = zeros(T_meas*Fs,nmics);

%% Acquire data
for i = 1:nmeas
    disp('Change Car Position and press a key!');
    pause;                                          %% Wait for user to continue
    disp(['Starting Measurement ' num2str(i)]);
    EPOCommunications('transmit', 'A1');            %% Start Audio Beacon
    pause(0.2)                                       %% Wait a short period before acquiring data
    Acq_data = pa_wavrecord(1,nmics,T_meas*Fs,Fs);  %% Acquire Data
    EPOCommunications('transmit', 'A0');            %% Stop the Audio Beacon
    save([Group '\DataMeas' num2str(i) '.mat']);    %% Save Workspace Data in Folder
end

disp('Finished');
EPOCommunications('close');