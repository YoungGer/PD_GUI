function rst = database_status(refresh)

% main_path = 'D:\PDData';
% 
% dir0 = dir(main_path);
% sub_path1 = fullfile(main_path, dir0(3).name);  %Hunterson
% 
% dir1 = dir(sub_path1);
% sub_path2 = fullfile(sub_path1, dir1(3).name);  % Hunterson/Board1
% 
% dir2 = dir(sub_path2);
% sub_path3 = fullfile(sub_path2, dir2(3).name);  % Hunterston\11kVStationBD3\Tran

% start
main_path = 'D:\PDData';
main_path = 'E:\PDData';

% prepare
h_idx = getappdata(0,'h_idx');
size_h_idx = size(h_idx);
file_path = getappdata(0,'file_path');
size_file_path = size(file_path);

%% refresh update some label
if (refresh) 
    % get orig rst
    rst = load('./lib/rst.mat');
    rst = rst.rst;
    % iterate to find correspnd rst
    for j=1:length(rst)
        if (size_h_idx(1)~=0 & size_file_path(1)~=0 & isequal(file_path, cell(rst(j,8))))
            rst{j,7} = h_idx;
        end
    end
    % update rst 
    save('./lib/rst.mat', 'rst');
    % for chinese show
    for j=1:length(rst)
        if (rst{j,7}==1)
            rst{j,7} = '局部放电';
        elseif (rst{j,7}==2)
            rst{j,7} = '电晕干扰';
        elseif (rst{j,7}==3)
            rst{j,7} = '周期干扰';
        elseif (rst{j,7}==4)
            rst{j,7} = '随机干扰';
        else
            rst{j,7} = '待定';
        end
    end
    return;
end


%% get initial data
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
                % iterate file
                for i4 = 3:size(dir4, 1)
                    name5 = dir4(i4).name;
                    sub_path5 = fullfile(sub_path4, dir4(i4).name);  %txt/trc file
                    % get name cell
                    single_name = cell(1,8);
                    single_name{1,1} =  name1;
                    single_name{1,2} = name2;
                    single_name{1,3} = name3;
                    single_name{1,4} = name4; % date
                    single_name{1,5} = name5; % file
                    single_name{1,6} = -1;
                    single_name{1,7} = -1;
%                     if (size_h_idx(1)~=0 & size_file_path(1)~=0 & isequal(file_path{1}, sub_path5))
%                         single_name{1,7} = h_idx;
%                     else
%                         single_name{1,7} = -1;
%                     end
                    single_name{1,8} = sub_path5; % file path
                    rst = [rst;single_name];
            end
          
        end
    end
    end
end

%%
% rst = load('./lib/rst.mat');
% rst = rst.rst;    

%dlmwrite('./lib/rst.txt', cell2table(rst));
save('./lib/rst.mat', 'rst');
%load('./lib/rst.mat');

end