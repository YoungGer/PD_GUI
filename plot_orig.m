function [handles] = plot_orig(handles)

data_ = handles.data;
SavedSignal_ = handles.SavedSignal;
NoShakeSignalStartMaxStop_ = handles.NoShakeSignalStartMaxStop;
ShakeSignalStartMaxStop_ = handles.ShakeSignalStartMaxStop;
ThresthodValue = handles.ThresthodValue;
N = handles.N;
% 
% data_size = size(data);
% m = data_size(1);
% n = data_size(2);

hold off;
if (N==1)
        data = data_;
        SavedSignal = SavedSignal_;
        NoShakeSignalStartMaxStop = NoShakeSignalStartMaxStop_;
        ShakeSignalStartMaxStop = ShakeSignalStartMaxStop_;

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


        for i0 = 1:length(start_idxs)
            m = start_idxs(i0);
            n = end_idxs(i0);
            plot(m:n, data(m:n),'r')
        end

        handles.start_idxs = start_idxs;
        handles.end_idxs = end_idxs;

        % plot shake signal data
        for idx = 1:max(1000, size(ShakeSignalStartMaxStop,1))
            if ShakeSignalStartMaxStop(idx, 2)==0
                break
            end
        end

        start_idxs = ShakeSignalStartMaxStop(1:idx-1, 2);
        end_idxs = ShakeSignalStartMaxStop(1:idx-1, 4);


        for i1 = 1:length(start_idxs)
            m = start_idxs(i1);
            n = end_idxs(i1);
            plot(m:n, data(m:n),'k')
        end


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
else
    for ii=1:N
        data = data_{ii};
        SavedSignal = SavedSignal_{ii};
        NoShakeSignalStartMaxStop = NoShakeSignalStartMaxStop_{ii};
        ShakeSignalStartMaxStop = ShakeSignalStartMaxStop_{ii};

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


        for i0 = 1:length(start_idxs)
            m = start_idxs(i0);
            n = end_idxs(i0);
            plot(m:n, data(m:n),'r')
        end

        handles.start_idxs = start_idxs;
        handles.end_idxs = end_idxs;

        % plot shake signal data
        for idx = 1:max(1000, size(ShakeSignalStartMaxStop,1))
            if ShakeSignalStartMaxStop(idx, 2)==0
                break
            end
        end

        start_idxs = ShakeSignalStartMaxStop(1:idx-1, 2);
        end_idxs = ShakeSignalStartMaxStop(1:idx-1, 4);


        for i1 = 1:length(start_idxs)
            m = start_idxs(i1);
            n = end_idxs(i1);
            plot(m:n, data(m:n),'k')
        end


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

    end
end


% handles.start_idxs = start_idxs;
% handles.end_idxs = end_idxs;
end