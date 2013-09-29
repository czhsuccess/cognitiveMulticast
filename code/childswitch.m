function [new_local_tree t] = childswitch(pt,mat_tree,local_tree,link_node,r,noise,gain,pct,angle,alpha,link_weight,angles,illegal_node)
% 功能描述：
%   根据网络拓扑现有节点和已知的多波树，改变现有的多播树结构，以期达到提高网络拓扑生存时间的目的
% 输入参数：
%   mat_tree：源节点到目的节点的单/多播树，N * 2矩阵，每一行为：[目的节点号，源节点号]
%   local_tree：由部分节点构成的局部树
%   link_node: 待分析的所有链路，n*3矩阵，每一行代表一个节点，即[节点号 x坐标 y坐标]
%   pt：达到纳什均衡后各节点的发送功率
%   gain：各节点间的链路增益
%   pct：主波瓣接收宽度
%   angle：波束宽度
%   alpha：链路功耗衰减因子
%   r：各节点对信噪比的要求
%   noise：各节点周围的热噪声
%   link_weight: n*n阶矩阵，任意两节点间的距离
%   angles：各接收节点的接收角度
%   illegal_node: 不属于结构树的节点
% 输出参数：
%   new_local_tree:  输出，优化后的新局部树
%   t： 输出，局部树的最大生存时间
%--------------------------------------------------------------------------

new_local_tree = local_tree;

while(1) 

local_tree = new_local_tree;
cel_tree = find_maxchild(local_tree,r,pt,noise,gain);

%发送功率最大的节点为控制节点
[control_node] = find(pt==max(pt));                  
u_minmax = max(pt);

%对pt_temp赋初值
pt_temp = pt;                                        
angles_temp = angles;

%保存最初的u_minmax,以便和后面的u_minmax做比较以确定是否有新节点加入
pt_compare = u_minmax;

dd = local_tree(:, 2);
num_node = dd(dd ~= 0);
num_scrn = unique(num_node);

n_scrn = length(num_scrn);
n_node = length(local_tree(:, 1));

%找到控制节点的的最耗能孩子节点
for i = 1 : n_scrn
    
    if(cel_tree{i}.currnode~=control_node) 
        continue;
    end
    
    max_child = cel_tree{i}.max_child;
    
    %保存此节点
    nod1 = cel_tree{i}.currnode;
    nod2 = cel_tree{i}.fathernode;
    
end

%对invalid_node初始化
invalid_node = 0;

%找到控制节点的最耗能孩子节点的孩子节点，最耗能孩子节点的所有孩子节点构成无效节点的一部分如果最耗能孩子节点有孩子节点的话）
for i = 1 : n_scrn 
    
    if(cel_tree{i}.currnode ~= max_child) 
        continue;
    end
    invalid_node = cel_tree{i}.childnode;
end

%此时无效节点包括该节点本身以及它的孩子节点
qq = length(invalid_node);                 
invalid_node(qq+1) = max_child;
invalid_node(qq+2) = nod1;
invalid_node(qq+3) = nod2;

%寻找到属于local_tree但不属于mat_tree的节点集合
temp_node = reshape(local_tree,1,[]);
A = unique(temp_node);
B = A(find(A ~= 0));
temp_node = reshape(mat_tree,1,[]);
C = unique(temp_node);
D = C(find(C ~= 0));
non_local_node = setdiff(D,B);

%排除无效节点，获得有效节点的集合.无效节点包括invalid_node及由beam_find函数得到的illegal_node、属于local_tree但不属于mat_tree的节点集合
valid_node = setdiff(setdiff(setdiff(link_node(:,1),invalid_node),illegal_node),non_local_node);  

%有效的属于结构树且不属于功能树的节点
valid_struc_tree_node = setdiff(valid_node,local_tree(:,1));  
valid_struc_tree_node_length = length(valid_struc_tree_node);

%有效的功能树节点
valid_local_tree_node = setdiff(local_tree(:,1),invalid_node);  
valid_local_tree_node_length = length(valid_local_tree_node);

tree = local_tree;

