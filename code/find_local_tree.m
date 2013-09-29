function local_tree = find_local_tree(mat_G,N_k)
% 功能描述：
%   根据给出的节点集合N_k，找到此节点k阶相邻节点（包含节点num）组成的局部多播树。
% 输入参数：
%   mat_G: n*2阶拓扑图，[节点号 父节点号]
%   N_k：局部多播树的节点集合
% 输出参数：
%   local_tree: k阶相邻节点（包含节点num）组成的局部多播树
%--------------------------------------------------------------------------

n = length(N_k);
temp_tree = zeros(n*(n-1),2);
k = 1;

%根据节点集合找到所有可能树 
for i = 1:n
    for j = 1:n
        if(i == j)
            continue;
        end
        temp_tree(k,:)=[N_k(i) N_k(j)];
        k = k + 1;
    end
end

%A为排除掉含有集合N_k中所有节点后的树
A = setdiff(mat_G,temp_tree,'rows');
%temp_local_tree为含有N_k中节点所构成的树的集合
temp_local_tree = setdiff(mat_G,A,'rows');

[p,q] = size(temp_local_tree);
parent_node = unique(temp_local_tree(:,2));
m = length(parent_node);

%sign标记所有发送节点是否为N_k构成树的源节点：是为0，否则为1
sign = zeros(m,1);

%寻找源节点
for i = 1:m
    for j = 1:p
        if(parent_node(i) == temp_local_tree(j,1))
            sign(i) = 1;
        end
    end
end

%在temp_local_tree加入[源节点号 0]
nn = find(sign == 0);
local_tree = zeros(p+1,2);
local_tree(1:p,:) = temp_local_tree;
local_tree(p+1,:) = [parent_node(nn) 0];

    

           
          
        