function [result] = open
Port = '.\\COM6'; %Outgoing COM port 

result = EPOCommunications('open',Port); %Check the value of result 
end
