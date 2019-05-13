N = 200;

begin = 165;
stop = 213;

sensor = sensorleft/2+sensorright/2;

sensor = sensor(begin:stop);

clear timeaxis ;

timeaxis(1) = 0;
for(i=1:(stop-begin))
    timeaxis(i+1) = timeaxis(i) + timev2(begin+i-1);
end
subplot(211)
plot(timeaxis, sensor)
hold on
smoothSensor = smooth(sensor);
% plot(timeaxis, smoothSensor);

timeaxisNew = 0:timeaxis(end)/N:timeaxis(end);
smoothInterpolateSensor = spline(timeaxis,smoothSensor,timeaxisNew);

plot(timeaxisNew, smoothInterpolateSensor);


dx = transpose(-diff(smoothSensor));
dt = timeaxis(2:end) - timeaxis(1:end-1);

speed = dx./dt;

speedMean = movmean(speed,11);
speedMeanSmooth = smooth(speedMean);


speedMeanSmoothInt = spline(timeaxis(2:end),speedMeanSmooth,timeaxisNew);

subplot(212)
plot(timeaxis(2:end),speed)
hold on
plot(timeaxis(2:end),speedMeanSmooth)
hold on 
plot(timeaxisNew, speedMeanSmoothInt);

accPosCurve = smoothInterpolateSensor;
accCurve = speedMeanSmoothInt;

