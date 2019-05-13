Port = '.\\COM8'; %Outgoing COM port 
result = EPOCommunications('open',Port); %Check the value of result
delay = [];
sensorL = [];
sensorR = [];
realdelay = [];

EPOCommunications('transmit','M165');

while(1)
    tic
    [L,R,~,~] = sensorDistance;
    if isempty(sensorL)
        sensorL = L;
        sensorR = R;
    else
        sensorL = [sensorL L];
        sensorR = [sensorR R];
    end
    if(sensorL(end)/2+sensorR(end)/2<200)
        EPOCommunications('transmit', 'M144');
        break
    end
    
    if isempty(delay)
        delay = toc;
    else
        delay = [delay toc];
    end
    if(delay(end)<0.07)
        pause(0.07 - delay(end));
    end
    
    if isempty(realdelay)
        realdelay = toc;
    else
        realdelay = [realdelay toc];
    end 
    
    
end
i = 1;
while(1)
    tic
    [L,R,~,~] = sensorDistance;
    if isempty(sensorL)
        sensorL = L;
        sensorR = R;
    else
        sensorL = [sensorL L];
        sensorR = [sensorR R];
    end
    i = i+1;
    
    if(i>20)
        break
    end
    
    if isempty(delay)
        delay = toc;
    else
        delay = [delay toc];
    end
    if(delay(end)<0.07)
        pause(0.07 - delay(end));
    end
    
    if isempty(realdelay)
        realdelay = toc;
    else
        realdelay = [realdelay toc];
    end     
end

result = EPOCommunications('close'); %Check the value of result 