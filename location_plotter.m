clear all;
endpoint_x = [200 300];
endpoint_y = [300 300];
inter_x = 400;
inter_y = 200;
wallx = 800;
wally = 800;
figure('Position', [300 100 650 600])
n = 100;

for(i = 1:n)
   tic
   x(i) = 260-0.006*i^2;
   y(i) = 30*i^(0.5);
   if(i ==30)
       wallx=x(i);
       wally=y(i)+30;
   end
   plotter(x,y, endpoint_x, endpoint_y, inter_x, inter_y, wallx, wally)
   time(i)=toc;
   pause(0.1);
end

function plotter(x,y,endpointx, endpointy, interx, intery, wall_x, wall_y)
    plot(endpointx, endpointy, 'b-x','Markersize',20 ,'Linewidth', 3)
    hold on
    plot(interx, intery, 'g-x','Markersize',20 ,'Linewidth', 3)
    xlim([0 460]);
    ylim([0 460]);
    title("Final Challenge")
    plot(x,y, 'r-o')
    plot([x(end) interx],[y(end) intery], 'g')
    distance = num2str(round(sqrt((interx-x(end))^2+(intery-y(end))^2)));
    xlabel(['Distance (cm)= ' distance], 'Fontsize', 12)
    for(k = 1:21)
        circle_x(k)= wall_x+20*cos(2*pi*k/20);
        circle_y(k)= wall_y+20*sin(2*pi*k/20);
    end
    plot(wall_x, wall_y, 'k-x','Markersize',10 ,'Linewidth', 3)
    plot(circle_x,circle_y, 'k');
    hold off
end