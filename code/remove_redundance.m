function std_tree = remove_redundance(mat_tree)
% 功能描述：
%   将mat_tree中的冗余分支去掉
% 输入参数：
%   mat_tree：源节点到目的节点的单/多播树(可能包含冗余分支)，N * 2矩阵，每一行为：[目的节点号，源节点号]
% 输出参数：
%   std_tree: 输出，无冗余的多播树   
%--------------------------------------------------------------------------

%如果存在冗余情况
if(length(mat_tree(:,1)) == length(unique(mat_tree(:,1))))
    std_tree = mat_tree;
else
    
    n = length(mat_tree);
    for i = 1:n
        
        %标志后面a,b是否有过交换
        sign = 0;
        
        rr = find(mat_tree(:,1) == mat_tree(i,1));
        
        if(length(rr) > 1)
            
            %此时temp_tree的长度应为2
            a = mat_tree(rr(1),2);
            b = mat_tree(rr(2),2);
            
           while(a ~= b)
               
               %寻找当前节点a的父节点
               a = mat_tree(find(mat_tree(:,1) == a),2);
               
               %如果length(a)>1，说明冗余处多于一处，此时我们换从另一节点出发
               if(length(a) > 1)
                   b = mat_tree(rr(1),2);
                   a = mat_tree(rr(2),2);
                   sign = 1;
               end    
               
               %从某一节点上溯至源节点，循环结束
               if(a == 0)
                   break;
               end
               
           end    
            
           
           %若a=0说明第rr(2)行是冗余的边，否则rr(1)是冗余的边
           if(a == b && sign == 0)
               mat_tree(rr(2),:) = [0 0];
           else
               mat_tree(rr(1),:) = [0 0];
           end
           
        end   
    
    end
    
     %将mat_tree中的含0成员去除
     std_tree = mat_tree(find(mat_tree(:,1)~=0),:);
     
end    
