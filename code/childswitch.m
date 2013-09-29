function [new_local_tree t] = childswitch(pt,mat_tree,local_tree,link_node,r,noise,gain,pct,angle,alpha,link_weight,angles,illegal_node)
% ����������
%   ���������������нڵ����֪�Ķನ�����ı����еĶಥ���ṹ�����ڴﵽ���������������ʱ���Ŀ��
% ���������
%   mat_tree��Դ�ڵ㵽Ŀ�Ľڵ�ĵ�/�ಥ����N * 2����ÿһ��Ϊ��[Ŀ�Ľڵ�ţ�Դ�ڵ��]
%   local_tree���ɲ��ֽڵ㹹�ɵľֲ���
%   link_node: ��������������·��n*3����ÿһ�д���һ���ڵ㣬��[�ڵ�� x���� y����]
%   pt���ﵽ��ʲ�������ڵ�ķ��͹���
%   gain�����ڵ�����·����
%   pct����������տ��
%   angle���������
%   alpha����·����˥������
%   r�����ڵ������ȵ�Ҫ��
%   noise�����ڵ���Χ��������
%   link_weight: n*n�׾����������ڵ��ľ���
%   angles�������սڵ�Ľ��սǶ�
%   illegal_node: �����ڽṹ���Ľڵ�
% ���������
%   new_local_tree:  ������Ż�����¾ֲ���
%   t�� ������ֲ������������ʱ��
%--------------------------------------------------------------------------

new_local_tree = local_tree;

while(1) 

local_tree = new_local_tree;
cel_tree = find_maxchild(local_tree,r,pt,noise,gain);

%���͹������Ľڵ�Ϊ���ƽڵ�
[control_node] = find(pt==max(pt));                  
u_minmax = max(pt);

%��pt_temp����ֵ
pt_temp = pt;                                        
angles_temp = angles;

%���������u_minmax,�Ա�ͺ����u_minmax���Ƚ���ȷ���Ƿ����½ڵ����
pt_compare = u_minmax;

dd = local_tree(:, 2);
num_node = dd(dd ~= 0);
num_scrn = unique(num_node);

n_scrn = length(num_scrn);
n_node = length(local_tree(:, 1));

%�ҵ����ƽڵ�ĵ�����ܺ��ӽڵ�
for i = 1 : n_scrn
    
    if(cel_tree{i}.currnode~=control_node) 
        continue;
    end
    
    max_child = cel_tree{i}.max_child;
    
    %����˽ڵ�
    nod1 = cel_tree{i}.currnode;
    nod2 = cel_tree{i}.fathernode;
    
end

%��invalid_node��ʼ��
invalid_node = 0;

%�ҵ����ƽڵ������ܺ��ӽڵ�ĺ��ӽڵ㣬����ܺ��ӽڵ�����к��ӽڵ㹹����Ч�ڵ��һ�����������ܺ��ӽڵ��к��ӽڵ�Ļ���
for i = 1 : n_scrn 
    
    if(cel_tree{i}.currnode ~= max_child) 
        continue;
    end
    invalid_node = cel_tree{i}.childnode;
end

%��ʱ��Ч�ڵ�����ýڵ㱾���Լ����ĺ��ӽڵ�
qq = length(invalid_node);                 
invalid_node(qq+1) = max_child;
invalid_node(qq+2) = nod1;
invalid_node(qq+3) = nod2;

%Ѱ�ҵ�����local_tree��������mat_tree�Ľڵ㼯��
temp_node = reshape(local_tree,1,[]);
A = unique(temp_node);
B = A(find(A ~= 0));
temp_node = reshape(mat_tree,1,[]);
C = unique(temp_node);
D = C(find(C ~= 0));
non_local_node = setdiff(D,B);

%�ų���Ч�ڵ㣬�����Ч�ڵ�ļ���.��Ч�ڵ����invalid_node����beam_find�����õ���illegal_node������local_tree��������mat_tree�Ľڵ㼯��
valid_node = setdiff(setdiff(setdiff(link_node(:,1),invalid_node),illegal_node),non_local_node);  

%��Ч�����ڽṹ���Ҳ����ڹ������Ľڵ�
valid_struc_tree_node = setdiff(valid_node,local_tree(:,1));  
valid_struc_tree_node_length = length(valid_struc_tree_node);

%��Ч�Ĺ������ڵ�
valid_local_tree_node = setdiff(local_tree(:,1),invalid_node);  
valid_local_tree_node_length = length(valid_local_tree_node);

tree = local_tree;

