function pt = get_pt(mat_tree)
% ����������
%   �����������Ķನ��ȷ�����ͽڵ㣬�������ֵ
% ���������
%   mat_tree��Դ�ڵ㵽Ŀ�Ľڵ�ĵ�/�ಥ����N * 2����ÿһ��Ϊ��[Ŀ�Ľڵ�ţ�Դ�ڵ��]
% ���������
%   pt:  ���: �����ͽڵ��ֵ
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