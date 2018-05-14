% start
main_path = 'D:\PDData';
trc_files = {};
txt_files = {};


dir0 = dir(main_path);
% iterate Hunterson
rst = [];
for i0 = 3:size(dir0,1)
    name1 = dir0(i0).name;
    sub_path1 = fullfile(main_path, dir0(i0).name);  %Hunterson
    dir1 = dir(sub_path1);
    % iterate Hunterson/Board1
    for i1 = 3:size(dir1, 1)
        name2 = dir1(i1).name;
        sub_path2 = fullfile(sub_path1, dir1(i1).name);  %Hunterson
        dir2 = dir(sub_path2);
        %  iterate Hunterson/Board1/Tran
        for i2 = 3:size(dir2, 1)
            name3 = dir2(i2).name; 
            sub_path3 = fullfile(sub_path2, dir2(i2).name);  %Hunterson
            dir3 = dir(sub_path3);
            % iterate date
            for i3 = 3:size(dir3, 1)
                name4 = dir3(i3).name;
                sub_path4 = fullfile(sub_path3, dir3(i3).name);  %Hunterson
                dir4 = dir(sub_path4);
                % iterrate files
                for i4 = 3:size(dir4, 1)
                    name5 = dir4(i4).name;
                    sub_path5 = fullfile(sub_path4, dir4(i4).name);  %真正的文件
                    % 将文件分为trc和txt
                    if ( sum(sub_path5(length(sub_path5)-2:length(sub_path5))=='trc')==3)
                        trc_files = {trc_files{:}, sub_path5};
                    else
                        txt_files = {txt_files{:}, sub_path5};
                    end
                end
            end
        end
    end
end


% turn trc(lenth>2000000) into txt files
stack_files = {};
for i=1:length(trc_files)
    display(i);
    full_name = trc_files{i};
    try
        [data] = read_pd_data(full_name);
    catch
        display('Error!');
        display(full_name);
        stack_files = {stack_files{:}, full_name};
    end
    curr_size = size(data,1);
    if (curr_size>2000000)
        data=data(1:2000000);
        data = data.*1000;
        data = round(data);
        newname = [full_name(1:length(full_name)-3),'txt'];
        dlmwrite(newname, data);
        %display(newname);
    end
end




% delete all trc files
for i=1:length(trc_files)
    full_name = trc_files{i};
    delete(full_name);
end

% delete null directory
dir_length_list = [];
dir_list = [];
null_dirs = [];
for i0 = 3:size(dir0,1)
    name1 = dir0(i0).name;
    sub_path1 = fullfile(main_path, dir0(i0).name);  %Hunterson
    dir1 = dir(sub_path1);
    % iterate Hunterson/Board1
    for i1 = 3:size(dir1, 1)
        name2 = dir1(i1).name;
        sub_path2 = fullfile(sub_path1, dir1(i1).name);  %Hunterson
        dir2 = dir(sub_path2);
        %  iterate Hunterson/Board1/Tran
        for i2 = 3:size(dir2, 1)
            name3 = dir2(i2).name; 
            sub_path3 = fullfile(sub_path2, dir2(i2).name);  %Hunterson
            dir3 = dir(sub_path3);
            % iterate date
            for i3 = 3:size(dir3, 1)
                name4 = dir3(i3).name;
                sub_path4 = fullfile(sub_path3, dir3(i3).name);  %Hunterson
                dir4 = dir(sub_path4);
                dir4 = dir4(3:end);
                dir_length_list = [dir_length_list; length(dir4)];
                dir_list = [dir_list; cell({sub_path4})];
                if (length(dir4)==0)
                   null_dirs = [null_dirs;  cell({sub_path4})] ;
                end
            end
        end
    end
end
for i=1:length(null_dirs)
    full_name = null_dirs{i};
    rmdir(full_name);
end


