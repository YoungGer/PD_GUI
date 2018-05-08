% 得到所有特征，包含T,W,location,peak_voltage,polarity
% choose data callback, get features
[filename, filepath] = uigetfile('*');
%filepath = 'F:\局放GUI\data\small2\';
files = dir(filepath);
features = [];
pulses = {};
%full_names = [];
for i = 3:size(files,1)
    % get full_name 
    file_name = files(i).name;
    full_name = [filepath file_name];
    %full_names = [full_names, full_name];
    % get data
    [data] = read_pd_data(full_name);
    % get features
    [feature, data_cell] = extract_signal2(data, -1);
    features = [features; feature];
    pulses = [pulses, data_cell];
end

load('test_features')
 
l_rise_time = features(:, 4);
l_loc = features(:, 1);
l_flag = features(:, 7);
l_pv = features(:, 6);
l_t = features(:, 17);
l_w = features(:, 18);
l_tw = [l_t, l_w];

% TW聚类
k = 3;
color_l = ['r.', 'b.', 'y.', 'm.', 'c.'];
[idx, ctrs] = kmeans(l_tw, k);
for i = 1:k
    hold on;
    plot(l_tw(idx==i, 1), l_tw(idx==i, 2), color_l(i*2-1:i*2));
end
plot(ctrs(:,1), ctrs(:,2), 'kx', 'MarkerSize', 12, 'LineWidth', 2);
plot(ctrs(:,1), ctrs(:,2), 'ko', 'MarkerSize', 12, 'LineWidth', 2);
hold off;

% 对每个类别用PRPD相位图谱
for i = 1:k
    
end

i = 1;
l_loc_sub = l_loc(idx==i);
l_theta_sub = l_loc_sub./2000000.*2.*pi;
l_pv_sub = l_pv(idx==i);
l_flag_sub = l_flag(idx==i);
% get pos and neg parts
pos_theta = l_theta_sub(l_flag_sub==1);
pos_pv = l_pv_sub(l_flag_sub==1);
neg_theta = l_theta_sub(l_flag_sub==-1);
neg_pv = l_pv_sub(l_flag_sub==-1);
% k==1
pos_ctr_theta = mean(pos_theta);
pos_ctr_pv = mean(pos_pv);
neg_ctr_theta = mean(neg_theta);
neg_ctr_pv = mean(neg_pv);
if (abs(pos_ctr_theta-neg_ctr_theta)/2/pi<0.314)
   display('!!!pd') 
end
% k==2
[pos_idx2, pos_ctrs2] = kmeans([pos_theta], 2);
[neg_idx2, neg_ctrs2] = kmeans([neg_theta], 2);
pos_ctrs2 = sort(pos_ctrs2);
neg_ctrs2 = sort(neg_ctrs2);
if (abs(pos_ctrs2(1)-neg_ctrs2(1))/2/pi<0.314) & (abs(pos_ctrs2(2)-neg_ctrs2(2))/2/pi<0.314) & ...
    ((abs(pos_ctrs2(1)-pos_ctrs2(2))/2/pi<0.314/3) |(abs(pos_ctrs2(1)-pos_ctrs2(2))/2/pi<0.314/2) ) & ...
    ((abs(neg_ctrs2(1)-neg_ctrs2(2))/2/pi<0.314/3) |(abs(neg_ctrs2(1)-neg_ctrs2(2))/2/pi<0.314/2) )
   display('!!!pd') 
end
% k==3
[pos_idx3, pos_ctrs3] = kmeans([pos_theta], 3);
[neg_idx3, neg_ctrs3] = kmeans([neg_theta], 3);
pos_ctrs3 = sort(pos_ctrs3);
neg_ctrs3 = sort(neg_ctrs3);
if (abs(pos_ctrs3(1)-neg_ctrs3(1))/2/pi<0.314) & (abs(pos_ctrs3(2)-neg_ctrs3(2))/2/pi<0.314) &  (abs(pos_ctrs3(3)-neg_ctrs3(3))/2/pi<0.314) & ...
    ((abs(pos_ctrs3(1)-pos_ctrs3(2))/2/pi<0.314/3) |(abs(pos_ctrs3(1)-pos_ctrs3(2))/2/pi<0.314/2) ) & ...
    ((abs(pos_ctrs3(3)-pos_ctrs3(2))/2/pi<0.314/3) |(abs(pos_ctrs3(3)-pos_ctrs3(2))/2/pi<0.314/2) ) & ...
    ((abs(neg_ctrs3(1)-neg_ctrs3(2))/2/pi<0.314/3) |(abs(neg_ctrs3(1)-neg_ctrs3(2))/2/pi<0.314/2) ) & ...
    ((abs(neg_ctrs3(3)-neg_ctrs3(2))/2/pi<0.314/3) |(abs(neg_ctrs3(3)-neg_ctrs3(2))/2/pi<0.314/2) )
   display('!!!pd') 
end



polar(pos_theta, pos_pv, 'b.')
hold on;
polar(neg_theta, neg_pv, 'r.')
hold off;





