function [A,b,beaconLocMeas] = localization_5(TDOA,mic) 
  
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
        b(i) = (TDOA(i))^2-(norm(mic(:,n)))^2+(norm(mic(:,k)))^2;
        i = i+1;
        end
        g = g+1;
     end
   b = transpose(b);
   
   y = inv(transpose(A)*A)*transpose(A)*b;
   beaconLocMeas = y;
end