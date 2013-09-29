%%************************************************************************
% get_links_by_node.m��һ�����ݸ����ڵ��ţ���ýڵ�֮����·���Ӻ���
%
% Creator:      jdd
% Date:         2009/12/18
% Copyright by jdd 2009, all right reserved.
%
%%*************************************************************************
%%*************************************************************************


function out_link = get_links_by_node(link_node,alpha)
% ����������
%   ����һ�����ݸ����ڵ��ţ���ýڵ�֮����·���Ӻ����������������N���ڵ㣬��
%   ����N(N-1)����·��
% ���������
%   link_node: �����������е����нڵ�ţ�A_n*8��������ÿһ�д���һ���ڵ�a(n,x,
%             y,ta,ra,sinr,e��pb),����a(�ڵ�ţ�x���꣬y���꣬����ǣ����սǣ�
%             �����,�������������������������)
%   alpha:    �ŵ�˥��������һ��� 2 <= alpha <= 5
% ���������
%   out_link: �����·��L_n(n_1)*3����ÿһ�д���һ����·lk(s,d,c),����lk(Դ
%             �ڵ�ţ�Ŀ�Ľڵ�ţ���·Ȩֵ)
%--------------------------------------------------------------------------

% ��ýڵ���������ʼ�������·����out_link
[r_node, c_node] = size(link_node);
out_link = zeros(r_node * (r_node - 1), 3);

% ������·Դ��Ŀ�Ľڵ����·Ȩֵ
% ע����·Ȩֵ�ļ��㹫ʽ�μ�Kerry Wood�����ģ�
%     c_i,j=360*R_i*Pct^inbeam/(r_i,j^alpha*delta_min^j*S^j)
% 2 <= alpha <= 5;
% n_link��·���
n_link = 1;                             
for i = 1 : r_node
    for j = 1 : r_node
        if j == i continue; end
        out_link(n_link, 1) = link_node(i, 1);
        out_link(n_link, 2) = link_node(j, 1);
        % ����ԴĿ�Ľڵ�����d_link����·Ȩֵw_link
        d_xcor = link_node(i, 2) - link_node(j, 2);
        d_ycor = link_node(i, 3) - link_node(j, 3);
        d_link = sqrt(d_xcor * d_xcor + d_ycor * d_ycor); 
        w_link = 360 * link_node(i, 7) * link_node(i, 8) / (d_link^alpha * ...
                 link_node(j, 6) * link_node(j, 5));  
        % ����Ȩֵ�������·�У���������·���n_link
        out_link(n_link, 3) = w_link;   
        n_link = n_link + 1;
    end
end
%%*************************************************************************