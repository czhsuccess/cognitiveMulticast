function gain = g(link_node,mat_tree,pct,angle,alpha)
% 功能描述：
%   获得网络中各节点间的链路增益
% 输入参数：
%   mat_tree：源节点到目的节点的单/多播树，N * 2矩阵，每一行为：[目的节点号，源节点号]
%   link_node: 待分析的所有链路，n*3矩阵，每一行代表一个节点，即[节点号 x坐标 y坐标]
%   pct：主波瓣接收宽度
%   angle：波束宽度
%   alpha：链路功耗衰减因子
% 输出参数：
%   gain:  输出，n*n阶矩阵，网络中各节点间的链路增益
%--------------------------------------------------------------------------

link_weight = get_linkweight(link_node);
[r_node,] =size(link_node);
[r_tree,] = size(mat_tree);
gain = zeros(r_node,r_node);

for i = 1:r_node
    for j = 1:r_node
        if(i == j) 
            continue; 
        end
         gain(i,j) = (1 - pct) * (1 / (link_weight(i,j)^alpha));
    end
end    
          
for i = 1:r_tree
    if(mat_tree(i,2) == 0)
        continue;
    end   
    gain(mat_tree(i,2),mat_tree(i,1)) = (360/angle)*pct*...
                     (1 / (link_weight(mat_tree(i,2),mat_tree(i,1))^alpha));
end 


            
            
            
            
            