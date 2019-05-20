function Challenge1_alterative(D_tofinish, D_tostart) % D_tostart and D_tofinish is by taking the wall as a reference
if(D_tostart < D_tofinish)
   disp("Andersom")
   return
end



load("accCurveJasper165")
[forward_x, forward_t, forward_v] = curveforward(accPosCurve, timeaxisNew, 1, 201);

load("decCurve165")
[brake_t, brake_x, brake_v] = curvereverse(decPosCurve, timeaxisNew, 1,201);


Brake(D_tofinish, D_tostart, forward_x, forward_v,  forward_t, brake_x, brake_v, brake_t)
end