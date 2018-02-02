function [handles] = plot_orig(handles)

data = handles.data;
SavedSignal = handles.SavedSignal;
NoShakeSignalStartMaxStop = handles.NoShakeSignalStartMaxStop;
ThresthodValue = handles.ThresthodValue;


hold off;
plot(data);
hold on;

% plot signals data
for idx = 1:max(1000, size(NoShakeSignalStartMaxStop,1))
    if NoShakeSignalStartMaxStop(idx, 2)==0
        break
    end
end

start_idxs = NoShakeSignalStartMaxStop(1:idx-1, 2);
end_idxs = NoShakeSignalStartMaxStop(1:idx-1, 8);


for i = 1:length(start_idxs)
    m = start_idxs(i);
    n = end_idxs(i);
    plot(m:n, data(m:n),'r')
end

handles.start_idxs = start_idxs;
handles.end_idxs = end_idxs;


% plot 20ms data
% x0 = linspace(0,3.1415926*2,2000000);
% y0 = sin(x0) * 0.005;
% y1 = ones(1,size(x0, 2)) * handles.ThresthodValue / 1000 /17.7828;
% plot(y0, 'y');
% plot(y1, 'b');
thre_20ms = max(abs(SavedSignal(:, 6))) * 1.1;
plot20ms(thre_20ms);
plot20ms_thre(ThresthodValue);
xlim([0 2000000]);
hold off;


handles.start_idxs = start_idxs;
handles.end_idxs = end_idxs;
end