function [A,b,beaconLocMeas] = localization_5_3D(TDOA,mic,mic3D) 

% This function generates the x,y coordinates of the audio beacon from a
% set of TDOA pairs. A and b can be read out for debugging purposes.

carHeight = 0.28;
    A = [2*transpose(mic(:,2)-mic(:,1)), -2*TDOA(1), 0, 0, 0;
         2*transpose(mic(:,3)-mic(:,1)), 0, -2*TDOA(2), 0, 0;
         2*transpose(mic(:,4)-mic(:,1)), 0, 0, -2*TDOA(3), 0;
         2*transpose(mic(:,5)-mic(:,1)), 0, 0, 0,-2*TDOA(4);
         2*transpose(mic(:,3)-mic(:,2)), 0, -2*TDOA(5), 0, 0;
         2*transpose(mic(:,4)-mic(:,2)), 0, 0, -2*TDOA(6), 0;
         2*transpose(mic(:,5)-mic(:,2)), 0, 0, 0, -2*TDOA(7);
         2*transpose(mic(:,4)-mic(:,3)), 0, 0, -2*TDOA(8), 0;
         2*transpose(mic(:,5)-mic(:,3)), 0, 0, 0, -2*TDOA(9);
         2*transpose(mic(:,5)-mic(:,4)), 0, 0, 0, -2*TDOA(10)
    ];
g=2;
i = 1;
    for(n=1:4)
        for(k=g:5)         
        b(i) = (TDOA(i))^2-(norm(mic3D(:,n)))^2+(norm(mic3D(:,k)))^2;
        i = i+1;
        end
        g = g+1;
     end
   mic3D = transpose(mic3D);
   b(1) = b(1) - carHeight*2*(mic3D(2,3)-mic3D(1,3));
   b(2) = b(2) - carHeight*2*(mic3D(3,3)-mic3D(1,3));
   b(3) = b(3) - carHeight*2*(mic3D(4,3)-mic3D(1,3));
   b(4) = b(4) - carHeight*2*(mic3D(5,3)-mic3D(1,3));
   b(5) = b(5) - carHeight*2*(mic3D(3,3)-mic3D(2,3));
   b(6) = b(6) - carHeight*2*(mic3D(4,3)-mic3D(2,3));
   b(7) = b(7) - carHeight*2*(mic3D(5,3)-mic3D(2,3));
   b(8) = b(8) - carHeight*2*(mic3D(4,3)-mic3D(3,3));
   b(9) = b(9) - carHeight*2*(mic3D(5,3)-mic3D(3,3));
   b(10) = b(10) - carHeight*2*(mic3D(5,3)-mic3D(4,3));
   b = transpose(b);
   
   y = inv(transpose(A)*A)*transpose(A)*b;
   
   % In symmetry positions it could happen that some TDOA pairs are 0, this
   % could lead to invertible matrices. The following recursion adds a
   % small value to the TDOA pairs and reruns the function. Some accuracy
   % is lost in this process
   if(any(isnan(y)))
       [~,~,beaconLocMeas] = localization_5_3D(TDOA+0.00001,mic,transpose(mic3D));
   else
        beaconLocMeas = y;
   end
end