%���˽ڵ����ڽṹ���Ҳ����ڹ�����������Ҫ��������ߣ�1.���ƽڵ㵽�˽ڵ㣬2.�˽ڵ㵽����ܽڵ㣻��Ҫȥ��һ���ߣ����ƽڵ㵽����ܽڵ�
for i = 1:valid_struc_tree_node_length           
    
    %û�кϷ��ڵ�ֱ���˳�
    if(valid_struc_tree_node_length == 0)
        break;
    end
    
    temp_tree = tree;
    recent_length = length(tree);
    
    temp_tree(recent_length+1,:) = [valid_struc_tree_node(i),control_node];
    temp_tree(recent_length+2,:) = [max_child,valid_struc_tree_node(i)];
   
    
    %signΪ��ֹ�Ҳ���(temp_tree(j,1)==max_child &&temp_tree(j,2)==control_node)��
    %���(��Ϊǰ�������Ż��Ѿ�ȥ����[max_child,control_node]������)�����ı�־
    sign = 0;
    
    k = 1;
    for j = 1:(recent_length+2)
        
        %xΪһ����־����ֻ֤�е�һ������maxchildʱ��ִ��continue
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

    %���³����ֹ����ĳ���ڵ����ȳ���1�����
    if(length(ulti_tree(:,1)) ~= length(unique(ulti_tree(:,1))))
        continue;
    end  

    [pt converge] = relax(mat_tree,ulti_tree,link_node,pct,angle,alpha,r,noise);       %�ಥ���ṹ�ı�����¼���������ͽڵ�Ĺ���;pt���ܲ���������Ҫ��relax�����޸�

    if(converge == 0)
        continue;
    end

    %�ನ���ṹ�ı�����¼�������ڵ�Ľ��սǶ�
    angles = beam_find(ulti_tree,mat_tree,link_node,pt,pct,noise,angle,link_weight,gain);    

    y = 0;
    u_max = max(pt);
    if(u_max < u_minmax)
        u_minmax = u_max;
        control_node = find(pt == max(pt));
        new_local_tree = ulti_tree;
        %��pt�洢��pt_temp�У�pt_temp�Ǵ�ʱ������˵ĸ��ڵ㷢�͹���
        pt_temp = pt;  
        %��angles�洢��angles_temp�У�angles_temp�Ǵ�ʱ������˵ĸ����սڵ�Ľ��սǶ�
        angles_temp = angles;                      
        y = y+1;            
    end
    
    if(y == 1)    
       tree = ulti_tree;
    end
    
end

%���˽ڵ����ڹ�����������Ҫ���һ���߻������ߣ��˽ڵ㵽����ܽڵ㣨���ƽڵ㵽�˽ڵ㣩����Ҫȥ��һ���ߣ����ƽڵ㵽����ܽڵ�
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

    %���³����ֹ����ĳ���ڵ����ȳ���1�����
    if(length(ulti_tree(:,1)) ~= length(unique(ulti_tree(:,1))))
        continue;
    end

    %�ಥ���ṹ�ı�����¼���������ͽڵ�Ĺ���
    [pt converge] = relax(mat_tree,ulti_tree,link_node,pct,angle,alpha,r,noise);          
    if(converge == 0)
        continue;
    end

    %�ನ���ṹ�ı�����¼�������ڵ�Ľ��սǶ�
    angles = beam_find(ulti_tree,mat_tree,link_node,pt,pct,noise,angle,link_weight,gain);      

    y = 0;
    u_max = max(pt);
    if(u_max < u_minmax)
        u_minmax = u_max;
        control_node = find(max(pt));
        new_local_tree = ulti_tree;
        %��pt�洢��pt_temp�У�pt_temp�Ǵ�ʱ������˵ĸ��ڵ㷢�͹��� 
        pt_temp = pt;
        %��angles�洢��angles_temp�У�angles_temp�Ǵ�ʱ������˵ĸ����սڵ�Ľ��սǶ�
        angles_temp = angles;                                        
        y = y+1;    
    end
    
    if(y == 1)    
       tree = ulti_tree;
    end
    
end

    %��֤ptΪ�����������˵�pt
    pt = pt_temp;                                           
    t = 1/max(pt);
    %��֤anglesΪ�����������˵�angles
    angles = angles_temp;                                  

    %����û���½ڵ�ļ�����Խ���u_minmax�����,ѭ�����ɽ���
    if(pt_compare == u_minmax)                               
       new_local_tree = local_tree; 
       break;      
    end  

end

