function [legal_angles illegal_node] = beam_find(local_tree,mat_tree,link_node,pt,pct,noise,angle,link_weight,gain)         
% ����������
%   ��öಥ���и����սڵ����ѽ��սǶ�
% ���������
%   local_tree: �ɲ��ֽڵ㹹�ɵľֲ���
%   mat_tree��Դ�ڵ㵽Ŀ�Ľڵ�ĵ�/�ಥ����N * 2����ÿһ��Ϊ��[Ŀ�Ľڵ�ţ�Դ�ڵ��]
%   link_node: ��������������·��n*3����ÿһ�д���һ���ڵ㣬��[�ڵ�� x���� y����]
%              ע��,link_node�Ľڵ�����谴˳������
%   pt���ﵽ��ʲ�������ڵ�ķ��͹���
%   gain�����ڵ�����·����
%   pct����������տ��
%   angle���������
%   alpha����·����˥������
%   noise�����ڵ���Χ��������
%   link_weight: n*n�׾����������ڵ��ľ���
% ���������
%   angles:  ����� [�ڵ�ţ����սǶ�]
%   illegal_node�� �����������SINR�����Ľڵ�
%--------------------------------------------------------------------------

%��������Ϊ���ҳ��ನ���ķ��ͽڵ�
dd = local_tree(:, 2);                        
num_node = dd(dd ~= 0);
num_scrn = unique(num_node);

%���ͽڵ����Ŀ
n_scrn = length(num_scrn); 

%���������нڵ���Ŀ
[r,] = size(link_node); 

%�����нڵ�Ľ��սǶȽ��г�ʼ������ʼ��ֵΪ��
angles = zeros(r,2);

%angles����������ɣ�[�ڵ�� �Ƕ�]
angles(:,1) = link_node(:,1);

%����mattree_to_celltree
cel_tree = mattree_to_celltree(local_tree); 

%���ڶಥ���еĽڵ���˵��Դ�ڵ���⣩��ÿ���ڵ�ֻҪ���Լ���׼���Եĸ��ڵ㼴��
for i = 1:n_scrn 
    
    for j = 1:cel_tree{i}.n_child
        
          %���ڵ�ͺ��ӽڵ�ĺ�����֮��
          x_variable = link_node(cel_tree{i}.currnode,2) - ...
                     link_node(cel_tree{i}.childnode(j),2);
          %���ڵ�ͺ��ӽڵ��������֮��       
          y_variable = link_node(cel_tree{i}.currnode,3) - ...
                     link_node(cel_tree{i}.childnode(j),3); 
                 
          %���ڵ���ӽڵ�֮��ľ���       
          dxy = sqrt(x_variable^2 + y_variable^2);
          
          %���y_variableС��0��֤������ָ�򸸽ڵ��������x�����������ɽǶ�һ���Ǹ�ֵ
          if(y_variable < 0)                                                 
             angles(cel_tree{i}.childnode(j),2) = -acos(x_variable / dxy) * 180 / pi;
          else 
             angles(cel_tree{i}.childnode(j),2) = acos(x_variable / dxy) * 180 / pi; 
          end
    end
    
end

%����������ڵ����ų��ಥ���ڵ�
qq = setdiff(link_node(:,1),mat_tree(:,1)); 
%l�������治��SINRҪ��Ľڵ㼯��
l = 1;  

for i = 1:length(qq)
    
    %temp��Ϊ�м�������洢�Ŷಥ����ÿ���ڵ㵽�ýڵ�������
    temp = zeros(n_scrn,1); 
    
    %ѡ��һ���ಥ���ķ��ͽڵ�󣬴˷��ͽڵ㵽�ýڵ�Ĺ���Ϊ��Ϣ���ʣ��������ͽڵ㵽�ýڵ�Ĺ����Լ���������Ϊ����
    for j = 1:n_scrn
        for k = 1:n_scrn
            if(k == j)                                             
                continue;
            end
           temp(j) = temp(j) + pt(num_scrn(k,1)) * gain(num_scrn(k,1),qq(i,1));
        end
        
        temp(j) = temp(j) + noise(qq(i),1);
        temp(j) = pt(num_scrn(j,1))*(360 / angle) * pct * ...
                  (1 / link_weight(num_scrn(j,1),qq(i,1))^2) / temp(j);  
    end
    
    %ѡ�����������һ�����ͽڵ���Ϊ�ýڵ���ָ��Ľڵ� 
    mm = find(temp == max(temp));
    
    if(temp(mm) > 1)
        x = link_node(num_scrn(mm),2) - link_node(qq(i,1),2);
        y = link_node(num_scrn(mm),3) - link_node(qq(i,1),3);
        d = sqrt(x^2 + y^2);
        
        %���yС��0��֤������ָ�򸸽ڵ��������x�����������ɽǶ�һ���Ǹ�ֵ
        if(y < 0)                                                               
           angles(qq(i,1),2) = -acos(x / d) * 180/pi;          
        else
           angles(qq(i,1),2) = acos(x / d) * 180/pi;
        end 
        
    else
        illegal_node(l) = qq(i);
        l = l+1;
    end    
end

%˵���в��Ϸ��Ľڵ�
if(l > 1)  
    s = length(illegal_node);
    legal_angles = zeros(r - s,2);
    
    for i = 1:r
        for j = 1:s
            if (angles(i,1) == illegal_node(j))
                angles(i,:) = 0;
            end
        end
    end
    
    mm = (angles(:,1) ~= 0);
    legal_angles = angles(mm,:);
    
else
    
   legal_angles = angles; 
   illegal_node = 0;

end    

