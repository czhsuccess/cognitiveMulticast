function out_link = get_linkweight(link_node)
% 功能描述：
%   获得各节点间距离
% 输入参数：
%   link_node: 待分析的所有链路，n*3矩阵，每一行代表一个节点，即[节点号 x坐标 y坐标]
% 输出参数：
%   out_link:  输出，n*n阶矩阵，任意两节点间的距离
%--------------------------------------------------------------------------

[r_node,] = size(link_node);
out_link = zeros(r_node, r_node);                          
for i = 1 : r_node
    for j = 1 : r_node
        if (j == i) 
            continue;
        end
        d_xcor = link_node(i, 2) - link_node(j, 2);
        d_ycor = link_node(i, 3) - link_node(j, 3);
        d_link = sqrt(d_xcor^2+ d_ycor^2); 
        out_link(i, j) = d_link;   
    end
end