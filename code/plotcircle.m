function plotcircle(x, y, r, da, str)
% ����
% x, yΪԲ������
% rΪ�뾶
%sita=0:pi/20:2*pi;

seta = 0 : pi / da : 2 * pi; %0:0.001:2*pi;
xx = x + r * cos(seta);
yy = y + r * sin(seta);
plot(xx, yy, str);
% axis square 