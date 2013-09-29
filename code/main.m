%%*************************************************************************
% �ó�����������ģ��
%%*************************************************************************

alpha = 2;
n = 20;
x_leng = 20;
y_leng = 20;
x_coor = unifrnd(zeros(n, 1), ones(n, 1)) * x_leng;
y_coor = unifrnd(zeros(n, 1), ones(n, 1)) * y_leng;
link_node = zeros(n,8);
for i = 1:n
    link_node(i,:) = [i,x_coor(i),y_coor(i),360,60,1,100,.7];
end

num_scrn = 15;                 
num_dstn = [1 2 7 ];

out_tree = kerry_drip(num_scrn, num_dstn, link_node, alpha);
mat_tree = get_mul_tree(out_tree, num_scrn, num_dstn);

save('.\mat_tree.mat', 'mat_tree');
save('.\link_node.mat', 'link_node');

x_bund = [5 15];
y_bund =[5 15];
plot_tree(mat_tree, link_node(:,1:3), x_bund, y_bund);
nn = length(mat_tree); 
constant = nn;
n = length(link_node);
r = 1 * ones(n,1);
noise = 0.5*ones(n,1);
alpha = 2;
angle = 60;
pct = 0.7;
link_weight = get_linkweight(link_node);
gain = g(link_node,mat_tree,pct,angle,alpha);

%����pt��ʼֵ
pt = get_pt(mat_tree); 

%����relax,t0Ϊ��ʼ��������ʱ��
[new_pt converge] = relax_exp(mat_tree,link_node,pct,angle,alpha,r,noise);
if(converge == 0)
    plot_tree(mat_tree, link_node(:, 1 : 3), x_bund, y_bund);
    return;
end
t0 = 1/(max(new_pt));
    
temp_new_tree = zeros([],2);
t1 = [];

%kΪ��������
k = 2;

while(1)
    pt_compare = pt;
    pt = zeros(nn,1);
    for i = 1:nn
        N_k = find_k_hop(mat_tree,mat_tree(i,1),k);
        local_tree = find_local_tree(mat_tree,N_k);
    
        %����relax
        [new_pt converge] = relax(mat_tree,local_tree,link_node,pct,angle,alpha,r,noise);
    
        %����ÿ�εõ��Ĳ��ַ��ͽڵ㹦��ֵ�ó���ǰѭ��ȫ�巢�ͽڵ�ķ��͹���ֵ
        ff = find(new_pt ~= 0);
        pt(ff) = new_pt(ff);
    
        %��k����Ϣ�����ޣ��Ż���Ľ����������ʱ���̣����ų������ 
        if(converge == 0 || 1/(max(new_pt))<t0)
            continue;
        end
    
        %����beam_find
        [legal_angles illegal_node] = beam_find...
            (local_tree, mat_tree, link_node, new_pt, pct,noise,angle,link_weight,gain);
    
        %����childswitch
        [new_local_tree t] = childswitch...
            (new_pt,mat_tree,local_tree,link_node,r,noise,gain,pct,angle,alpha,link_weight,legal_angles,illegal_node);
    
        %����������ʱ��
        tt = length(t1);
        t1(tt+1) = t;
    
        %new_tree����ÿ���ڵ�������ڽڵ���ɵ���
        p = length(temp_new_tree);
        q = length(new_local_tree);
        temp_new_tree(p+1:p+q,:) = new_local_tree(1:q,:);

        %����ÿ���Ż����µ�mat_tree
        zz = setdiff(new_local_tree,mat_tree,'rows');
        if(~isempty(zz))
            [x,] = size(mat_tree);
            [y,] = size(zz);
            temp_mat_tree = mat_tree;
            temp_mat_tree(x+1:x+y,:) = zz;
            mat_tree = remove_redundance(temp_mat_tree);
        end

    end
    nn = length(mat_tree);
    
    %if�����Է�ֹpt��pt_compareά����ͬʱ�޷����бȽϵ��������
    %hΪpt��pt_compare��Ԫ����ͬ����Ŀ
    h = 0;
    if(length(pt_compare) == length(pt))
        for k = 1:constant
            if(pt(k) == pt_compare(k))
                h=h+1;
            end
        end
    end
    
    %����ﵽ��ʲ���⣬�˳�ѭ��
    if(h == constant)
        break;
    end    
    
end
plot_tree(mat_tree, link_node(:, 1 : 3), x_bund, y_bund);

if isempty(t1)
    t1 = t0;
end

%t1Ϊ�Ż���Ķಥ��������ʱ��
t0
t1 = min(t1)
(t1-t0)/t0
    