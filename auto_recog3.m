function [pd] = classify_pd_human(features, data, handles)

pd =0
% load('features.mat');

l_rise_time = features(:, 4);
l_loc = features(:, 1);
l_flag = features(:, 7);
l_pv = features(:, 6);
l_t = features(:, 17);
l_w = features(:, 18);
l_tw = [l_t, l_w];


% TW聚类
k = 2;
color_l = ['r.', 'b.', 'm.', 'y.', 'c.'];
if ((length(l_tw))<k)
    return
end
[kmeans_idx, ctrs] = kmeans(l_tw, k);
axes(handles.axes10);
for i = 1:k
    hold on;
    plot(l_tw(kmeans_idx==i, 1), l_tw(kmeans_idx==i, 2), color_l(i*2-1:i*2));
end
plot(ctrs(:,1), ctrs(:,2), 'kx', 'MarkerSize', 12, 'LineWidth', 2);
plot(ctrs(:,1), ctrs(:,2), 'ko', 'MarkerSize', 12, 'LineWidth', 2);
hold off;

% 对每个类别用PRPD相位图谱
for i = 1:k
    % get subset data
    l_loc_sub = l_loc(kmeans_idx==i);
    l_theta_sub = l_loc_sub./2000000.*2.*pi;
    l_pv_sub = l_pv(kmeans_idx==i);
    l_flag_sub = l_flag(kmeans_idx==i);
    if (length(l_loc_sub)<3)    
        continue;
    end
    % get pos and neg parts
    pos_theta = l_theta_sub(l_flag_sub==1);
    pos_pv = l_pv_sub(l_flag_sub==1);
    neg_theta = l_theta_sub(l_flag_sub==-1);
    neg_pv = l_pv_sub(l_flag_sub==-1);
    length(pos_theta);
    length(neg_theta);
    
        
    %将极坐标投影到x,y轴上
    pos_x = pos_pv.*cos(pos_theta);
    pos_y = pos_pv.*sin(pos_theta);
    neg_x = neg_pv.*cos(neg_theta);
    neg_y = neg_pv.*sin(neg_theta);
    
    
    %% k==1 单相放电

    if (length(pos_theta)<1 | length(neg_theta)<1) 
        display('no k==1');
    else    
        % 计算聚类中心
        [pos_idx1, pos_ctrs1_] = kmeans([pos_x, pos_y], 1);
        [neg_idx1, neg_ctrs1_] = kmeans([neg_x, neg_y], 1);
        % 坐标变换
        [pos_theta_, pos_rho_] = cart2pol(pos_ctrs1_(:,1), pos_ctrs1_(:,2))
        [neg_theta_, neg_rho_] = cart2pol(neg_ctrs1_(:,1), neg_ctrs1_(:,2))
        pos_ctrs1 = [pos_theta_, pos_rho_];
        neg_ctrs1 = [neg_theta_, neg_rho_];
        
        
        pos_ctr_theta = pos_ctrs1(1);
        pos_ctr_pv = pos_ctrs1(2);
        neg_ctr_theta = neg_ctrs1(1);
        neg_ctr_pv = neg_ctrs1(2);
        
