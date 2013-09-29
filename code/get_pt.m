function pt = get_pt(mat_tree)
% 功能描述：
%   根据所给出的多波树确定发送节点，并赋予初值
% 输入参数：
%   mat_tree：源节点到目的节点的单/多播树，N * 2矩阵，每一行为：[目的节点号，源节点号]
% 输出参数：
%   pt:  输出: 各发送节点初值
%--------------------------------------------------------------------------
n = length(mat_tree);
pt = 10*zeros(n,1);
dd = mat_tree(:, 2);
num_node = dd(dd ~= 0);
num_scrn = unique(num_node);

n_scrn = length(num_scrn);

for i = 1:n_scrn
    pt(num_scrn(i)) = 10;
end 