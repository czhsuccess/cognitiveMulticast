function local_tree = find_local_tree(mat_G,N_k)
% ����������
%   ���ݸ����Ľڵ㼯��N_k���ҵ��˽ڵ�k�����ڽڵ㣨�����ڵ�num����ɵľֲ��ಥ����
% ���������
%   mat_G: n*2������ͼ��[�ڵ�� ���ڵ��]
%   N_k���ֲ��ಥ���Ľڵ㼯��
% ���������
%   local_tree: k�����ڽڵ㣨�����ڵ�num����ɵľֲ��ಥ��
%--------------------------------------------------------------------------

n = length(N_k);
temp_tree = zeros(n*(n-1),2);
k = 1;

%���ݽڵ㼯���ҵ����п����� 
for i = 1:n
    for j = 1:n
        if(i == j)
            continue;
        end
        temp_tree(k,:)=[N_k(i) N_k(j)];
        k = k + 1;
    end
end

%AΪ�ų������м���N_k�����нڵ�����
A = setdiff(mat_G,temp_tree,'rows');
%temp_local_treeΪ����N_k�нڵ������ɵ����ļ���
temp_local_tree = setdiff(mat_G,A,'rows');

[p,q] = size(temp_local_tree);
parent_node = unique(temp_local_tree(:,2));
m = length(parent_node);

%sign������з��ͽڵ��Ƿ�ΪN_k��������Դ�ڵ㣺��Ϊ0������Ϊ1
sign = zeros(m,1);

%Ѱ��Դ�ڵ�
for i = 1:m
    for j = 1:p
        if(parent_node(i) == temp_local_tree(j,1))
            sign(i) = 1;
        end
    end
end

%��temp_local_tree����[Դ�ڵ�� 0]
nn = find(sign == 0);
local_tree = zeros(p+1,2);
local_tree(1:p,:) = temp_local_tree;
local_tree(p+1,:) = [parent_node(nn) 0];

    

           
          
        