
function [] = plot20ms(pre)

% 20ms的可视化
hold on;
x0 = linspace(0,3.1415926*2,2000000);
y0 = sin(x0) .* pre;
plot(y0, 'm');
xlim([0 2000000]);
hold off;

end
