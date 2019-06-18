function [phi] = angle3points(carx, cary, secondgoalx, secondgoaly, firstgoalx, firstgoaly)
da2 = (firstgoalx - secondgoalx)^2 + (firstgoaly - secondgoaly)^2;
db2 = (firstgoalx - carx)^2 + (firstgoaly - cary)^2; 
dc2 = (secondgoalx - carx)^2 + (secondgoaly - cary)^2;
phi = acos((da2 + db2 -dc2)/(2* sqrt(da2) * sqrt(db2)));
end