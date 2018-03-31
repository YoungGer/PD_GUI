function [table_cell] = get_files_status()

% dirs_list = dir('../data');
% table_cell = cell(size(dirs_list,1)-2,2);
% for i=3:size(dirs_list,1)
%     % name
%     table_cell{i-2,1} =  dirs_list(i).name;
%     % status
%     filename = ['F:\局方GUI\data\', dirs_list(i).name, '\pd_all.csv'];
%     if exist(filename, 'file')==2
%         table_cell{i-2,2} = 'Processed';
%     else
%         table_cell{i-2,2} = 'NULL';
%     end
% end

table_cell = cell(3, 3);
name1 = {'实验室', 'Hunterston', 'Torness'};
name2 = {'2', '2', '3'};
name3 = {'测试电压10KV', '测试电压11KV', '无'};
table_cell(1:3,1) = name1
table_cell(1:3,2) = name2
table_cell(1:3,3) = name3



end
