function [pd] = prpd_analysis(full_name)

% 读取数据获得文件
[data] = read_pd_data(full_name);
[features, data_cell] = extract_signal2(data, -1);

% pd=0初始值 
pd =0
% load('features.mat');

% 抽取特征
l_rise_time = features(:, 4);
l_loc = features(:, 1);
l_flag = features(:, 7);
l_pv = features(:, 6);
l_t = features(:, 17);
l_w = features(:, 18);
l_tw = [l_t, l_w];


% TW聚类
k = 3;
color_l = ['r.', 'b.', 'm.', 'y.', 'c.'];
if ((length(l_tw))<3)
    return
end
[kmeans_idx, ctrs] = kmeans(l_tw, k);


for k=1:3
    % 对每个类别用PRPD相位图谱
    for i = 1:k
        % get subset data， 得到该聚类的子数据
        l_loc_sub = l_loc(kmeans_idx==i);
        l_theta_sub = l_loc_sub./2000000.*2.*pi;
        l_pv_sub = l_pv(kmeans_idx==i);
        l_flag_sub = l_flag(kmeans_idx==i);
        if (length(l_loc_sub)<3)    
            continue;
        end
        % get pos and neg parts 将正、负数据分开
        pos_theta = l_theta_sub(l_flag_sub==1);
        pos_pv = l_pv_sub(l_flag_sub==1);
        neg_theta = l_theta_sub(l_flag_sub==-1);
        neg_pv = l_pv_sub(l_flag_sub==-1);
        length(pos_theta);
        length(neg_theta);

        %将极坐标投影到x,y轴上
        pos_x = pos_pv.*cos(pos_theta);
        pos_y = pos_pv.*sin(pos_theta);
        neg_x = neg_pv.*cos(neg_theta);
        neg_y = neg_pv.*sin(neg_theta);


        %% k==1 单相放电

        if (length(pos_theta)<1 | length(neg_theta)<1) 
            display('no k==1');
        else    

            % 计算聚类中心
            [pos_idx1, pos_ctrs1_] = kmeans([pos_x, pos_y], 1);
            [neg_idx1, neg_ctrs1_] = kmeans([neg_x, neg_y], 1);
            % 坐标变换
            [pos_theta_, pos_rho_] = cart2pol(pos_ctrs1_(:,1), pos_ctrs1_(:,2))
            [neg_theta_, neg_rho_] = cart2pol(neg_ctrs1_(:,1), neg_ctrs1_(:,2))
            pos_ctrs1 = [pos_theta_, pos_rho_];
            neg_ctrs1 = [neg_theta_, neg_rho_];

            pos_ctr_theta = pos_ctrs1(1);
            pos_ctr_pv = pos_ctrs1(2);
            neg_ctr_theta = neg_ctrs1(1);
            neg_ctr_pv = neg_ctrs1(2);

            diff_angle = abs(pos_ctr_theta-neg_ctr_theta);
            display('!!!k=1');
            display(diff_angle) ;
            if (diff_angle>pi*0.9 & diff_angle<pi*1.1)  %放电判据
               display('!!!pd') ;
               pd = 1;
               return
            end
        end

        %% k==2 双相放电

        % k==2
        if (length(pos_theta)<2 | length(neg_theta)<2) 
            display('no k==2');
        else
            % 计算聚类中心
            [pos_idx2, pos_ctrs2_] = kmeans([pos_x, pos_y], 2);
            [neg_idx2, neg_ctrs2_] = kmeans([neg_x, neg_y], 2);
            % 坐标变换
            [pos_theta_, pos_rho_] = cart2pol(pos_ctrs2_(:,1), pos_ctrs2_(:,2))
            [neg_theta_, neg_rho_] = cart2pol(neg_ctrs2_(:,1), neg_ctrs2_(:,2))
            pos_ctrs2 = [pos_theta_, pos_rho_];
            neg_ctrs2 = [neg_theta_, neg_rho_];

            pos_ctrs2 = sort(pos_ctrs2);
            neg_ctrs2 = sort(neg_ctrs2);  

            %计算相对中心点角度
            diff_angle1 = abs(pos_ctrs2(1)-neg_ctrs2(1));
            diff_angle2 = abs(pos_ctrs2(2)-neg_ctrs2(2));
            %计算相邻中心点角度
            neg_angle1 = abs(pos_ctrs2(1)-pos_ctrs2(2));
            neg_angle2 = abs(neg_ctrs2(1)-neg_ctrs2(2));

            %判据
            if (diff_angle1>pi*0.9 & diff_angle1<pi*1.1) & ...
               (diff_angle2>pi*0.9 & diff_angle2<pi*1.1) & ...
               ((neg_angle1>pi/3*0.9 & neg_angle1<pi/3*1.1) | (neg_angle1>pi*2/3*0.9 & neg_angle1<pi*2/3*1.1))   & ...
               ((neg_angle2>pi/3*0.9 & neg_angle2<pi/3*1.1) | (neg_angle2>pi*2/3*0.9 & neg_angle2<pi*2/3*1.1))
               display('!!!pd') 
               pd = 2;
               return;
            end


        end

        %% k==3 三相放电

        if (length(pos_theta)<3 | length(neg_theta)<3) 
            display('no k==3');
        else
            % k==3
            % 计算聚类中心
            [pos_idx3, pos_ctrs3_] = kmeans([pos_x, pos_y], 3);
            [neg_idx3, neg_ctrs3_] = kmeans([neg_x, neg_y], 3);


            % 坐标变换
            [pos_theta_, pos_rho_] = cart2pol(pos_ctrs3_(:,1), pos_ctrs3_(:,2))
            [neg_theta_, neg_rho_] = cart2pol(neg_ctrs3_(:,1), neg_ctrs3_(:,2))
            pos_ctrs3 = [pos_theta_, pos_rho_];
            neg_ctrs3 = [neg_theta_, neg_rho_];
            
            pos_ctrs3 = sort(pos_ctrs3);
            neg_ctrs3 = sort(neg_ctrs3);



            %计算相对中心点角度
            diff_angle1 = abs(pos_ctrs3(1)-neg_ctrs3(1));
            diff_angle2 = abs(pos_ctrs3(2)-neg_ctrs3(2));
            diff_angle3 = abs(pos_ctrs3(3)-neg_ctrs3(3));
            %计算相邻中心点角度
            neg_angle1 = abs(pos_ctrs3(1)-pos_ctrs3(2));
            neg_angle2 = abs(pos_ctrs3(2)-pos_ctrs3(3));
            neg_angle3 = abs(neg_ctrs3(1)-neg_ctrs3(2));
            neg_angle4 = abs(neg_ctrs3(2)-neg_ctrs3(3));

            %判据
            if (diff_angle1>pi*0.9 & diff_angle1<pi*1.1) & ...
               (diff_angle2>pi*0.9 & diff_angle2<pi*1.1) & ...
               (diff_angle3>pi*0.9 & diff_angle3<pi*1.1) & ...
               ((neg_angle1>pi/3*0.9 & neg_angle1<60*1.1) | (neg_angle1>pi*2/3*0.9 & neg_angle1<pi*2/3*1.1))   & ...
               ((neg_angle2>pi/3*0.9 & neg_angle2<60*1.1) | (neg_angle2>pi*2/3*0.9 & neg_angle2<pi*2/3*1.1))   & ...
               ((neg_angle3>pi/3*0.9 & neg_angle3<60*1.1) | (neg_angle3>pi*2/3*0.9 & neg_angle3<pi*2/3*1.1))   & ...
               ((neg_angle4>pi/3*0.9 & neg_angle4<60*1.1) | (neg_angle4>pi*2/3*0.9 & neg_angle4<pi*2/3*1.1))   
               display('!!!pd') 
               pd = 3;
               return

            end


        end

    end
end

end