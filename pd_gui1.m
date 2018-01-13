function varargout = pd_gui1(varargin)
% PD_GUI1 MATLAB code for pd_gui1.fig
%      PD_GUI1, by itself, creates a new PD_GUI1 or raises the existing
%      singleton*.
%
%      H = PD_GUI1 returns the handle to a new PD_GUI1 or the handle to
%      the existing singleton*.
%
%      PD_GUI1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PD_GUI1.M with the given input arguments.
%
%      PD_GUI1('Property','Value',...) creates a new PD_GUI1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pd_gui1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pd_gui1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pd_gui1

% Last Modified by GUIDE v2.5 26-Dec-2017 15:00:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pd_gui1_OpeningFcn, ...
                   'gui_OutputFcn',  @pd_gui1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before pd_gui1 is made visible.
function pd_gui1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pd_gui1 (see VARARGIN)

% Choose default command line output for pd_gui1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pd_gui1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pd_gui1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%[filename, filepath] = uigetfile('*');
%full_name = [filepath filename];

full_name = '/Users/yangguangyao/Desktop/PDData/ygy_gui/C2Trace00011.trc';

% read data
data = ReadLeCroyBinaryWaveform(full_name);
data=data.y*1000;

%% extract signals
power_ratio = 1;

AverageValue = mean(data); 
data=data-AverageValue;
AverageValue = mean(abs(data));
PeakValue = max(abs(data));
StandardDiv = std(abs(data));
CrestFactor=PeakValue/StandardDiv;
FormFactor=StandardDiv/AverageValue;
PeakVSAverageLog=log10(PeakValue/AverageValue);
STDVSAverageLog=log10(FormFactor);
ThresthodValue=1.5*median(abs(data))/0.6745*sqrt(2*log(length(data)))*PeakVSAverageLog;
[PDStartStopMaxPoint]=GetWaveShape(data ,0, 0 ,ThresthodValue);%获取所有信号大概的起始点终止点


[ShakeSignal,NoShakeSignal,ShakeSignalStartMaxStop,NoShakeSignalStartMaxStop]=ClassifiyShakingWave(PDStartStopMaxPoint,data,data,0);
ShakeSignal=ShakeSignal*power_ratio/1000;
NoShakeSignal=NoShakeSignal*power_ratio/1000;
data=data*power_ratio/1000;




%% calculate signlas params
 
%xiaodi的Kmeans中用到的参数：第一行是PD位置，第二行是PD种类，第三行是信号宽度，第四行是上升时间，第五行是幅值，第六行是极性
SavedSignal=zeros(NoShakeSignalStartMaxStop(1,1),18);
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
   [T, W]=TW1(Evaluationdata)
   SavedSignal(index,17)= T;  
   SavedSignal(index,18)= W;
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

 
handles.SavedSignal = SavedSignal;
handles.data = data;
guidata(hObject, handles);
 
%% plot
% plot original data
axes(handles.axes1);
plot(data);
hold on;
% plot signals data
for idx = 1:10
    if NoShakeSignalStartMaxStop(idx, 2)==0
        break
    end
end

start_idxs = NoShakeSignalStartMaxStop(1:idx-1, 2);
end_idxs = NoShakeSignalStartMaxStop(1:idx-1, 8);

handles.start_idxs = start_idxs;
handles.end_idxs = end_idxs;
guidata(hObject, handles);

for i = 1:length(start_idxs)
    m = start_idxs(i);
    n = end_idxs(i);
    plot(m:n, data(m:n),'r')
end

% plot 20ms data
x0 = linspace(0,3.1415926*2,2000000);
y0 = sin(x0) * 0.03;
plot(y0, 'y');
xlim([0 2000000]);
hold off;
%% show signals count
set(handles.text_signal_cnt, 'string', num2str(length(start_idxs)));

%% set count iterate for popup menu
%b = int2str(  (1:length(start_idxs))'  );
%set(handles.popupmenu2, 'string',  num2str([1,2,3,4]'));
b = 1:length(start_idxs);
set(handles.popupmenu2, 'string',  num2str(b'));



% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2

idx = get(handles.popupmenu2, 'Value');
set(handles.text_rise_time, 'string',  num2str(handles.SavedSignal(idx, 4)));
set(handles.text_peak_voltage, 'string',  num2str(handles.SavedSignal(idx, 6)));
set(handles.text_t, 'string',  num2str(handles.SavedSignal(idx, 17)));
set(handles.text_w, 'string',  num2str(handles.SavedSignal(idx, 18)));

% plot concrete data
axes(handles.axes2);
m = handles.start_idxs(idx);
n = handles.end_idxs(idx);
plot(m-100:n+100, handles.data(m-100:n+100),'b')
hold on;
plot(m:n, handles.data(m:n),'r')
hold off;



% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_addpd.
function pushbutton_addpd_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_addpd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx = get(handles.popupmenu2, 'Value');
dlmwrite('pd.csv', handles.SavedSignal(idx,:), 'delimiter', ',','-append');

% --- Executes on button press in pushbutton_addnoise.
function pushbutton_addnoise_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_addnoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx = get(handles.popupmenu2, 'Value');
dlmwrite('noise.csv', handles.SavedSignal(idx,:), 'delimiter', ',','-append');
