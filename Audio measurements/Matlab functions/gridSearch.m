function loc = gridSearch(TDOA,mic)
%GRIDSEARCH Summary of this function goes here
%   Detailed explanation goes here
N = 100;
for(x=1:N)
    for(y = 1:N)
        xcoord = (x-N/2)/N*4.6;
        ycoord = (y-N/2)/N*4.6;
        TDOAideal = TDOA_gen([xcoord,ycoord],mic,5);
        error(x,y) = norm(TDOAideal-TDOA);
    end
end
figure
loge = -log(error);
heatmap(-log(error));
        

loc = 0;
end

