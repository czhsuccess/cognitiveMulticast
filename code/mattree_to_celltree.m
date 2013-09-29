function cel_tree = mattree_to_celltree(mat_tree)
% ���������
%   net_tree��Դ�ڵ㵽Ŀ�Ľڵ�ĵ�/�ಥ����N * 2����ÿһ��Ϊ��[Ŀ�Ľڵ�ţ�Դ�ڵ��]
% ���������
%   cel_tree: Ԫ�����ṹ��
%             ÿ���ڵ������ݽṹ:
%             struct('currnode',[],  % ��ǰ�ڵ�
%               'fathernode',[],     % ���ڵ�
%               'childnode',[],      % �ӽڵ�
%               'n_child',[]��       % �ӽڵ���Ŀ
%               'w_link',[])         % ��ǰ�ڵ㵽���ӽڵ����·Ȩֵ
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