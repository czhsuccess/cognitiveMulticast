function cel_tree = find_maxchild(mat_tree,r,pt,noise,gain)
% ����������
%   ��öಥ���и����ͽڵ��к������ĺ��ӽڵ�
% ���������
%   mat_tree��Դ�ڵ㵽Ŀ�Ľڵ�ĵ�/�ಥ����N * 2����ÿһ��Ϊ��[Ŀ�Ľڵ�ţ�Դ�ڵ��]
%   pt���ﵽ��ʲ�������ڵ�ķ��͹���
%   gain�����ڵ�����·����
%   r�����ڵ������ȵ�Ҫ��
%   noise�����ڵ���Χ��������
% ���������
%   cel_tree: �����Ԫ�����ṹ��
%             ÿ���ڵ������ݽṹ:
%             struct('currnode',[],  % ��ǰ�ڵ�
%               'fathernode',[],     % ���ڵ�
%               'childnode',[],      % �ӽڵ�
%               'n_child',[]��       % �ӽڵ���Ŀ
%               'max_child'[],)      % ����ܺ��ӽڵ�      
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
    
    %�Ը��ڵ�����к��ӽڵ㽨������no�����ڴ�Ÿ��ڵ㵽��ÿ�����ӽڵ��������С����
    no = zeros(cur.n_child,1);  
    
    %����ø��ڵ��µ�ÿ�����ӽڵ�����ķ��͹���
    for k = 1:cur.n_child 
        
        %�ų���ǰ���ڵ�����ڼ����ĳ�����ӽڵ�
        num_temp = num_scrn(num_scrn ~= cur.childnode(k) & num_scrn ~= cur.currnode); 
        %�ų�����������Ч�ڵ��ʣ�µ���Ч�ڵ�
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