%         pos_ctr_theta = mean(pos_theta);
%         pos_ctr_pv = mean(pos_pv);
%         neg_ctr_theta = mean(neg_theta);
%         neg_ctr_pv = mean(neg_pv);
        
        
        diff_angle = abs(pos_ctr_theta-neg_ctr_theta);
        if (diff_angle>pi*0.9 & diff_angle<pi*1.1)  %放电判据
           display('!!!pd') ;
           pd = 1;
      
           %text12
           if (i==1)
               set(handles.text12, 'string', '发现');
           elseif(i==2)
               set(handles.text15, 'string', '发现');
           end
        end

        % plot
        if (i==1)
            axes(handles.axes1);
        elseif (i==2)
            axes(handles.axes2);
        else
            axes(handles.axes3);
        end
        polar(pos_theta, pos_pv, 'b.')
        hold on;
        polar(pos_ctr_theta, pos_ctr_pv, 'bo' )
        polar(pos_ctr_theta, pos_ctr_pv, 'bx' )
        polar(neg_theta, neg_pv, 'r.')
        polar(neg_ctr_theta, neg_ctr_pv, 'ro')
        polar(neg_ctr_theta, neg_ctr_pv, 'rx')
        hold off;
    end
    
    %% k==2  双相放电

    % k==2
    if (length(pos_theta)<2 | length(neg_theta)<2) 
        display('no k==2');
    else
        
        % 计算聚类中心
        [pos_idx2, pos_ctrs2_] = kmeans([pos_x, pos_y], 2);
        [neg_idx2, neg_ctrs2_] = kmeans([neg_x, neg_y], 2);
        % 坐标变换
        [pos_theta_, pos_rho_] = cart2pol(pos_ctrs2_(:,1), pos_ctrs2_(:,2))
        [neg_theta_, neg_rho_] = cart2pol(neg_ctrs2_(:,1), neg_ctrs2_(:,2))
        pos_ctrs2 = [pos_theta_, pos_rho_];
        neg_ctrs2 = [neg_theta_, neg_rho_];
        
%         [pos_idx2, pos_ctrs2] = kmeans([pos_theta, pos_pv], 2);
%         [neg_idx2, neg_ctrs2] = kmeans([neg_theta, neg_pv], 2);

        if (i==1)
            axes(handles.axes4);
        elseif (i==2)
            axes(handles.axes5);
        else
            axes(handles.axes6);
        end
        polar(pos_theta(pos_idx2==1), pos_pv(pos_idx2==1), 'b.')
        hold on;
        polar(pos_ctrs2(1,1), pos_ctrs2(1,2), 'bo' )
        polar(pos_ctrs2(1,1), pos_ctrs2(1,2), 'bx' )
        polar(pos_theta(pos_idx2==2), pos_pv(pos_idx2==2), 'b.')
        polar(pos_ctrs2(2,1), pos_ctrs2(2,2), 'bo' )
        polar(pos_ctrs2(2,1), pos_ctrs2(2,2), 'bx' )

        polar(neg_theta(neg_idx2==1), neg_pv(neg_idx2==1), 'r.')
        polar(neg_ctrs2(1,1), neg_ctrs2(1,2), 'ro' )
        polar(neg_ctrs2(1,1), neg_ctrs2(1,2), 'rx' )
        polar(neg_theta(neg_idx2==2), neg_pv(neg_idx2==2), 'r.')
        polar(neg_ctrs2(2,1), neg_ctrs2(2,2), 'ro' )
        polar(neg_ctrs2(2,1), neg_ctrs2(2,2), 'rx' )
        hold off;

        pos_ctrs2 = sort(pos_ctrs2);
        neg_ctrs2 = sort(neg_ctrs2);
        
        

        %计算相对中心点角度
        diff_angle1 = abs(pos_ctrs2(1)-neg_ctrs2(1));
        diff_angle2 = abs(pos_ctrs2(2)-neg_ctrs2(2));
        %计算相邻中心点角度
        neg_angle1 = abs(pos_ctrs2(1)-pos_ctrs2(2));
        neg_angle2 = abs(neg_ctrs2(1)-neg_ctrs2(2));

        %判据
        if (diff_angle1>pi*0.9 & diff_angle1<pi*1.1) & ...
           (diff_angle2>pi*0.9 & diff_angle2<pi*1.1) & ...
           ((neg_angle1>pi/3*0.9 & neg_angle1<pi/3*1.1) | (neg_angle1>pi*2/3*0.9 & neg_angle1<pi*2/3*1.1))   & ...
           ((neg_angle2>pi/3*0.9 & neg_angle2<pi/3*1.1) | (neg_angle2>pi*2/3*0.9 & neg_angle2<pi*2/3*1.1))
           display('!!!pd') 
           pd = 2;
            %text13
            if (i==1)
                   set(handles.text13, 'string', '发现');
             elseif(i==2)
               set(handles.text16, 'string', '发现');
            end
        end
        
        
    end

    %% k==3 三相放电
   
    if (length(pos_theta)<3 | length(neg_theta)<3) 
        display('no k==3');
    else
        % k==3
