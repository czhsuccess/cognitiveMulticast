function out_link = get_linkweight(link_node)
% ����������
%   ��ø��ڵ�����
% ���������
%   link_node: ��������������·��n*3����ÿһ�д���һ���ڵ㣬��[�ڵ�� x���� y����]
% ���������
%   out_link:  �����n*n�׾����������ڵ��ľ���
%--------------------------------------------------------------------------

[r_node,] = size(link_node);
out_link = zeros(r_node, r_node);                          
for i = 1 : r_node
    for j = 1 : r_node
        if (j == i) 
            continue;
        end
        d_xcor = link_node(i, 2) - link_node(j, 2);
        d_ycor = link_node(i, 3) - link_node(j, 3);
        d_link = sqrt(d_xcor^2+ d_ycor^2); 
        out_link(i, j) = d_link;   
    end
end