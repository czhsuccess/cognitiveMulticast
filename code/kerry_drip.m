%%************************************************************************
% drip.m ʵ��DRIP(Derectional Reception Incremental Protocol)�㷨���μ�Kerry
% Wood��������"Derectional reception vs. directional transmission for maximum
% lifetime multicast delivery in ad-hoc networks", IFIP'06.DRIP�㷨��һ�ּ���
% ���ϵ͵�����ʽ�㷨��
%
% Creator:      jdd
% Date:         2009/09/25
% Copyright by jdd 2009, all right reserved.
%
%%*************************************************************************
%%*************************************************************************


function out_tree = kerry_drip(num_scrn, num_dstn, all_node, alpha)
% ���������
%   num_scrn: ԭ�ڵ�š�
%   num_dstn: Ŀ�Ľڵ�ż��ϣ������������dst_node��һԪ�أ���DRIP�㷨ΪѰ�ҵ�
%             ��·����������Ϊ�ಥ·����
%   all_node: �����е����нڵ�źͲ�����A_n*8��������ÿһ�д���һ���ڵ�a(n,
%             x,y,ta,ra,sinr,e,pb),����a(�ڵ�ţ�x���꣬y���꣬����ǣ����սǣ�
%             �����,��������,���������������)
%   alpha:    �ŵ�˥��������һ��� 2 <= alpha <= 5
% ���������
%   out_tree�����Դ�ڵ㵽Ŀ�Ľڵ�ĵ�/�ಥ�������飬ÿһ��Ԫ����Դ-Ŀ�Ľڵ�
%--------------------------------------------------------------------------

% ���������е�����������·
all_link = get_links_by_node(all_node, alpha);
[r_node, c_node] = size(all_node);
num_node = all_node(:, 1);

% Դ�ڵ���Ϣ��[��ǰ�ڵ�ţ��丸�ڵ��]
n_indx = 1;
res_tree(1, 1) = num_scrn;
res_tree(1, 2) = 0;

% ��ȥԴ�ڵ㣬�õ��µĽڵ㼯��
set_node = get_new_nodeset(all_node(:, 1), num_scrn);
% ��ȥ���е��ڵ�i����·
res_link = get_new_linkset(all_link, num_scrn);

% �������������������ڵ����Ϣ��[��ǰ�ڵ�ţ��丸�ڵ��]
while (1) 
    % �����·ȨֵΪ������·��Ϣ��[Ŀ�Ľڵ�ţ� Դ�ڵ��]
    num_d2sn = get_dstn_node_by_bigweight(res_link); 
    if (10)
    [res_link iscircle] = elimilate_circle_link(res_link, res_tree, num_d2sn);
    if (iscircle == 1) 
        continue; 
    end
    end
    n_indx = n_indx + 1;
    res_tree(n_indx, :) = num_d2sn;        
    % ��ȥĿ�Ľڵ�res_tree(n_indx��1), �õ��µĽڵ㼯��
    set_node = get_new_nodeset(set_node, res_tree(n_indx, 1));
    % ��ȥ���е��ڵ�res_tree(n_indx��1)����·
    res_link = get_new_linkset(res_link, res_tree(n_indx, 1));
    if (length(set_node) == 0) break; end
end

% ����ಥ���ṹ
out_tree = get_mul_tree(res_tree, num_scrn, num_dstn);
%out_tree = res_tree;
%%*************************************************************************


%**************************************************************************
% *
% * ����Ϊ�Ӻ�������
% *
%**************************************************************************
function out_node = get_new_nodeset(net_node, num_node)  
% ����������
%   ��ȥ�ڵ�num_node���õ��µĽڵ㼯��
% ���������
%   net_node: �����������е����нڵ��
%   num_node: ����ȥ�Ľڵ��
% ���������
%   out_node: ����µĽڵ㼯��
%--------------------------------------------------------------------------
 
[r_node, c_node] = size(net_node);
out_node = zeros(r_node - 1, c_node);

j = 1;
for i = 1 : r_node
    if (net_node(i, 1) == num_node) continue; end
    out_node(j, :) = net_node(i, :);
    j = j + 1;
end
%%*************************************************************************


