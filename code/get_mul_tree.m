%%************************************************************************
% 
% Creator:      jdd
% Date:         2009/12/18
% Copyright by jdd 2009, all right reserved.
%
%%*************************************************************************
%%*************************************************************************

function out_tree = get_mul_tree(res_tree, num_scrn, num_dstn)
% ����������
%   �����Դ�ڵ㵽Ŀ�Ľڵ�Ķಥ��
% ���������
%   res_tree: �������繹�ɵ����ṹ
%   num_scrn: Դ�ڵ�
%   num_dstn: Ŀ�Ľڵ�
% ���������
%   out_tree: ����ಥ��
%--------------------------------------------------------------------------

n_dstn = length(num_dstn);
[r_tree, c_tree] = size(res_tree);

% ��Ŀ�Ľڵ���Դ���ҵ�ÿ��Ŀ�Ľڵ㵽Դ�ڵ��һ��·
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

% ��ȥ�ಥ���в���Ҫ�ķ�֦
rr1 = reshape(d2s_node, 1, []);
rr2 = rr1(find(rr1 ~= 0));
rr3 = unique(rr2);

[dss, nn1] = setdiff(res_tree(:, 1), rr3);
res_tree(nn1, 1) = 0;
out_tree = res_tree(find(res_tree(:, 1) ~= 0), :);
%%*************************************************************************