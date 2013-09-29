function cel_tree = find_maxchild(mat_tree,r,pt,noise,gain)
% 功能描述：
%   获得多播树中各发送节点中耗能最大的孩子节点
% 输入参数：
%   mat_tree：源节点到目的节点的单/多播树，N * 2矩阵，每一行为：[目的节点号，源节点号]
%   pt：达到纳什均衡后各节点的发送功率
%   gain：各节点间的链路增益
%   r：各节点对信噪比的要求
%   noise：各节点周围的热噪声
% 输出参数：
%   cel_tree: 输出，元包树结构：
%             每个节点存放数据结构:
%             struct('currnode',[],  % 当前节点
%               'fathernode',[],     % 父节点
%               'childnode',[],      % 子节点
%               'n_child',[]，       % 子节点数目
%               'max_child'[],)      % 最耗能孩子节点      
%--------------------------------------------------------------------------
dd = mat_tree(:, 2);
num_node = dd(dd ~= 0);
num_scrn = unique(num_node);

n_scrn = length(num_scrn);
n_node = length(mat_tree(:, 1));
  

for i = 1 : n_scrn
    cur.currnode = num_scrn(i);
    for j = 1 : n_node
        if (mat_tree(j, 1) == cur.currnode) 
            break; 
        end
    end
    
    cur.fathernode = mat_tree(j, 2);
    nn = find(mat_tree(:, 2) == cur.currnode);
    rr = mat_tree(:, 1);
    cur.childnode = rr(nn);
    cur.n_child = length(nn);
    
    %对父节点的所有孩子节点建立矩阵no，用于存放父节点到达每个孩子节点所需的最小功率
    no = zeros(cur.n_child,1);  
    
    %计算该父节点下的每个孩子节点所需的发送功率
    for k = 1:cur.n_child 
        
        %排除当前父节点和正在计算的某个孩子节点
        num_temp = num_scrn(num_scrn ~= cur.childnode(k) & num_scrn ~= cur.currnode); 
        %排除以上两个无效节点后剩下的有效节点
        num_length = length(num_temp);                                             
                                                      
        for l = 1:num_length       
            if (num_length == 0) 
               break;
            end   
            no(k,1) = no(k,1) + pt(num_temp(l,1))*gain(num_temp(l,1),cur.childnode(k));
        end
        no(k,1) = (no(k,1)+noise(cur.childnode(k),1))*r(cur.childnode(k),1)/...
                 gain(cur.currnode,cur.childnode(k));
        no_max = 0;
        if(no(k,1) > no_max)
                no_max = no(k,1);
                cur.max_child = cur.childnode(k);
        end       
    end  
    tmp_tree{i} = cur;
    
end
cel_tree = tmp_tree;