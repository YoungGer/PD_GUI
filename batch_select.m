% get files
[filename, filepath] = uigetfile('*');
fileLists = dir([filepath, '*.trc']);
% get crition rise time
[rt_pd, rt_noise] = get_pd_noise_rt()

%% iterate
N = size(fileLists, 1);
for i = 1:N
    % name
    filename = fileLists(i).name;
    full_name = [filepath filename];
    % get data
    data = ReadLeCroyBinaryWaveform(full_name);
    data=data.y*1000;
    [data, SavedSignal, NoShakeSignalStartMaxStop] = extract_signal(data);
    
    for j = 1:size(SavedSignal, 1)
        if (abs(SavedSignal(j,4)-rt_pd) < abs(SavedSignal(j,4)-rt_noise))
            dlmwrite('pd_all.csv', SavedSignal(j,:), 'delimiter', ',','-append');
        else
            dlmwrite('noise_all.csv', SavedSignal(j,:), 'delimiter', ',','-append');
        end
    end
    
end
