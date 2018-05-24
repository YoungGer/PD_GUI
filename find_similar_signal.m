function [select_signal, select_data] = find_similar_signal(a)
    % 获得原始的信息与数据库信息
    % a = SavedSignal(1,:);
    a = a(:, [3,4,17,18]);
    SavedSignal = csvread('./pd_noise_all.csv');
    b = SavedSignal(:, [3,4,17,18]);
    b_data = csvread('./pd_noise_all_orig_data.csv');
    
    % 构建距离信息
    dist = [];
    for i = 1: size(b, 1)
        dist = [dist, norm(b(i,:)-a)];
    end

    % 按照距离排序
    [out, idx] = sort([dist]);
    idx = idx(1:min(5,size(idx,2)));

    % 得到更新后的信号
    select_signal = SavedSignal(idx,:);
    select_data = b_data(idx,:);

end


