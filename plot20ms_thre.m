% x0 = linspace(0,3.1415926*2,2000000);
% y0 = sin(x0) * 0.005;
% y1 = ones(1,size(x0, 2)) * handles.ThresthodValue / 1000 /17.7828;
% plot(y0, 'y');
% plot(y1, 'b');


function [] = plot20ms_thre(ThresthodValue)

hold on;
x0 = linspace(0,3.1415926*2,2000000);
y1 = ones(1,size(x0, 2)) * ThresthodValue / 1000;
plot(y1, 'g');
xlim([0 2000000]);
hold off;

end
