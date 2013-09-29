function cel_tree = mattree_to_celltree(mat_tree)
% 输入参数：
%   net_tree：源节点到目的节点的单/多播树，N * 2矩阵，每一行为：[目的节点号，源节点号]
% 输出参数：
%   cel_tree: 元包树结构：
%             每个节点存放数据结构:
%             struct('currnode',[],  % 当前节点
%               'fathernode',[],     % 父节点
%               'childnode',[],      % 子节点
%               'n_child',[]，       % 子节点数目
%               'w_link',[])         % 当前节点到其子节点的链路权值
%--------------------------------------------------------------------------

dd = mat_tree(:, 2);
num_node = dd(dd ~= 0);
num_scrn = unique(num_node);

n_scrn = length(num_scrn);
n_node = length(mat_tree(:, 1));

for i = 1 : n_scrn
    cur.currnode = num_scrn(i);
    for j = 1 : n_node
        if (mat_tree(j, 1) == cur.currnode) break; end
    end
    cur.fathernode = mat_tree(j, 2);
    nn = find(mat_tree(:, 2) == cur.currnode);
    rr = mat_tree(:, 1);
    cur.childnode = rr(nn);
    cur.n_child = length(nn);
    tmp_tree{i} = cur;
end

cel_tree = tmp_tree;