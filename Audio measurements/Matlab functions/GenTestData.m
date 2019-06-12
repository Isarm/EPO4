%- Matlab Script to get measurement data
%- and save in the correct location
%- By: Teun de Smalen

%% Presets
nmics = 5;          %% Number of Microphones
Port = '\\.\COM3';  %% Outgoing COM port


%% Student Group Data
Group = 'A11';
B = 'B32';        %% Bit frequency;           %Standard: B5000
F = 'F20000';       %% Carrier frequency        %Standard: F10000
R = 'R16';        %% Repitition Count         %Standard: R2500
C = 'C0xFFFFFFFF';   %% Audio code               %Standard: C0xaa55aa55

%% Set-up Car
EPOCommunications('open',Port);
EPOCommunications('transmit',B);
EPOCommunications('transmit',F);
EPOCommunications('transmit',R);
EPOCommunications('transmit',C);

%% Set-up Variables
mkdir(Group)
Fs = 44100;     %% Sample Rate (44100 is default)
T_meas = 3;     %% Measurement Time in Seconds
Acq_data = zeros(T_meas*Fs,nmics);

%% Acquire data
for i = 1:nmeas
    disp('Change Car Position and press a key!');
    pause;                                          %% Wait for user to continue
    disp(['Starting Measurement ' num2str(i)]);
    EPOCommunications('transmit', 'A1');            %% Start Audio Beacon
    pause(0.2)                                      %% Wait a short period before acquiring data
    Acq_data = pa_wavrecord(1,nmics,T_meas*Fs,Fs);  %% Acquire Data
    EPOCommunications('transmit', 'A0');            %% Stop the Audio Beacon
    save([Group '\DataMeas' num2str(i) '.mat']);    %% Save Workspace Data in Folder
end

disp('Finished');
EPOCommunications('close');