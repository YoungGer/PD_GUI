function [table_cell] = get_files_status()

dirs_list = dir('../data');
table_cell = cell(size(dirs_list,1)-2,2);
for i=3:size(dirs_list,1)
    % name
    table_cell{i-2,1} =  dirs_list(i).name;
    % status
    filename = ['F:\¾Ö·½GUI\data\', dirs_list(i).name, '\pd_all.csv'];
    if exist(filename, 'file')==2
        table_cell{i-2,2} = 'Processed';
    else
        table_cell{i-2,2} = 'NULL';
    end
end

end