%若此节点属于结构树且不属于功能树，则需要添加两条边：1.控制节点到此节点，2.此节点到最耗能节点；需要去掉一条边：控制节点到最耗能节点
for i = 1:valid_struc_tree_node_length           
    
    %没有合法节点直接退出
    if(valid_struc_tree_node_length == 0)
        break;
    end
    
    temp_tree = tree;
    recent_length = length(tree);
    
    temp_tree(recent_length+1,:) = [valid_struc_tree_node(i),control_node];
    temp_tree(recent_length+2,:) = [max_child,valid_struc_tree_node(i)];
   
    
    %sign为防止找不到(temp_tree(j,1)==max_child &&temp_tree(j,2)==control_node)的
    %情况(因为前几轮轮优化已经去除掉[max_child,control_node]这条边)所作的标志
    sign = 0;
    
    k = 1;
    for j = 1:(recent_length+2)
        
        %x为一个标志，保证只有第一次遇到maxchild时才执行continue
        if(temp_tree(j,1) == max_child && temp_tree(j,2) == control_node)      
            sign = 1;
            continue;
        end
            temp_tree(k,:) = temp_tree(j,:);
            k = k+1;
    end
    
    if(sign == 0)
        ulti_tree = temp_tree;
    else    
        ulti_tree = temp_tree(1:(recent_length+1),:); 
    end    

    %以下程序防止出现某个节点的入度超过1的情况
    if(length(ulti_tree(:,1)) ~= length(unique(ulti_tree(:,1))))
        continue;
    end  

    [pt converge] = relax(mat_tree,ulti_tree,link_node,pct,angle,alpha,r,noise);       %多播树结构改变后，重新计算各个发送节点的功率;pt可能不收敛，需要对relax进行修改

    if(converge == 0)
        continue;
    end

    %多波树结构改变后，重新计算各个节点的接收角度
    angles = beam_find(ulti_tree,mat_tree,link_node,pt,pct,noise,angle,link_weight,gain);    

    y = 0;
    u_max = max(pt);
    if(u_max < u_minmax)
        u_minmax = u_max;
        control_node = find(pt == max(pt));
        new_local_tree = ulti_tree;
        %将pt存储在pt_temp中，pt_temp是此时最佳拓扑的各节点发送功率
        pt_temp = pt;  
        %将angles存储在angles_temp中，angles_temp是此时最佳拓扑的各接收节点的接收角度
        angles_temp = angles;                      
        y = y+1;            
    end
    
    if(y == 1)    
       tree = ulti_tree;
    end
    
end

%若此节点属于功能树，则需要添加一条边或两条边：此节点到最耗能节点（控制节点到此节点）；需要去掉一条边：控制节点到最耗能节点
for i = 1:valid_local_tree_node_length                    
  
    if(valid_local_tree_node_length == 0)
        break;
    end
    
    temp_tree = tree;
    recent_length = length(tree);
    temp_tree(recent_length+1,:) = [max_child,valid_local_tree_node(i)];
    temp_tree(recent_length+2,:) = [valid_local_tree_node(i),control_node];
  
    k = 1;
    sign = 0;
    for j = 1:(recent_length+2)
         if(temp_tree(j,1) == max_child  && temp_tree(j,2) == control_node) 
             sign = 1;
             continue;
         end
            temp_tree(k,:) = temp_tree(j,:);
            k = k+1;
    end

    if(sign == 0)
        ulti_tree = temp_tree;
    else    
        ulti_tree = temp_tree(1:(recent_length+1),:); 
    end     

    %以下程序防止出现某个节点的入度超过1的情况
    if(length(ulti_tree(:,1)) ~= length(unique(ulti_tree(:,1))))
        continue;
    end

    %多播树结构改变后，重新计算各个发送节点的功率
    [pt converge] = relax(mat_tree,ulti_tree,link_node,pct,angle,alpha,r,noise);          
    if(converge == 0)
        continue;
    end

    %多波树结构改变后，重新计算各个节点的接收角度
    angles = beam_find(ulti_tree,mat_tree,link_node,pt,pct,noise,angle,link_weight,gain);      

    y = 0;
    u_max = max(pt);
    if(u_max < u_minmax)
        u_minmax = u_max;
        control_node = find(max(pt));
        new_local_tree = ulti_tree;
        %将pt存储在pt_temp中，pt_temp是此时最佳拓扑的各节点发送功率 
        pt_temp = pt;
        %将angles存储在angles_temp中，angles_temp是此时最佳拓扑的各接收节点的接收角度
        angles_temp = angles;                                        
        y = y+1;    
    end
    
    if(y == 1)    
       tree = ulti_tree;
    end
    
end

    %保证pt为最新网络拓扑的pt
    pt = pt_temp;                                           
    t = 1/max(pt);
    %保证angles为最新网络拓扑的angles
    angles = angles_temp;                                  

    %考虑没有新节点的加入可以降低u_minmax的情况,循环即可结束
    if(pt_compare == u_minmax)                               
       new_local_tree = local_tree; 
       break;      
    end  

end