%         [pos_idx3, pos_ctrs3] = kmeans([pos_theta, pos_pv], 3);
%         [neg_idx3, neg_ctrs3] = kmeans([neg_theta, neg_pv], 3);

        % k==3
        % 计算聚类中心
        [pos_idx3, pos_ctrs3_] = kmeans([pos_x, pos_y], 3);
        [neg_idx3, neg_ctrs3_] = kmeans([neg_x, neg_y], 3);

        
        % 坐标变换
        [pos_theta_, pos_rho_] = cart2pol(pos_ctrs3_(:,1), pos_ctrs3_(:,2))
        [neg_theta_, neg_rho_] = cart2pol(neg_ctrs3_(:,1), neg_ctrs3_(:,2))
        pos_ctrs3 = [pos_theta_, pos_rho_];
        neg_ctrs3 = [neg_theta_, neg_rho_];

        if (i==1)
            axes(handles.axes7);
        elseif (i==2)
            axes(handles.axes8);
        else
            axes(handles.axes9);
        end
        polar(pos_theta(pos_idx3==1), pos_pv(pos_idx3==1), 'b.')
        hold on;
        polar(pos_ctrs3(1,1), pos_ctrs3(1,2), 'bo' )
        polar(pos_ctrs3(1,1), pos_ctrs3(1,2), 'bx' )
        polar(pos_theta(pos_idx3==2), pos_pv(pos_idx3==2), 'b.')
        polar(pos_ctrs3(2,1), pos_ctrs3(2,2), 'bo' )
        polar(pos_ctrs3(2,1), pos_ctrs3(2,2), 'bx' )
        polar(pos_theta(pos_idx3==3), pos_pv(pos_idx3==3), 'b.')
        polar(pos_ctrs3(3,1), pos_ctrs3(3,2), 'bo' )
        polar(pos_ctrs3(3,1), pos_ctrs3(3,2), 'bx' )

        polar(neg_theta(neg_idx3==1), neg_pv(neg_idx3==1), 'r.')
        polar(neg_ctrs3(1,1), neg_ctrs3(1,2), 'ro' )
        polar(neg_ctrs3(1,1), neg_ctrs3(1,2), 'rx' )
        polar(neg_theta(neg_idx3==2), neg_pv(neg_idx3==2), 'r.')
        polar(neg_ctrs3(2,1), neg_ctrs3(2,2), 'ro' )
        polar(neg_ctrs3(2,1), neg_ctrs3(2,2), 'rx' )
        polar(neg_theta(neg_idx3==3), neg_pv(neg_idx3==3), 'r.')
        polar(neg_ctrs3(3,1), neg_ctrs3(3,2), 'ro' )
        polar(neg_ctrs3(3,1), neg_ctrs3(3,2), 'rx' )
        hold off;

        pos_ctrs3 = sort(pos_ctrs3);
        neg_ctrs3 = sort(neg_ctrs3);


        %计算相对中心点角度
        diff_angle1 = abs(pos_ctrs3(1)-neg_ctrs3(1));
        diff_angle2 = abs(pos_ctrs3(2)-neg_ctrs3(2));
        diff_angle3 = abs(pos_ctrs3(3)-neg_ctrs3(3));
        %计算相邻中心点角度
        neg_angle1 = abs(pos_ctrs3(1)-pos_ctrs3(2));
        neg_angle2 = abs(pos_ctrs3(2)-pos_ctrs3(3));
        neg_angle3 = abs(neg_ctrs3(1)-neg_ctrs3(2));
        neg_angle4 = abs(neg_ctrs3(2)-neg_ctrs3(3));

        %判据
        if (diff_angle1>pi*0.9 & diff_angle1<pi*1.1) & ...
           (diff_angle2>pi*0.9 & diff_angle2<pi*1.1) & ...
           (diff_angle3>pi*0.9 & diff_angle3<pi*1.1) & ...
           ((neg_angle1>pi/3*0.9 & neg_angle1<60*1.1) | (neg_angle1>pi*2/3*0.9 & neg_angle1<pi*2/3*1.1))   & ...
           ((neg_angle2>pi/3*0.9 & neg_angle2<60*1.1) | (neg_angle2>pi*2/3*0.9 & neg_angle2<pi*2/3*1.1))   & ...
           ((neg_angle3>pi/3*0.9 & neg_angle3<60*1.1) | (neg_angle3>pi*2/3*0.9 & neg_angle3<pi*2/3*1.1))   & ...
           ((neg_angle4>pi/3*0.9 & neg_angle4<60*1.1) | (neg_angle4>pi*2/3*0.9 & neg_angle4<pi*2/3*1.1))   
           display('!!!pd') 
           pd = 3;
            if (i==1)
                   set(handles.text14, 'string', '发现');
            elseif(i==2)
               set(handles.text17, 'string', '发现');
            end
        end
    end
    
