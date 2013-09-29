function [new_pt converge] = relax_exp(mat_tree,link_node,pct,angle,alpha,r,noise)
% 功能描述：
%   获得多播树中各发送节点的最佳发送功率，使之达到纳什均衡状态
% 输入参数：
%   mat_tree：源节点到目的节点的单/多播树，N * 2矩阵，每一行为：[目的节点号，源节点号]
%   link_node: 待分析的所有链路，n*3矩阵，每一行代表一个节点，即[节点号 x坐标 y坐标]
%   pct：主波瓣接收宽度
%   angle：波束宽度
%   alpha：链路功耗衰减因子
%   r：各节点对信噪比的要求
%   noise：各节点周围的热噪声
% 输出参数：
%   new_pt:  输出: [节点号，发送功率]
%--------------------------------------------------------------------------

%relax是否收敛的标志
converge = 1;

pt = get_pt(mat_tree);

gain = g(link_node,mat_tree,pct,angle,alpha);
%对发送功率初始化
new_pt=zeros(length(pt),1);       

%以下三行为了找出多波树的发送节点
dd = mat_tree(:, 2);                     
num_node = dd(dd ~= 0);
num_scrn = unique(num_node);

%发送节点的数目
n_scrn = length(num_scrn); 
%多播树中节点个数
n_node = length(mat_tree(:, 1));

%sum存储前一此循环时各发送节点的发送功率值，此处对sum进行初始化
sum=zeros(n_scrn,1);                  

while(1)
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
        
        %no存储假设其他发送节点的发送功率值不变的情况下该节点的最佳发送功率值，此处最no值初始化
        no = zeros(cur.n_child,1);
        
        for k = 1:cur.n_child
            
            % &与&&有什么区别？
            num_temp = num_scrn(find(num_scrn ~= cur.childnode(k) & num_scrn ~= cur.currnode));
            num_length = length(num_temp);
            
            for l = 1:num_length                
                no(k,1) = no(k,1) + pt(num_temp(l,1)) *...
                        gain(num_temp(l,1),cur.childnode(k));
            end
            no(k,1) = (no(k,1) + noise(cur.childnode(k),1)) * r...
                    (cur.childnode(k)) / gain(cur.currnode,cur.childnode(k));
            
        end 
        
        %cur.max_child=cur.childnode(find(max(no)));
        cur.max_child = cur.childnode(find(no == max(no)));
        pt(cur.currnode) = max(no);
        tmp_tree{i} = cur;
        
    end
    
    %对每个发送节点的功率值与前一次循环后值进行比较，以判断是否达到NE
    for m = 1:n_scrn                          
        if(abs(sum(m) - pt(num_scrn(m))) < 0.001)
           continue;
        else
            break;
        end   
    end
    
    %达到NE，循环结束
    if(m == n_scrn)                  
        break;
    end    

    for p = 1:n_scrn
        sum(p) = pt(num_scrn(p));
    end
    
    %防止pt不收敛的情况
    qq = 0;                                  
    for q = 1:n_scrn
        if(pt(num_scrn(q))>10000000000)
            qq = qq + 1;
        end
    end

    if(qq ~= 0)
        converge = 0;
        break;
    end    

end

%对new_pt进行赋值
for i = 1:n_scrn                
    new_pt(tmp_tree{i}.currnode) = pt(tmp_tree{i}.currnode);
end    