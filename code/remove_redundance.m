function std_tree = remove_redundance(mat_tree)
% ����������
%   ��mat_tree�е������֧ȥ��
% ���������
%   mat_tree��Դ�ڵ㵽Ŀ�Ľڵ�ĵ�/�ಥ��(���ܰ��������֧)��N * 2����ÿһ��Ϊ��[Ŀ�Ľڵ�ţ�Դ�ڵ��]
% ���������
%   std_tree: �����������Ķಥ��   
%--------------------------------------------------------------------------

%��������������
if(length(mat_tree(:,1)) == length(unique(mat_tree(:,1))))
    std_tree = mat_tree;
else
    
    n = length(mat_tree);
    for i = 1:n
        
        %��־����a,b�Ƿ��й�����
        sign = 0;
        
        rr = find(mat_tree(:,1) == mat_tree(i,1));
        
        if(length(rr) > 1)
            
            %��ʱtemp_tree�ĳ���ӦΪ2
            a = mat_tree(rr(1),2);
            b = mat_tree(rr(2),2);
            
           while(a ~= b)
               
               %Ѱ�ҵ�ǰ�ڵ�a�ĸ��ڵ�
               a = mat_tree(find(mat_tree(:,1) == a),2);
               
               %���length(a)>1��˵�����ദ����һ������ʱ���ǻ�����һ�ڵ����
               if(length(a) > 1)
                   b = mat_tree(rr(1),2);
                   a = mat_tree(rr(2),2);
                   sign = 1;
               end    
               
               %��ĳһ�ڵ�������Դ�ڵ㣬ѭ������
               if(a == 0)
                   break;
               end
               
           end    
            
           
           %��a=0˵����rr(2)��������ıߣ�����rr(1)������ı�
           if(a == b && sign == 0)
               mat_tree(rr(2),:) = [0 0];
           else
               mat_tree(rr(1),:) = [0 0];
           end
           
        end   
    
    end
    
     %��mat_tree�еĺ�0��Աȥ��
     std_tree = mat_tree(find(mat_tree(:,1)~=0),:);
     
end    