end

%% axes11 plot

pre_thre = -1;
% extract signals
power_ratio = 1/17.7828;  % -25db channel 2


AverageValue = mean(data); 
data=data-AverageValue;
AverageValue = mean(abs(data));
PeakValue = max(abs(data));
StandardDiv = std(abs(data));
CrestFactor=PeakValue/StandardDiv;
FormFactor=StandardDiv/AverageValue;
PeakVSAverageLog=log10(PeakValue/AverageValue);
STDVSAverageLog=log10(FormFactor);

% set thresholf value
if (pre_thre>0)
    ThresthodValue = pre_thre/power_ratio;
else
    ThresthodValue=1.5*median(abs(data))/0.6745*sqrt(2*log(length(data)))*PeakVSAverageLog;
end
[PDStartStopMaxPoint]=GetWaveShape(data ,0, 0 ,ThresthodValue);%获取所有信号大概的起始点终止点


[ShakeSignal,NoShakeSignal,ShakeSignalStartMaxStop,NoShakeSignalStartMaxStop]=ClassifiyShakingWave(PDStartStopMaxPoint,data,data,0);
ShakeSignal=ShakeSignal*power_ratio/1000;
NoShakeSignal=NoShakeSignal*power_ratio/1000;
data=data*power_ratio/1000;


% calculate signlas params
 
%xiaodi的Kmeans中用到的参数：第一行是PD位置，第二行是PD种类，第三行是信号宽度，第四行是上升时间，第五行是幅值，第六行是极性
SavedSignal=zeros(NoShakeSignalStartMaxStop(1,1),20);
SavedSignalForKmeans=zeros(NoShakeSignalStartMaxStop(1,1),18);
SavedSignalForKohonenMappingSinglePulse=zeros(NoShakeSignalStartMaxStop(1,1),5);
SavedSignalForKohonenMapingWhole20mS=zeros(1,11);
SavedSignalForKohonenMapingWhole20mSBuffer=zeros(1,5);

 for index=1:1:NoShakeSignalStartMaxStop(1,1)

   %%for Kmeans begin     
   Evaluationdata=NoShakeSignal(NoShakeSignalStartMaxStop(index,3):NoShakeSignalStartMaxStop(index,7),1);
   

   
   %Get Signal waveform 
   PDLocation=NoShakeSignalStartMaxStop(index,5);%%最大值点即为PD的位置
   SavedSignal(index,1)=PDLocation;
   PDType=3;
   SavedSignal(index,2) =PDType;
   PDWidth=NoShakeSignalStartMaxStop(index,7)-NoShakeSignalStartMaxStop(index,3);%信号长度为结束点减起始点
   SavedSignal(index,3)=PDWidth;
   RiseTime=NoShakeSignalStartMaxStop(index,5)-NoShakeSignalStartMaxStop(index,3);%上升时间为峰值点减起始点
   SavedSignal(index,4)=RiseTime;
   SavedSignal(index,5)=PDWidth-RiseTime;
   PDManitude=abs(NoShakeSignal(NoShakeSignalStartMaxStop(index,5),1));
   SavedSignal(index,6)=PDManitude;
   if(NoShakeSignal(NoShakeSignalStartMaxStop(index,5),1)<0)
   PDPole=-1;
   else
     PDPole=1;
   end
   SavedSignal(index,7)=PDPole;
   SavedSignal(index,8)=mean(Evaluationdata);
