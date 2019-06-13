%% Presets
nmics = 5;          %% Number of Microphones
Port = '\\.\COM5';  %% Outgoing COM port


%% Student Group Data
Group = 'B10';
B = 'B32';        %% Bit frequency;           %Standard: B5000
F = 'F20000';       %% Carrier frequency        %Standard: F10000
R = 'R32';        %% Repitition Count         %Standard: R2500
C = 'C0xFFFFFFFF';   %% Audio code               %Standard: C0xaa55aa55

%% Set-up Car
EPOCommunications('open',Port);
EPOCommunications('transmit',B);
EPOCommunications('transmit',C);
EPOCommunications('transmit',R);

%% Set-up Variables
mkdir(Group)
Fs = 48000;     %% Sample Rate (44100 is default)
T_meas = 1;     %% Measurement Time in Seconds
Acq_data = zeros(T_meas*Fs,nmics);

f = 500;
while(f < 20000)
    
    F = ['F',num2str(f)];
    
    EPOCommunications('transmit',F);
    EPOCommunications('transmit', 'A1');            %% Start Audio Beacon
    pause(0.2)                                      %% Wait a short period before acquiring data
    Acq_data = pa_wavrecord(1,nmics,T_meas*Fs,Fs);  %% Acquire Data
    EPOCommunications('transmit', 'A0');            %% Stop the Audio Beacon
    save([Group '\DataMeas' num2str(f) '.mat']);    %% Save Workspace Data in Folder
    f = f+500;
end

EPOCommunications('close');