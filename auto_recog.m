% 得到所有特征，包含T,W,location,peak_voltage,polarity
% choose data callback, get features

main_path = 'E:\PDData\t1\t2\t3\t4';
dir0 = dir(main_path);
% iterate Hunterson
features = [];
pulses = {};
for i0 = 3:size(dir0,1)
    name1 = dir0(i0).name;
    full_name = fullfile(main_path, dir0(i0).name);  %file
    % get data
    [data] = read_pd_data(full_name);
    % get features
    [feature, data_cell] = extract_signal2(data, -1);
    features = [features; feature];
    %pulses = [pulses, data_cell];
end
    

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
 

%% test prpd

i0 = 8;
name1 = dir0(i0).name;
full_name = fullfile(main_path, dir0(i0).name);  %file
% get data
[data] = read_pd_data(full_name);
% get features
[feature, data_cell] = extract_signal2(data, -1);
    
features = feature;
l_rise_time = features(:, 4);
l_loc = features(:, 1);
l_flag = features(:, 7);
l_pv = features(:, 6);
l_t = features(:, 17);
l_w = features(:, 18);
l_tw = [l_t, l_w];

plot(l_loc, l_pv.*l_flag, '.')

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
    % get subset data
    l_loc_sub = l_loc(idx==i);
    l_theta_sub = l_loc_sub./2000000.*2.*pi;
    l_pv_sub = l_pv(idx==i);
    l_flag_sub = l_flag(idx==i);
    if (length(l_loc_sub)<3)    
        continue;
    end
    % get pos and neg parts
    pos_theta = l_theta_sub(l_flag_sub==1);
    pos_pv = l_pv_sub(l_flag_sub==1);
    neg_theta = l_theta_sub(l_flag_sub==-1);
    neg_pv = l_pv_sub(l_flag_sub==-1);
    length(pos_theta);
    length(neg_theta);
    
    
    %% k==1

    if (length(pos_theta)<1 | length(neg_theta)<1) 
        display('no k==1');
    else    
        pos_ctr_theta = mean(pos_theta);
        pos_ctr_pv = mean(pos_pv);
        neg_ctr_theta = mean(neg_theta);
        neg_ctr_pv = mean(neg_pv);
        if (abs(pos_ctr_theta-neg_ctr_theta)/2/pi<0.314)
           display('!!!pd') ;
        end

        % plot
        figure;
        polar(pos_theta, pos_pv, 'b.')
        hold on;
        polar(pos_ctr_theta, pos_ctr_pv, 'bo' )
        polar(pos_ctr_theta, pos_ctr_pv, 'bx' )
        polar(neg_theta, neg_pv, 'r^')
        polar(neg_ctr_theta, neg_ctr_pv, 'ro')
        polar(neg_ctr_theta, neg_ctr_pv, 'rx')
        hold off;
    end
    
    %% k==2

    % k==2
    if (length(pos_theta)<2 | length(neg_theta)<2) 
        display('no k==2');
    else
        [pos_idx2, pos_ctrs2] = kmeans([pos_theta, pos_pv], 2);
        [neg_idx2, neg_ctrs2] = kmeans([neg_theta, neg_pv], 2);

        figure;
        polar(pos_theta(pos_idx2==1), pos_pv(pos_idx2==1), 'b.')
        hold on;
        polar(pos_ctrs2(1,1), pos_ctrs2(1,2), 'bo' )
        polar(pos_ctrs2(1,1), pos_ctrs2(1,2), 'bx' )
        polar(pos_theta(pos_idx2==2), pos_pv(pos_idx2==2), 'b+')
        polar(pos_ctrs2(2,1), pos_ctrs2(2,2), 'bo' )
        polar(pos_ctrs2(2,1), pos_ctrs2(2,2), 'bx' )

        polar(neg_theta(neg_idx2==1), neg_pv(neg_idx2==1), 'r.')
        polar(neg_ctrs2(1,1), neg_ctrs2(1,2), 'ro' )
        polar(neg_ctrs2(1,1), neg_ctrs2(1,2), 'rx' )
        polar(neg_theta(neg_idx2==2), neg_pv(neg_idx2==2), 'r+')
        polar(neg_ctrs2(2,1), neg_ctrs2(2,2), 'ro' )
        polar(neg_ctrs2(2,1), neg_ctrs2(2,2), 'rx' )
        hold off;

        pos_ctrs2 = sort(pos_ctrs2);
        neg_ctrs2 = sort(neg_ctrs2);
        if (abs(pos_ctrs2(1)-neg_ctrs2(1))/2/pi<0.314) & (abs(pos_ctrs2(2)-neg_ctrs2(2))/2/pi<0.314) & ...
            ((abs(pos_ctrs2(1)-pos_ctrs2(2))/2/pi<0.314/3) |(abs(pos_ctrs2(1)-pos_ctrs2(2))/2/pi<0.314/2) ) & ...
            ((abs(neg_ctrs2(1)-neg_ctrs2(2))/2/pi<0.314/3) |(abs(neg_ctrs2(1)-neg_ctrs2(2))/2/pi<0.314/2) )
           display('!!!pd') 
        end
    end

    %% k==3
   
    if (length(pos_theta)<3 | length(neg_theta)<3) 
        display('no k==3');
    else
        % k==3
        [pos_idx3, pos_ctrs3] = kmeans([pos_theta, pos_pv], 3);
        [neg_idx3, neg_ctrs3] = kmeans([neg_theta, neg_pv], 3);

        figure;
        polar(pos_theta(pos_idx3==1), pos_pv(pos_idx3==1), 'b.')
        hold on;
        polar(pos_ctrs3(1,1), pos_ctrs3(1,2), 'bo' )
        polar(pos_ctrs3(1,1), pos_ctrs3(1,2), 'bx' )
        polar(pos_theta(pos_idx3==2), pos_pv(pos_idx3==2), 'b+')
        polar(pos_ctrs3(2,1), pos_ctrs3(2,2), 'bo' )
        polar(pos_ctrs3(2,1), pos_ctrs3(2,2), 'bx' )
        polar(pos_theta(pos_idx3==3), pos_pv(pos_idx3==3), 'bx')
        polar(pos_ctrs3(3,1), pos_ctrs3(3,2), 'bo' )
        polar(pos_ctrs3(3,1), pos_ctrs3(3,2), 'bx' )

        polar(neg_theta(neg_idx3==1), neg_pv(neg_idx3==1), 'r.')
        polar(neg_ctrs3(1,1), neg_ctrs3(1,2), 'ro' )
        polar(neg_ctrs3(1,1), neg_ctrs3(1,2), 'rx' )
        polar(neg_theta(neg_idx3==2), neg_pv(neg_idx3==2), 'r+')
        polar(neg_ctrs3(2,1), neg_ctrs3(2,2), 'ro' )
        polar(neg_ctrs3(2,1), neg_ctrs3(2,2), 'rx' )
        polar(neg_theta(neg_idx3==3), neg_pv(neg_idx3==3), 'rx')
        polar(neg_ctrs3(3,1), neg_ctrs3(3,2), 'ro' )
        polar(neg_ctrs3(3,1), neg_ctrs3(3,2), 'rx' )
        hold off;

        pos_ctrs3 = sort(pos_ctrs3);
        neg_ctrs3 = sort(neg_ctrs3);
        if (abs(pos_ctrs3(1)-neg_ctrs3(1))/2/pi<0.314) & (abs(pos_ctrs3(2)-neg_ctrs3(2))/2/pi<0.314) &  (abs(pos_ctrs3(3)-neg_ctrs3(3))/2/pi<0.314) & ...
            ((abs(pos_ctrs3(1)-pos_ctrs3(2))/2/pi<0.314/3) |(abs(pos_ctrs3(1)-pos_ctrs3(2))/2/pi<0.314/2) ) & ...
            ((abs(pos_ctrs3(3)-pos_ctrs3(2))/2/pi<0.314/3) |(abs(pos_ctrs3(3)-pos_ctrs3(2))/2/pi<0.314/2) ) & ...
            ((abs(neg_ctrs3(1)-neg_ctrs3(2))/2/pi<0.314/3) |(abs(neg_ctrs3(1)-neg_ctrs3(2))/2/pi<0.314/2) ) & ...
            ((abs(neg_ctrs3(3)-neg_ctrs3(2))/2/pi<0.314/3) |(abs(neg_ctrs3(3)-neg_ctrs3(2))/2/pi<0.314/2) )
           display('!!!pd') 
        end
    end
    
end







