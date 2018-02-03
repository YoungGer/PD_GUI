function [] = plot_statis_mtx(handles)
x_idx = get(handles.pop_xlabel, 'Value');
y_idx = get(handles.pop_ylabel, 'Value');

l_flag = handles.SavedSignal(:, 7);
l_rise_time = handles.SavedSignal(:, 4) .* l_flag;
l_loc = handles.SavedSignal(:, 1);
l_pv = handles.SavedSignal(:, 6) .* l_flag;
l_t = handles.SavedSignal(:, 17) .* l_flag;
l_w = handles.SavedSignal(:, 18) .* l_flag;

c = containers.Map;
c('1') = l_rise_time;
c('2') = l_pv;
c('3') = l_t;
c('4') = l_w;
c('5') = l_loc;

% statis matrix plot

axes(handles.axes4);
plot(c(num2str(x_idx)), c(num2str(y_idx)), '.')
hold on;


x = c(num2str(x_idx));
y = c(num2str(y_idx));
plot(x(handles.select_idx),y(handles.select_idx), 'c.')
hold off;

% fixed prpd plot

axes(handles.axes7);
plot(l_loc, l_pv, '.')
hold on;
plot20ms(max(abs(handles.SavedSignal(:, 6))) * 1.1)
hold on;
xlabel('PD Location')
ylabel('Peak Voltage')

plot(l_loc(handles.select_idx),l_pv(handles.select_idx), 'c.')


hold off;

end