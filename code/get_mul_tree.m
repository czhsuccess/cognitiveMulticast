%%************************************************************************
% 
% Creator:      jdd
% Date:         2009/12/18
% Copyright by jdd 2009, all right reserved.
%
%%*************************************************************************
%%*************************************************************************

function out_tree = get_mul_tree(res_tree, num_scrn, num_dstn)
% 功能描述：
%   构造从源节点到目的节点的多播树
% 输入参数：
%   res_tree: 整个网络构成的树结构
%   num_scrn: 源节点
%   num_dstn: 目的节点
% 输出参数：
%   out_tree: 输出多播树
%--------------------------------------------------------------------------

n_dstn = length(num_dstn);
[r_tree, c_tree] = size(res_tree);

% 由目的节点溯源，找到每个目的节点到源节点的一条路
for i = 1 : n_dstn
    nn = 1;
    d2s_node(i, nn) = num_dstn(i);
    while (1)
        for j = 1 : r_tree
            if (d2s_node(i, nn) ~= res_tree(j, 1)) continue; end
            nn = nn + 1; d2s_node(i, nn) = res_tree(j, 2); break;            
        end
        if (d2s_node(i, nn) == num_scrn) break; end
    end    
    n_d2sn(i) = nn;
end

% 除去多播树中不需要的分枝
rr1 = reshape(d2s_node, 1, []);
rr2 = rr1(find(rr1 ~= 0));
rr3 = unique(rr2);

[dss, nn1] = setdiff(res_tree(:, 1), rr3);
res_tree(nn1, 1) = 0;
out_tree = res_tree(find(res_tree(:, 1) ~= 0), :);
%%*************************************************************************