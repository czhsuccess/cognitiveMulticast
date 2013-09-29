%%************************************************************************
% drip.m 实现DRIP(Derectional Reception Incremental Protocol)算法，参见Kerry
% Wood等人论文"Derectional reception vs. directional transmission for maximum
% lifetime multicast delivery in ad-hoc networks", IFIP'06.DRIP算法是一种计算
% 量较低的启发式算法。
%
% Creator:      jdd
% Date:         2009/09/25
% Copyright by jdd 2009, all right reserved.
%
%%*************************************************************************
%%*************************************************************************


function out_tree = kerry_drip(num_scrn, num_dstn, all_node, alpha)
% 输入参数：
%   num_scrn: 原节点号。
%   num_dstn: 目的节点号集合，列向量。如果dst_node单一元素，则DRIP算法为寻找单
%             播路由树，否则为多播路由树
%   all_node: 网络中的所有节点号和参数，A_n*8矩阵，其中每一行代表一个节点a(n,
%             x,y,ta,ra,sinr,e,pb),即：a(节点号，x坐标，y坐标，发射角，接收角，
%             信噪比,可用能量,主波瓣接受能量比)
%   alpha:    信道衰减参数，一般地 2 <= alpha <= 5
% 输出参数：
%   out_tree：输出源节点到目的节点的单/多播树，数组，每一个元包含源-目的节点
%--------------------------------------------------------------------------

% 计算网络中的所有理论链路
all_link = get_links_by_node(all_node, alpha);
[r_node, c_node] = size(all_node);
num_node = all_node(:, 1);

% 源节点信息：[当前节点号，其父节点号]
n_indx = 1;
res_tree(1, 1) = num_scrn;
res_tree(1, 2) = 0;

% 除去源节点，得到新的节点集合
set_node = get_new_nodeset(all_node(:, 1), num_scrn);
% 除去所有到节点i的链路
res_link = get_new_linkset(all_link, num_scrn);

% 计算网络中所有其他节点的信息：[当前节点号，其父节点号]
while (1) 
    % 获得链路权值为最大的链路信息：[目的节点号， 源节点号]
    num_d2sn = get_dstn_node_by_bigweight(res_link); 
    if (10)
    [res_link iscircle] = elimilate_circle_link(res_link, res_tree, num_d2sn);
    if (iscircle == 1) 
        continue; 
    end
    end
    n_indx = n_indx + 1;
    res_tree(n_indx, :) = num_d2sn;        
    % 除去目的节点res_tree(n_indx，1), 得到新的节点集合
    set_node = get_new_nodeset(set_node, res_tree(n_indx, 1));
    % 除去所有到节点res_tree(n_indx，1)的链路
    res_link = get_new_linkset(res_link, res_tree(n_indx, 1));
    if (length(set_node) == 0) break; end
end

% 输出多播树结构
out_tree = get_mul_tree(res_tree, num_scrn, num_dstn);
%out_tree = res_tree;
%%*************************************************************************


%**************************************************************************
% *
% * 以下为子函数部分
% *
%**************************************************************************
function out_node = get_new_nodeset(net_node, num_node)  
% 功能描述：
%   除去节点num_node，得到新的节点集合
% 输入参数：
%   net_node: 待分析网络中的所有节点号
%   num_node: 将除去的节点号
% 输出参数：
%   out_node: 输出新的节点集合
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
% 功能描述：
%   除去目的节点为指定节点的链路
% 输入参数：
%   net_link: 待分析网络中的所有链路，L_n(n_1)*3矩阵，每一行代表一条链路lk(s,
%             d,c),即：lk(源节点号，目的节点号，链路权值)
%   num_node: 指定的节点号
% 输出参数：
%   res_link: 输出新的链路集合
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
% 功能描述：
%   获得链路权值为最大的目的节点号B
% 输入参数：
%   all_link: 待分析的所有链路，L_n(n_1)*3矩阵，每一行代表一条链路lk(s,
%             d,c),即：lk(源节点号，目的节点号，链路权值)
% 输出参数：
%   out_node:  输出: [当前节点，父节点]
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
% 功能描述：
%   除去指定的链路
% 输入参数：
%   net_link: 待分析网络中的所有链路，L_n(n_1)*3矩阵，每一行代表一条链路lk(s,
%             d,c),即：lk(源节点号，目的节点号，链路权值)
%   res_tree: 已有树结构
%   num_d2sn: 指定链路的源节点号、目的节点号
% 输出参数：
%   res_link: 输出新的链路集合
%   iscircle: 是环为：1，否则，为：0
%--------------------------------------------------------------------------

num_scrn = num_d2sn(2);
num_dstn = num_d2sn(1);
[r_tree, c_tree] = size(res_tree);
net_tree = res_tree;
net_tree(r_tree + 1, :) = num_d2sn;

% 是否存在环
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
% 功能描述：
%   判断树中是否存在环
% 输入参数：
%   net_tree: 已有树结构
% 输出参数：
%   isexist:  存在环为：1，否则，为：0
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