%   SavedSignal(index,9)=realsqrt(Evaluationdata);  %%？？？？？？？？？？？？？是否是这个？？？？？
    SavedSignal(index,9) = sqrt(mean(Evaluationdata.^2));%%？？？？？？？？？？？？？是否是这个？？？？？
   SavedSignal(index,10)=std(Evaluationdata);     
   SavedSignal(index,11)=skewness(Evaluationdata); 
   SavedSignal(index,12)=kurtosis(Evaluationdata); 
   SavedSignal(index,13)=PDManitude/SavedSignal(index,9); 
   SavedSignal(index,14)=SavedSignal(index,9)/ SavedSignal(index,8);
   SavedSignal(index,15)=ComputeMainFrequency(Evaluationdata);%计算信号主频 
   SavedSignal(index,16)= 360*PDLocation/2000000;%
   % add new T&W
   [T, W]=TW1(Evaluationdata);
   SavedSignal(index,17)= T;  
   SavedSignal(index,18)= W;
   
   
   % 19 20, start_idxs end_idxs
   SavedSignal(index,19) = NoShakeSignalStartMaxStop(index, 2);
   SavedSignal(index,20) = NoShakeSignalStartMaxStop(index, 8);

   %xiaodi的Kmeans中用到的参数：第一行是PD位置，第二行是PD种类，第三行是信号宽度，第四行是上升时间，第五行是幅值，第六行是极性
    
   SavedSignalForKmeans(index,1)=SavedSignal(index,1);%%PDLocation
        SavedSignalForKmeans(index,2)=3;%PDType  
           SavedSignalForKmeans(index,3)=SavedSignal(index,3);%PDWidth
              SavedSignalForKmeans(index,4)=SavedSignal(index,4);%RiseTime
                 SavedSignalForKmeans(index,5)=SavedSignal(index,6);%PDManitude
                    SavedSignalForKmeans(index,6)=SavedSignal(index,7);%PDPole
                    
                          SavedSignalForKmeans(index,7)=SavedSignal(index,5);%Fall time
                                  SavedSignalForKmeans(index,8)=SavedSignal(index,8);%mean(Evaluationdata);Average value of voltage，
                                     SavedSignalForKmeans(index,9)=SavedSignal(index,9);%Root mean square (RMS) ，
                                        SavedSignalForKmeans(index,10)=SavedSignal(index,10);%Standard deviation
SavedSignalForKmeans(index,10)=SavedSignal(index,4);%!!!!!RiseTime，暂时把这个参数存起来用在kohonenMapping中
                                    SavedSignalForKmeans(index,11)=SavedSignal(index,11);%Skewness；
                                  SavedSignalForKmeans(index,12)=SavedSignal(index,12);%Kurtosis；
                             SavedSignalForKmeans(index,13)=SavedSignal(index,13);%Crest factor （( maximum magnitude over R.M.S)）
                             
                        SavedSignalForKmeans(index,14)=SavedSignal(index,14);%Form factor ( R.M.S magnitude over average value)
 SavedSignalForKmeans(index,14)=SavedSignal(index,14);%Form factor ( R.M.S magnitude over average value)信号种类
                   SavedSignalForKmeans(index,15)=SavedSignal(index,15);%Frequency spectrum
             SavedSignalForKmeans(index,16)=SavedSignal(index,16);%Phase angle ψi and time ti of occurrence of a PD pulse，ψi =360(ti/T)
         
             
             SavedSignalForKmeans(index,17)=SavedSignal(index,17);%T-W mapping---T
    SavedSignalForKmeans(index,18)=SavedSignal(index,18);%T-W mapping---W
    

    
    
    % add features
    
    SavedSignalForKohonenMappingSinglePulse(index,1)=SavedSignal(index,4);%!!!!!RiseTime
    SavedSignalForKohonenMappingSinglePulse(index,2)=SavedSignal(index,11);%Skewness；
     SavedSignalForKohonenMappingSinglePulse(index,3)=SavedSignal(index,12);%Kurtosis 
         SavedSignalForKohonenMappingSinglePulse(index,4)=SavedSignal(index,13);%Crest factor （( maximum magnitude over R.M.S)）
             SavedSignalForKohonenMappingSinglePulse(index,5)=11;%信号种类 
             
             
        
 end


