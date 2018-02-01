function [filepath] = batch_select()

% get files
[filename, filepath] = uigetfile('*');

% judge if trc or txt
if strcmp(filename(length(filename)-2:length(filename)), 'trc')
    trc_flag = 1;
else
    trc_flag = 0;
end

if trc_flag
    fileLists = dir([filepath, '*.trc']);
else
    fileLists = dir([filepath, '*.txt']);
end

% get crition rise time
[rt_pd, rt_noise] = get_pd_noise_rt();

%% iterate
N = size(fileLists, 1);
for i = 1:N
    % name
    filename = fileLists(i).name;
    full_name = [filepath filename];
    
    % get data from txt or trc
    if trc_flag
        data = ReadLeCroyBinaryWaveform(full_name);
        data=data.y*1000;
    else
        fileID = fopen(full_name);
        data = fscanf(fileID, '%f');
        fclose(fileID);
        data = data*1000;
    end
    
    % extract signal
    [data, SavedSignal, NoShakeSignalStartMaxStop] = extract_signal(data, -1);
    
    data = data';
    for j = 1:size(SavedSignal, 1)
        %if (abs(SavedSignal(j,4)-rt_pd) < abs(SavedSignal(j,4)-rt_noise))
        if (SavedSignal(j,4)>=4)
            dlmwrite([filepath, 'pd_all.csv'], SavedSignal(j,:), 'delimiter', ',','-append');
        else
            dlmwrite([filepath, 'noise_all.csv'], SavedSignal(j,:), 'delimiter', ',','-append');
        end

        %dlmwrite('pd_noise_all.csv', SavedSignal(j,:), 'delimiter', ',','-append');
        %dlmwrite('pd_noise_all_orig_data.csv', data(SavedSignal(j,19)-100:SavedSignal(j,20)+100), 'delimiter', ',','-append');
        
%         dlmwrite([filepath 'pd_noise_all.csv'], SavedSignal(j,:), 'delimiter', ',','-append');
%         dlmwrite([filepath 'pd_noise_all_orig_data.csv'], data(SavedSignal(j,19)-100:SavedSignal(j,20)+100), 'delimiter', ',','-append');
    end
    
end

end
