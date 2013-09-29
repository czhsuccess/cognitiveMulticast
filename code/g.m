function gain = g(link_node,mat_tree,pct,angle,alpha)
% ����������
%   ��������и��ڵ�����·����
% ���������
%   mat_tree��Դ�ڵ㵽Ŀ�Ľڵ�ĵ�/�ಥ����N * 2����ÿһ��Ϊ��[Ŀ�Ľڵ�ţ�Դ�ڵ��]
%   link_node: ��������������·��n*3����ÿһ�д���һ���ڵ㣬��[�ڵ�� x���� y����]
%   pct����������տ��
%   angle���������
%   alpha����·����˥������
% ���������
%   gain:  �����n*n�׾��������и��ڵ�����·����
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


            
            
            
            
            