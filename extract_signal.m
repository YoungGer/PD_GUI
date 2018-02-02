function [handles] = extract_signal(data, pre_thre, handles)

%% extract signals
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




%% calculate signlas params
 
%xiaodi的Kmeans中用到的参数：第一行是PD位置，第二行是PD种类，第三行是信号宽度，第四行是上升时间，第五行是幅值，第六行是极性
SavedSignal=zeros(NoShakeSignalStartMaxStop(1,1),20);
SavedSignalForKmeans=zeros(NoShakeSignalStartMaxStop(1,1),18);
SavedSignalForKohonenMappingSinglePulse=zeros(NoShakeSignalStartMaxStop(1,1),5);
SavedSignalForKohonenMapingWhole20mS=zeros(1,11);
SavedSignalForKohonenMapingWhole20mSBuffer=zeros(1,5);
%SavedSignal中18个参数分别存储的是
%1：PD位置，
%2：PD种类，
%3：信号宽度，
%4：上升时间，
%5：Fall time
%6：幅值 Peak value of voltag；
%7：极性
%8：Average value of voltage，
%9：Root mean square (RMS) ，
%10：Standard deviation
%11：Skewness；
%12：Kurtosis；
%13：Crest factor （( maximum magnitude over R.M.S)）
%14：Form factor ( R.M.S magnitude over average value)
%15：Frequency spectrum
%16：Phase angle ψi and time ti of occurrence of a PD pulse，ψi =360(ti/T)
%17：T-W mapping---T
%18: T-W mapping---W

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
    
    SavedSignalForKohonenMappingSinglePulse(index,1)=SavedSignal(index,4);%!!!!!RiseTime
    SavedSignalForKohonenMappingSinglePulse(index,2)=SavedSignal(index,11);%Skewness；
     SavedSignalForKohonenMappingSinglePulse(index,3)=SavedSignal(index,12);%Kurtosis 
         SavedSignalForKohonenMappingSinglePulse(index,4)=SavedSignal(index,13);%Crest factor （( maximum magnitude over R.M.S)）
             SavedSignalForKohonenMappingSinglePulse(index,5)=11;%信号种类 
             
             
        
 end


ThresthodValue = ThresthodValue*power_ratio;

handles.ThresthodValue = ThresthodValue;
handles.SavedSignal = SavedSignal;
handles.data = data;
handles.NoShakeSignalStartMaxStop = NoShakeSignalStartMaxStop;
end