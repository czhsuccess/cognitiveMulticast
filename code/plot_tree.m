%%*************************************************************************
% plot_tree.m 显示所有节点相对位置和多播树结构
%
% Creator:      jdd
% Date:         2009/11/29
% Copyright by jdd 2009, all right reserved.
%
%%*************************************************************************
%%*************************************************************************


function plot_tree(net_tree, nod_coor, x_bund, y_bund)
% 输入参数：
%   net_tree: 多播树结构
%   nod_coor: 网络所有节点坐标：[节点号，xcoor, ycoor]
%   x_bund:   x轴范围
%   y_bund:   y轴范围
% 输出参数：
%--------------------------------------------------------------------------

n_indx = length(net_tree);
tre_node = net_tree;

% 将[节点号，父节点号]结构变为列向量
mul_node = zeros(n_indx, 3);
mul_node(:, 1 : 2) = tre_node(1 : n_indx, :); 
clear tre_node;
for i = 1 : n_indx
    if (mul_node(i, 2) == 0) mul_node(i, 3) = 0; continue; end
    for j = 1 : n_indx
        if (mul_node(i, 2) == mul_node(j, 1)) break; end
    end
    mul_node(i, 3) = j;
end

% [节点号(x1, y1), 父节点号（x2, y2）]
cor_xxyy = ones(n_indx, 4) * -1; 
n_node = length(nod_coor(:, 1));
for i = 1 : n_indx
    for j = 1 : n_node
        if (mul_node(i, 1) == nod_coor(j, 1))
            cor_xxyy(i, 1) = nod_coor(j, 2);
            cor_xxyy(i, 2) = nod_coor(j, 3);
        elseif (mul_node(i, 2) == nod_coor(j, 1))
            cor_xxyy(i, 3) = nod_coor(j, 2);
            cor_xxyy(i, 4) = nod_coor(j, 3);        
        end
    end
end

dd = 1; tmp_xxyy = cor_xxyy; clear cor_xxyy;
for i = 1 : n_indx
    if (tmp_xxyy(i, 4) == -1) continue; end
    cor_xxyy(dd, :) = tmp_xxyy(i, :);
    dd = dd + 1;
end
n_indx = length(cor_xxyy(:, 1));
%**************************************************************************

% 画仿真场景
dcor = 10;
cor_xmin = x_bund(1) - dcor;
cor_xmax = x_bund(2) + dcor;
cor_ymin = y_bund(1) - dcor;
cor_ymax = y_bund(2) + dcor;

figure;
plot(nod_coor(:, 2), nod_coor(:, 3), '*');
axis([cor_xmin, cor_xmax, cor_ymin, cor_ymax]);
n_node = length(nod_coor(:, 1));
%axis square

hold on
sc = int2str(nod_coor(:, 1));
text(nod_coor(:, 2) + 0.2, nod_coor(:, 3), sc);
[dxx, dyy] = dsxy2figxy(gca, cor_xxyy(:, 1), cor_xxyy(:, 2));
[sxx, syy] = dsxy2figxy(gca, cor_xxyy(:, 3), cor_xxyy(:, 4));
for i = 1 : n_indx    
    annotation('arrow',[sxx(i) dxx(i)], [syy(i) dyy(i)],'LineStyle','-','color',[1 0 0]);
    if (0)
    x0 = cor_xxyy(i, 3); y0 = cor_xxyy(i, 4); 
    dx = cor_xxyy(i, 1) - cor_xxyy(i, 3); dy = cor_xxyy(i, 2) - cor_xxyy(i, 4);
    quiver(x0, y0, dx, dy, 1, 'r', 'linewidth', 1);
    end
    
    if (0)
    P = cor_xxyy(i, 3 : 4);
    V = cor_xxyy(i, 1 : 2);
    arrowplot(P, V, 'r');
    elseif (0)
    P = [sxx(i) syy(i)];
    V = [dxx(i) dyy(i)];
    arrowplot(P, V, 'r');
    else
    end
    %arrowplot(P, V, 'r');    
    
    if (10)
        % 画各个节点辐射范围
        rad = sqrt((cor_xxyy(i, 3) - cor_xxyy(i, 1))^2 + (cor_xxyy(i, 4) - cor_xxyy(i, 2))^2);
        if (0)
        x = cor_xxyy(i, 3); y = cor_xxyy(i, 4); r = rad; da = 10;
        seta = 0: 0.001 : 2 * pi; %0 : pi / da : 2 * pi; %0 : 0.001 : 2 * pi;
        xx = x + r * cos(seta);
        yy = y + r * sin(seta);
        %plot(xx, yy, ':');
        end
        str = ':';
        plotcircle(cor_xxyy(i, 3), cor_xxyy(i, 4), rad, 100, str);
    end
end

hold off
%**************************************************************************
return

% 画树状图
figure;
treeplot((mul_node(:, 3))');
[x, y, h] = treelayout(mul_node(:, 3));
ss = int2str(mul_node(:, 1));
text(x + 0.02, y, ss);
%**************************************************************************



