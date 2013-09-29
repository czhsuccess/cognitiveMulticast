function N_k = find_k_hop(mat_G,num,k)
% ����������
%   ���ݸ����Ľڵ�num���ҵ��˽ڵ�k�����ڽڵ㣨�����ڵ�num����ɵļ��ϡ�
% ���������
%   mat_G: n*2������ͼ��[�ڵ�� ���ڵ��]
%   num:  �����Ľڵ�
%   k�� ���ڽ���
% ���������
%   N_k: ����k��������Ϣ�õ��ļ���
%--------------------------------------------------------------------------

n = length(mat_G);

%��k����0��˵�������num�ڵ㱾��
if(k == 0)    
    
    for k = 1:n
        if(mat_G(k,1) == num)
            break;
        end
    end
    
    N_k = mat_G(k,1);
    return;
    
else
    
    %�ݹ����ǰһ���
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
    
    %ȥ����0�Ľڵ���ظ��Ľڵ�
    B = reshape(N_k_temp,1,[]);
    C = B(B ~= 0);
    N_k = unique(C);

end
    