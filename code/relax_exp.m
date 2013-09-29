function [new_pt converge] = relax_exp(mat_tree,link_node,pct,angle,alpha,r,noise)
% ����������
%   ��öಥ���и����ͽڵ����ѷ��͹��ʣ�ʹ֮�ﵽ��ʲ����״̬
% ���������
%   mat_tree��Դ�ڵ㵽Ŀ�Ľڵ�ĵ�/�ಥ����N * 2����ÿһ��Ϊ��[Ŀ�Ľڵ�ţ�Դ�ڵ��]
%   link_node: ��������������·��n*3����ÿһ�д���һ���ڵ㣬��[�ڵ�� x���� y����]
%   pct����������տ��
%   angle���������
%   alpha����·����˥������
%   r�����ڵ������ȵ�Ҫ��
%   noise�����ڵ���Χ��������
% ���������
%   new_pt:  ���: [�ڵ�ţ����͹���]
%--------------------------------------------------------------------------

%relax�Ƿ������ı�־
converge = 1;

pt = get_pt(mat_tree);

gain = g(link_node,mat_tree,pct,angle,alpha);
%�Է��͹��ʳ�ʼ��
new_pt=zeros(length(pt),1);       

%��������Ϊ���ҳ��ನ���ķ��ͽڵ�
dd = mat_tree(:, 2);                     
num_node = dd(dd ~= 0);
num_scrn = unique(num_node);

%���ͽڵ����Ŀ
n_scrn = length(num_scrn); 
%�ಥ���нڵ����
n_node = length(mat_tree(:, 1));

%sum�洢ǰһ��ѭ��ʱ�����ͽڵ�ķ��͹���ֵ���˴���sum���г�ʼ��
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
        
        %no�洢�����������ͽڵ�ķ��͹���ֵ���������¸ýڵ����ѷ��͹���ֵ���˴���noֵ��ʼ��
        no = zeros(cur.n_child,1);
        
        for k = 1:cur.n_child
            
            % &��&&��ʲô����
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
    
    %��ÿ�����ͽڵ�Ĺ���ֵ��ǰһ��ѭ����ֵ���бȽϣ����ж��Ƿ�ﵽNE
    for m = 1:n_scrn                          
        if(abs(sum(m) - pt(num_scrn(m))) < 0.001)
           continue;
        else
            break;
        end   
    end
    
    %�ﵽNE��ѭ������
    if(m == n_scrn)                  
        break;
    end    

    for p = 1:n_scrn
        sum(p) = pt(num_scrn(p));
    end
    
    %��ֹpt�����������
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

%��new_pt���и�ֵ
for i = 1:n_scrn                
    new_pt(tmp_tree{i}.currnode) = pt(tmp_tree{i}.currnode);
end    