ThresthodValue = ThresthodValue*power_ratio;


% plot original data

hold off;
axes(handles.axes11);
plot(data, 'y');
hold on;

% plot non-shake signals data (red)
for idx = 1:max(1000, size(NoShakeSignalStartMaxStop,1))
    if NoShakeSignalStartMaxStop(idx, 2)==0
        break
    end
end
start_idxs = NoShakeSignalStartMaxStop(1:idx-1, 2);
end_idxs = NoShakeSignalStartMaxStop(1:idx-1, 8);
for i = 1:length(start_idxs)
    m = start_idxs(i);
    n = end_idxs(i);
    plot(m:n, data(m:n),'k')
end
% plot shake signal data
for idx = 1:max(1000, size(ShakeSignalStartMaxStop,1))
    if ShakeSignalStartMaxStop(idx, 2)==0
        break
    end
end
start_idxs = ShakeSignalStartMaxStop(1:idx-1, 2);
end_idxs = ShakeSignalStartMaxStop(1:idx-1, 4);
for i = 1:length(start_idxs)
    m = start_idxs(i);
    n = end_idxs(i);
    plot(m:n, data(m:n),'k')
end


% plot 20ms data
% x0 = linspace(0,3.1415926*2,2000000);
% y0 = sin(x0) * 0.005;
% y1 = ones(1,size(x0, 2)) * handles.ThresthodValue / 1000 /17.7828;
% plot(y0, 'y');
% plot(y1, 'b');

rows_SavedSignal = size(SavedSignal);
rows_SavedSignal = rows_SavedSignal(1);
if (rows_SavedSignal>0) 
    thre_20ms = max(abs(SavedSignal(:, 6))) * 1.1;
    plot20ms(thre_20ms);
    plot20ms_thre(ThresthodValue);
    xlim([0 2000000]);
end
hold off;

% three-k-means plot
%['r.', 'b.', 'm.', 'y.', 'c.'];
axes(handles.axes12);
plot(data, 'y');
hold on;
% plot non-shake signals data (red)
for idx = 1:max(1000, size(NoShakeSignalStartMaxStop,1))
    if NoShakeSignalStartMaxStop(idx, 2)==0
        break
    end
end
start_idxs = NoShakeSignalStartMaxStop(1:idx-1, 2);
end_idxs = NoShakeSignalStartMaxStop(1:idx-1, 8);
for i = 1:length(start_idxs)
    m = start_idxs(i);
    n = end_idxs(i);
    if (kmeans_idx(i)==1)
        plot(m:n, data(m:n),'r')
    elseif (kmeans_idx(i)==2)
        plot(m:n, data(m:n),'b')
    else
        plot(m:n, data(m:n),'m')
    end
end
hold off;

% 
% % TW聚类
% k = 3;
% color_l = ['r.', 'b.', 'm.', 'y.', 'c.'];
% if ((length(l_tw))<3)
%     return
% end
% [idx, ctrs] = kmeans(l_tw, k);
% axes(handles.axes10);
% for i = 1:k
%     hold on;
%     plot(l_tw(idx==i, 1), l_tw(idx==i, 2), color_l(i*2-1:i*2));
% end
% 





%% pd text
if (pd==0)
    set(handles.text1, 'string', '未发现局部放电');
elseif (pd==1)
    set(handles.text1, 'string', '发现单相放电');
elseif (pd==2)
    set(handles.text1, 'string', '发现两相放电');
else
    set(handles.text1, 'string', '发现三相放电');
end


end