function res_link = get_new_linkset(net_link, num_node)  
% ����������
%   ��ȥĿ�Ľڵ�Ϊָ���ڵ����·
% ���������
%   net_link: �����������е�������·��L_n(n_1)*3����ÿһ�д���һ����·lk(s,
%             d,c),����lk(Դ�ڵ�ţ�Ŀ�Ľڵ�ţ���·Ȩֵ)
%   num_node: ָ���Ľڵ��
% ���������
%   res_link: ����µ���·����
%--------------------------------------------------------------------------
 
[r_link, c_link] = size(net_link);
out_link = zeros(r_link, c_link);

j = 0;
for i = 1 : r_link
    if (net_link(i, 2) == num_node) continue; end
    j = j + 1;
    out_link(j, :) = net_link(i, :);
end

res_link = out_link(1 : j, :);
%%*************************************************************************


function out_node = get_dstn_node_by_bigweight(all_link)  
% ����������
%   �����·ȨֵΪ����Ŀ�Ľڵ��B
% ���������
%   all_link: ��������������·��L_n(n_1)*3����ÿһ�д���һ����·lk(s,
%             d,c),����lk(Դ�ڵ�ţ�Ŀ�Ľڵ�ţ���·Ȩֵ)
% ���������
%   out_node:  ���: [��ǰ�ڵ㣬���ڵ�]
%--------------------------------------------------------------------------

out_node(1, 1) = all_link(1, 2);
out_node(1, 2) = all_link(1, 1);
tmp_wght = all_link(1, 3);
[r_link, c_link] = size(all_link);

for i = 2 : r_link
    if (tmp_wght < all_link(i, 3))
        out_node(1, 1) = all_link(i, 2);
        out_node(1, 2) = all_link(i, 1);
        tmp_wght = all_link(i, 3);
    end    
end
%%*************************************************************************


function [res_link iscircle] = elimilate_circle_link(net_link, res_tree, num_d2sn)
% ����������
%   ��ȥָ������·
% ���������
%   net_link: �����������е�������·��L_n(n_1)*3����ÿһ�д���һ����·lk(s,
%             d,c),����lk(Դ�ڵ�ţ�Ŀ�Ľڵ�ţ���·Ȩֵ)
%   res_tree: �������ṹ
%   num_d2sn: ָ����·��Դ�ڵ�š�Ŀ�Ľڵ��
% ���������
%   res_link: ����µ���·����
%   iscircle: �ǻ�Ϊ��1������Ϊ��0
%--------------------------------------------------------------------------

num_scrn = num_d2sn(2);
num_dstn = num_d2sn(1);
[r_tree, c_tree] = size(res_tree);
net_tree = res_tree;
net_tree(r_tree + 1, :) = num_d2sn;

% �Ƿ���ڻ�
iscircle = isExistCircle(net_tree);
if (iscircle == 0)
    res_link = net_link;
    return;
end

j = 0;
[r_link, c_link] = size(net_link);
out_link = zeros(r_link, c_link);
for i = 1 : r_link
    if (net_link(i, 1) == num_scrn && net_link(i, 2) == num_dstn) continue; end
    j = j + 1;
    out_link(j, :) = net_link(i, :);
end

res_link = out_link(1 : j, :);
%%*************************************************************************


function isexist = isExistCircle(net_tree)
% ����������
%   �ж������Ƿ���ڻ�
% ���������
%   net_tree: �������ṹ
% ���������
%   isexist:  ���ڻ�Ϊ��1������Ϊ��0
%--------------------------------------------------------------------------

isexist = 0;
[r_tree, c_tree] = size(net_tree);

for i = 1 : r_tree
    nn = 2; isstop = 0;
    clear num_path;
    num_path(1) = net_tree(i, 1);
    num_path(2) = net_tree(i, 2);
    while (~isstop)
        n1 = nn;
        for j = 1 : r_tree
            if (num_path(nn) ~= net_tree(j, 1)) continue; end
            nn = nn + 1;
            num_path(nn) = net_tree(j, 2);
            [du, di] = unique(num_path);
            if (length(di) ~= nn) 
                isexist = 1; return; 
            end
        end   
        if (n1 == nn) break; end
    end
end
%%*************************************************************************

