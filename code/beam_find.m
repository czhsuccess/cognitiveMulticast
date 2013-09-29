function [legal_angles illegal_node] = beam_find(local_tree,mat_tree,link_node,pt,pct,noise,angle,link_weight,gain)         
% 功能描述：
%   获得多播树中各接收节点的最佳接收角度
% 输入参数：
%   local_tree: 由部分节点构成的局部树
%   mat_tree：源节点到目的节点的单/多播树，N * 2矩阵，每一行为：[目的节点号，源节点号]
%   link_node: 待分析的所有链路，n*3矩阵，每一行代表一个节点，即[节点号 x坐标 y坐标]
%              注意,link_node的节点序号需按顺序排列
%   pt：达到纳什均衡后各节点的发送功率
%   gain：各节点间的链路增益
%   pct：主波瓣接收宽度
%   angle：波束宽度
%   alpha：链路功耗衰减因子
%   noise：各节点周围的热噪声
%   link_weight: n*n阶矩阵，任意两节点间的距离
% 输出参数：
%   angles:  输出， [节点号，接收角度]
%   illegal_node： 输出，不符合SINR条件的节点
%--------------------------------------------------------------------------

%以下三行为了找出多波树的发送节点
dd = local_tree(:, 2);                        
num_node = dd(dd ~= 0);
num_scrn = unique(num_node);

%发送节点的数目
n_scrn = length(num_scrn); 

%网络中所有节点数目
[r,] = size(link_node); 

%对所有节点的接收角度进行初始化，初始化值为零
angles = zeros(r,2);

%angles有两部分组成：[节点号 角度]
angles(:,1) = link_node(:,1);

%调用mattree_to_celltree
cel_tree = mattree_to_celltree(local_tree); 

%对于多播树中的节点来说（源节点除外），每个节点只要将自己对准各自的父节点即可
for i = 1:n_scrn 
    
    for j = 1:cel_tree{i}.n_child
        
          %父节点和孩子节点的横坐标之差
          x_variable = link_node(cel_tree{i}.currnode,2) - ...
                     link_node(cel_tree{i}.childnode(j),2);
          %父节点和孩子节点的纵坐标之差       
          y_variable = link_node(cel_tree{i}.currnode,3) - ...
                     link_node(cel_tree{i}.childnode(j),3); 
                 
          %父节点和子节点之间的距离       
          dxy = sqrt(x_variable^2 + y_variable^2);
          
          %如果y_variable小于0，证明他们指向父节点的向量与x轴正方向所成角度一定是负值
          if(y_variable < 0)                                                 
             angles(cel_tree{i}.childnode(j),2) = -acos(x_variable / dxy) * 180 / pi;
          else 
             angles(cel_tree{i}.childnode(j),2) = acos(x_variable / dxy) * 180 / pi; 
          end
    end
    
end

%在所有网络节点中排除多播树节点
qq = setdiff(link_node(:,1),mat_tree(:,1)); 
%l用来保存不合SINR要求的节点集合
l = 1;  

for i = 1:length(qq)
    
    %temp做为中间变量，存储着多播树中每个节点到该节点的信噪比
    temp = zeros(n_scrn,1); 
    
    %选中一个多播树的发送节点后，此发送节点到该节点的功率为信息功率，其他发送节点到该节点的功率以及热噪声作为干扰
    for j = 1:n_scrn
        for k = 1:n_scrn
            if(k == j)                                             
                continue;
            end
           temp(j) = temp(j) + pt(num_scrn(k,1)) * gain(num_scrn(k,1),qq(i,1));
        end
        
        temp(j) = temp(j) + noise(qq(i),1);
        temp(j) = pt(num_scrn(j,1))*(360 / angle) * pct * ...
                  (1 / link_weight(num_scrn(j,1),qq(i,1))^2) / temp(j);  
    end
    
    %选择信噪比最大的一个发送节点作为该节点所指向的节点 
    mm = find(temp == max(temp));
    
    if(temp(mm) > 1)
        x = link_node(num_scrn(mm),2) - link_node(qq(i,1),2);
        y = link_node(num_scrn(mm),3) - link_node(qq(i,1),3);
        d = sqrt(x^2 + y^2);
        
        %如果y小于0，证明他们指向父节点的向量与x轴正方向所成角度一定是负值
        if(y < 0)                                                               
           angles(qq(i,1),2) = -acos(x / d) * 180/pi;          
        else
           angles(qq(i,1),2) = acos(x / d) * 180/pi;
        end 
        
    else
        illegal_node(l) = qq(i);
        l = l+1;
    end    
end

%说明有不合法的节点
if(l > 1)  
    s = length(illegal_node);
    legal_angles = zeros(r - s,2);
    
    for i = 1:r
        for j = 1:s
            if (angles(i,1) == illegal_node(j))
                angles(i,:) = 0;
            end
        end
    end
    
    mm = (angles(:,1) ~= 0);
    legal_angles = angles(mm,:);
    
else
    
   legal_angles = angles; 
   illegal_node = 0;

end    

