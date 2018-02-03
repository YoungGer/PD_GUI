function [select_idx] = get_select_idx_from_popmenu(handles)

l_rise_time = handles.SavedSignal(:, 4) ;
l_loc = handles.SavedSignal(:, 1);
l_pv = handles.SavedSignal(:, 6);
l_t = handles.SavedSignal(:, 17);
l_w = handles.SavedSignal(:, 18);

c = containers.Map;
c('1') = l_rise_time;
c('2') = l_pv;
c('3') = l_t;
c('4') = l_w;
c('5') = l_loc;

fu1_idx = get(handles.fu1, 'Value');
fu1_low = str2num(get(handles.fu1_low, 'string'));
fu1_high = str2num(get(handles.fu1_high, 'string'));

fu2_idx = get(handles.fu2, 'Value');
fu2_low = str2num(get(handles.fu2_low, 'string'));
fu2_high = str2num(get(handles.fu2_high, 'string'));

fu3_idx = get(handles.fu3, 'Value');
fu3_low = str2num(get(handles.fu3_low, 'string'));
fu3_high = str2num(get(handles.fu3_high, 'string'));


select_idx = ones(size(handles.SavedSignal, 1),1)==1 ;
if fu1_low~=-1 & fu1_high~=-1
    fu_idx = c(num2str(fu1_idx)) > fu1_low &  c(num2str(fu1_idx)) < fu1_high;
    select_idx = select_idx & fu_idx;
end
if fu2_low~=-1 & fu2_high~=-1
    fu_idx = c(num2str(fu2_idx)) > fu2_low &  c(num2str(fu2_idx)) < fu2_high;
    select_idx = select_idx & fu_idx;
end
if fu3_low~=-1 & fu3_high~=-1
    fu_idx = c(num2str(fu3_idx)) > fu3_low &  c(num2str(fu3_idx)) < fu3_high;
    select_idx = select_idx & fu_idx;
end

if fu1_low==-1 & fu2_low==-1 & fu3_low==-1
    select_idx = zeros(size(handles.SavedSignal, 1),1)==1 ;
end


end
