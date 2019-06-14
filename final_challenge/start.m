function [result] = open
Port = '.\\COM9'; %Outgoing COM port 

result = EPOCommunications('open',Port); %Check the value of result 
end
