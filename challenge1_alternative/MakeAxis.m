load("accCurveJasper165")
[forward_x, forward_t, forward_v] = curveforward(accPosCurve, timeaxisNew, 1, 201);

load("decCurve165")
[brake_t, brake_x, brake_v] = curvereverse(decPosCurve, timeaxisNew, 1,201);

D_beforewall = 50;
D_starttowall = 200;

Brake(D_beforewall, D_starttowall, forward_x, forward_v,  forward_t, brake_x, brake_v, brake_t)