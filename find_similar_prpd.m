function [M_struc] = find_similar_prpd(prpd_fp)
 
    x = load('prpd_all');
    M_struc_array = x.M_struc_array;

    rst_idx = 1;
    smallest_dist = 1e30;
    for i=1:size(M_struc_array, 1)
        pd_M = M_struc_array(i,1).pd_M;
        NOISE_M = M_struc_array(i,1).NOISE_M;
        curr_fp = [mean(pd_M(:,2).*pd_M(:,3));  mean(NOISE_M(:,2).*NOISE_M(:,3))];
        curr_dist = sum(abs(prpd_fp-curr_fp));
        if curr_dist<smallest_dist
            smallest_dist = curr_dist;
            smallest_dist = i;
        end
    end
    
    M_struc = M_struc_array(smallest_dist, 1);
end

% 
% handles.select_signal = select_signal;
% handles.select_data = select_data;
% handles.N = size(select_signal, 1);
% % set popupmenu
% b = 1:handles.N;
% set(handles.popupmenu4, 'string',  num2str(b'));
% 
% % Update handles structure
% guidata(hObject, handles);
% 
% 
