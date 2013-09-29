%%************************************************************************
% get_links_by_node.m是一个根据给定节点编号，获得节点之间链路的子函数
%
% Creator:      jdd
% Date:         2009/12/18
% Copyright by jdd 2009, all right reserved.
%
%%*************************************************************************
%%*************************************************************************


function out_link = get_links_by_node(link_node,alpha)
% 功能描述：
%   这是一个根据给定节点编号，获得节点之间链路的子函数；如果网络中有N个节点，则
%   将有N(N-1)条链路。
% 输入参数：
%   link_node: 待分析网络中的所有节点号，A_n*8矩阵，其中每一行代表一个节点a(n,x,
%             y,ta,ra,sinr,e，pb),即：a(节点号，x坐标，y坐标，发射角，接收角，
%             信噪比,可用能量，主波瓣接受能量比)
%   alpha:    信道衰减参数，一般地 2 <= alpha <= 5
% 输出参数：
%   out_link: 输出链路，L_n(n_1)*3矩阵，每一行代表一条链路lk(s,d,c),即：lk(源
%             节点号，目的节点号，链路权值)
%--------------------------------------------------------------------------

% 获得节点数，并初始化输出链路变量out_link
[r_node, c_node] = size(link_node);
out_link = zeros(r_node * (r_node - 1), 3);

% 计算链路源、目的节点和链路权值
% 注意链路权值的计算公式参见Kerry Wood的论文：
%     c_i,j=360*R_i*Pct^inbeam/(r_i,j^alpha*delta_min^j*S^j)
% 2 <= alpha <= 5;
% n_link链路序号
n_link = 1;                             
for i = 1 : r_node
    for j = 1 : r_node
        if j == i continue; end
        out_link(n_link, 1) = link_node(i, 1);
        out_link(n_link, 2) = link_node(j, 1);
        % 计算源目的节点间距离d_link和链路权值w_link
        d_xcor = link_node(i, 2) - link_node(j, 2);
        d_ycor = link_node(i, 3) - link_node(j, 3);
        d_link = sqrt(d_xcor * d_xcor + d_ycor * d_ycor); 
        w_link = 360 * link_node(i, 7) * link_node(i, 8) / (d_link^alpha * ...
                 link_node(j, 6) * link_node(j, 5));  
        % 保存权值到输出链路中，并递增链路序号n_link
        out_link(n_link, 3) = w_link;   
        n_link = n_link + 1;
    end
end
%%*************************************************************************