function plotcircle(x, y, r, da, str)
% 参数
% x, y为圆心坐标
% r为半径
%sita=0:pi/20:2*pi;

seta = 0 : pi / da : 2 * pi; %0:0.001:2*pi;
xx = x + r * cos(seta);
yy = y + r * sin(seta);
plot(xx, yy, str);
% axis square 