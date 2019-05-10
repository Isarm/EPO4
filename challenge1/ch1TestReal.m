Port = '.\\COM3'; %Outgoing COM port 

result = EPOCommunications('open',Port) %Check the value of result 

challenge1(0);

result = EPOCommunications('close')