function rst = database_status()

main_path = 'D:\PDData';

dir0 = dir(main_path);
sub_path1 = fullfile(main_path, dir0(3).name);  %Hunterson

dir1 = dir(sub_path1);
sub_path2 = fullfile(sub_path1, dir1(3).name);  % Hunterson/Board1

dir2 = dir(sub_path2);
sub_path3 = fullfile(sub_path2, dir2(3).name);  % Hunterston\11kVStationBD3\Tran

% start
main_path = 'D:\PDData';


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
        for i2 = 1:size(dir2, 1)
            name3 = dir2(i2).name;
            
            if name3=='.' 
               continue; 
            end
            
            sub_path3 = fullfile(sub_path2, dir2(i2).name);  %Hunterson
            dir3 = dir(sub_path3);
            % iterate date
            for i3 = 3:size(dir3, 1)
                name4 = dir3(i3).name;
                single_name = cell(1,4);
                single_name{1,1} =  name1;
                single_name{1,2} = name2;
                single_name{1,3} = name3;
                single_name{1,4} = name4;
                rst = [rst;single_name];
            end
          
        end
    end
end


end