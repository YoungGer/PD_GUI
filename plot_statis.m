function [handles] = plot_statis(handles)

% 获取统计特征
l_rise_time = handles.SavedSignal(:, 4);
l_loc = handles.SavedSignal(:, 1);
l_flag = handles.SavedSignal(:, 7);
l_pv = handles.SavedSignal(:, 6);
l_t = handles.SavedSignal(:, 17);
l_w = handles.SavedSignal(:, 18);

% normal pic，20ms的可视化
axes(handles.axes4);
plot(l_loc, l_flag.*l_pv, '.')
plot20ms(5)
xlabel('PD Location')
ylabel('Peak Voltage')


% polar pic 极坐标可视化
axes(handles.axes5);
polar(l_loc, l_flag.*l_pv, '.')

% rise_time hist可视化
axes(handles.axes6);
hist(l_rise_time)
xlabel('Rise Time')

% tw mapping  tw可视化
axes(handles.axes7);
plot(l_t, l_w, '.')
xlabel('T')
ylabel('W')

end