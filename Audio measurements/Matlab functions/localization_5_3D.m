function [A,b,beaconLocMeas] = localization_5_3D(TDOA,mic,mic3D) 
  
carHeight = 0.3;
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
    i = 1;
    q = 0;
     for(n=1:4)
        g=2+q;
        for(k=g:5)          
        b(i) = (TDOA(i))^2-(norm(mic3D(:,n)))^2+(norm(mic3D(:,k)))^2;
        g = g+1;
        i = i+1;
        end
        q = q+1;
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
   beaconLocMeas = y;
end