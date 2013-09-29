function N_k = find_k_hop(mat_G,num,k)
% 功能描述：
%   根据给出的节点num，找到此节点k阶相邻节点（包含节点num）组成的集合。
% 输入参数：
%   mat_G: n*2阶拓扑图，[节点号 父节点号]
%   num:  给定的节点
%   k： 相邻阶数
% 输出参数：
%   N_k: 根据k跳相邻信息得到的集合
%--------------------------------------------------------------------------

n = length(mat_G);

%若k等于0，说明结果是num节点本身
if(k == 0)    
    
    for k = 1:n
        if(mat_G(k,1) == num)
            break;
        end
    end
    
    N_k = mat_G(k,1);
    return;
    
else
    
    %递归调用前一结果
    N_k_temp = find_k_hop(mat_G,num,k-1);
    m = length(N_k_temp); 
    
    for i = 1:m
        for j = 1:n  
            if((mat_G(j,1) == N_k_temp(i)) || (mat_G(j,2) == N_k_temp(i)));
                p = length(N_k_temp);
                N_k_temp(p+1) = mat_G(j,1);
                N_k_temp(p+2) = mat_G(j,2);
            end            
        end
    end
    
    %去掉含0的节点和重复的节点
    B = reshape(N_k_temp,1,[]);
    C = B(B ~= 0);
    N_k = unique(C);

end
    