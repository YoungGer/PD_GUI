function varargout = single_pd_mtx2(varargin)
% SINGLE_PD_MTX2 MATLAB code for single_pd_mtx2.fig
%      SINGLE_PD_MTX2, by itself, creates a new SINGLE_PD_MTX2 or raises the existing
%      singleton*.
%
%      H = SINGLE_PD_MTX2 returns the handle to a new SINGLE_PD_MTX2 or the handle to
%      the existing singleton*.
%
%      SINGLE_PD_MTX2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SINGLE_PD_MTX2.M with the given input arguments.
%
%      SINGLE_PD_MTX2('Property','Value',...) creates a new SINGLE_PD_MTX2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before single_pd_mtx2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to single_pd_mtx2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help single_pd_mtx2

% Last Modified by GUIDE v2.5 24-May-2018 15:16:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @single_pd_mtx2_OpeningFcn, ...
                   'gui_OutputFcn',  @single_pd_mtx2_OutputFcn, ...
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


% --- Executes just before single_pd_mtx2 is made visible.
function single_pd_mtx2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to single_pd_mtx2 (see VARARGIN)


% Choose default command line output for single_pd_mtx2
handles.output = hObject;

% % add background
% ha=axes('units','normalized','pos',[0 0 1 1]);
% uistack(ha,'down');
% ii=imread('hp2.png');
% image(ii);
% colormap gray
% set(ha,'handlevisibility','off','visible','off');

% 设定放电类型的标签并添加到pop中
h_labels = char('局部放电', '电晕干扰', '周期干扰', '随机干扰');
set(handles.pop_human, 'string', h_labels);

pushbutton1_Callback(hObject, eventdata, handles)
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes single_pd_mtx2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = single_pd_mtx2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.

% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 开始----------------------------------------------------------------------------------------------------------------------------------------------------------
%% read data 读取放电数据
file_path = getappdata(0,'file_path');
size_file_path = size(file_path);

% 判断全局下是否存在路径，不存在的话需要gui去选择
if (size_file_path(1)==0)
    [filename, filepath] = uigetfile('*');
    full_name = [filepath filename];
else
    full_name = file_path{1};
end
    
%full_name = 'E:\PDData\s1\s2\s3\s4\64.txt';

N=1;

%full_name = 'F:\局放GUI\PDData2\data\C1_12EG018A002__2012_06_14_12_07_38.txt';
%full_name = 'F:\局放GUI\data\small2\C2Trace00016.trc';
%full_name = 'F:\局放GUI\data\1.5mm 11kv inception\C2Trace00006.trc';
%full_name = 'E:\PDData\t1\t2\t3\t4\2.txt';

% 更改文件名，获得库的位置
rst_name = full_name;
rst_name = [rst_name(1:length(rst_name)-4),'_sta.mat'];
rst_name(1)='F';
load(rst_name);

% 载入库数据
data = rst.data;
SavedSignal = rst.SavedSignal;
NoShakeSignalStartMaxStop = rst.NoShakeSignalStartMaxStop;
ShakeSignalStartMaxStop = rst.ShakeSignalStartMaxStop;
ThresthodValue = rst.ThresthodValue;

handles.full_name = full_name;
handles.ThresthodValue = ThresthodValue;
handles.SavedSignal = SavedSignal;
handles.data = data;
handles.NoShakeSignalStartMaxStop = NoShakeSignalStartMaxStop;
handles.ShakeSignalStartMaxStop = ShakeSignalStartMaxStop;
handles.N = N;

set(handles.currthre, 'string', num2str(handles.ThresthodValue));


%% plot original data
% 画原始的时序图形
axes(handles.axes2);
[handles] = plot_orig(handles);

set(handles.text_signal_cnt, 'string', num2str(length(handles.start_idxs)));

b = 1:length(handles.start_idxs);
set(handles.popupmenu1, 'string',  num2str(b'));

%% prepare statis
% 画统计参数的图形
l_rise_time = handles.SavedSignal(:, 4);
l_loc = handles.SavedSignal(:, 1);
l_flag = handles.SavedSignal(:, 7);
l_pv = handles.SavedSignal(:, 6);
l_t = handles.SavedSignal(:, 17);
l_w = handles.SavedSignal(:, 18);

% normal pic
axes(handles.axes7);
plot(l_loc, l_flag.*l_pv, '.')
plot20ms(max(abs(handles.SavedSignal(:, 6))) * 1.1)
xlabel('PD Location')
ylabel('Peak Voltage')

%% other things"
% 设定gui的pop组数据
%labels = ["rise_time"; 'peak_voltage'; 't'; 'w'; 'loc'];
labels = char('rise_time', 'peak_voltage',  't', 'w', 'loc');
set(handles.pop_xlabel, 'string', labels);
set(handles.pop_ylabel, 'string', labels);
set(handles.pop_bar, 'string', labels);
set(handles.fu1, 'string', labels);
set(handles.fu2, 'string', labels);
set(handles.fu3, 'string', labels);

select_idx = zeros(size(handles.SavedSignal, 1),1)==1 ;
handles.select_idx = select_idx;
guidata(hObject, handles);

%% dual-polarsize
% 画极坐标图形
[pos_loc, pos_val, neg_loc, neg_val] = polarsize2(l_loc, l_pv, l_flag)
axes(handles.axes9);
polar(pos_loc, pos_val, 'b.')
hold on;
polar(neg_loc, neg_val, 'rx')
hold off;

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

% 获得标签
idx = get(handles.popupmenu1, 'Value');

%% plot concrete data
% 画脉冲图
axes(handles.axes3);
m = handles.start_idxs(idx);
n = handles.end_idxs(idx);
plot(m-100:n+100, handles.data(m-100:n+100),'b')
hold on;
plot(m:n, handles.data(m:n),'r')
hold off;


%% plot origianl data with vertical line
% 在原始信号下对脉冲进行高亮
axes(handles.axes2);

[handles] = plot_orig(handles);
hold on;
thre_1pd = max(abs(handles.SavedSignal(:, 6))) * 1.3;
plot([(m+n)/2, (m+n)/2], [-thre_1pd, thre_1pd],'k--','Linewidth',3)
hold off;

% save data for handler 
% similar.fig use
handles.a = handles.SavedSignal(idx,:);
handles.b = handles.data(m-100:n+100);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 写入局放库
dlmwrite('F:\局放GUI\data_lib\pd_lib.csv', [handles.a,handles.b'], 'delimiter',',','-append');



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 写入干扰库
dlmwrite('F:\局放GUI\data_lib\noise_lib.csv', [handles.a,handles.b'], 'delimiter',',','-append');


function thre_Callback(hObject, eventdata, handles)
% hObject    handle to thre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thre as text
%        str2double(get(hObject,'String')) returns contents of thre as a double


% --- Executes during object creation, after setting all properties.
function thre_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 刷新---------------------------------------------------------------------------------------------------------------------------------------

[data] = read_pd_data(handles.full_name);

%% extract signal 提取信号
pre_thre = str2double(get(handles.thre, 'string'));
[handles] = extract_signal(data, pre_thre, handles);

set(handles.currthre, 'string', num2str(handles.ThresthodValue));


%% plot original data 画原始数据
axes(handles.axes2);
[handles] = plot_orig(handles);

set(handles.text_signal_cnt, 'string', num2str(length(handles.start_idxs)));

b = 1:length(handles.start_idxs);
set(handles.popupmenu1, 'string',  num2str(b'));



%% get idx of select data point
% % pv_low, pv_high
% pv_low = str2num(get(handles.pv_low, 'string'));
% pv_high = str2num(get(handles.pv_high, 'string'));
% rt_low = str2num(get(handles.rt_low, 'string'));
% rt_high = str2num(get(handles.rt_high, 'string'));
% 
% 
% select_idx = ones(size(handles.SavedSignal, 1),1)==1 ;
% if pv_low~=-1 & pv_high~=-1
%     pv_idx = handles.SavedSignal(:, 6)>pv_low & handles.SavedSignal(:, 6)<pv_high;
%     select_idx = select_idx & pv_idx;
% end
% if rt_low~=-1 & rt_high~=-1
%     rt_idx = handles.SavedSignal(:, 4)>rt_low & handles.SavedSignal(:, 4)<rt_high;
%     select_idx = select_idx & rt_idx;
% end
% if pv_low==-1 & rt_low==-1
%     select_idx = zeros(size(handles.SavedSignal, 1),1)==1 ;
% end

%'rise_time', 'peak_voltage',  't', 'w', 'loc'
[select_idx] = get_select_idx_from_popmenu(handles);

handles.select_idx = select_idx;

%% plot select data point  画选中的脉冲数据
% in original plot
axes(handles.axes2);
hold on;
for i = 1:length(handles.start_idxs)
    if select_idx(i)==1
        m = handles.start_idxs(i);
        n = handles.end_idxs(i);
        plot(m:n, handles.data(m:n),'c')
    end
end
hold off;

%% prepare statis 画统计参数数据

%{'rise_time'; 'peak_voltage',  't'; 'w'; 'loc'};
plot_statis_mtx(handles);
% xlabel('PD Location')
% ylabel('Peak Voltage')


guidata(hObject, handles);




% --- Executes on selection change in pop_xlabel.
function pop_xlabel_Callback(hObject, eventdata, handles)
% hObject    handle to pop_xlabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_xlabel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_xlabel
% 选择特征后画统计图
plot_statis_mtx(handles);

% --- Executes during object creation, after setting all properties.
function pop_xlabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_xlabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_ylabel.
function pop_ylabel_Callback(hObject, eventdata, handles)
% hObject    handle to pop_ylabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_ylabel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_ylabel
% 选择特征后画统计图
plot_statis_mtx(handles);

% --- Executes during object creation, after setting all properties.
function pop_ylabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_ylabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pv_low_Callback(hObject, eventdata, handles)
% hObject    handle to pv_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pv_low as text
%        str2double(get(hObject,'String')) returns contents of pv_low as a double


% --- Executes during object creation, after setting all properties.
function pv_low_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pv_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pv_high_Callback(hObject, eventdata, handles)
% hObject    handle to pv_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pv_high as text
%        str2double(get(hObject,'String')) returns contents of pv_high as a double


% --- Executes during object creation, after setting all properties.
function pv_high_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pv_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rt_low_Callback(hObject, eventdata, handles)
% hObject    handle to rt_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rt_low as text
%        str2double(get(hObject,'String')) returns contents of rt_low as a double


% --- Executes during object creation, after setting all properties.
function rt_low_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rt_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rt_high_Callback(hObject, eventdata, handles)
% hObject    handle to rt_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rt_high as text
%        str2double(get(hObject,'String')) returns contents of rt_high as a double


% --- Executes during object creation, after setting all properties.
function rt_high_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rt_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_bar.
function pop_bar_Callback(hObject, eventdata, handles)
% hObject    handle to pop_bar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_bar contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_bar

% single bar plot call
% ----------------------------------------------------------------------------------------------------------------------------
idx = get(handles.pop_bar, 'Value');

% 获得统计参数信息
l_flag = handles.SavedSignal(:, 7);
l_rise_time = handles.SavedSignal(:, 4);
l_loc = handles.SavedSignal(:, 1);
l_pv = handles.SavedSignal(:, 6) .* l_flag;
l_t = handles.SavedSignal(:, 17);
l_w = handles.SavedSignal(:, 18);

c = containers.Map;
c('1') = l_rise_time;
c('2') = l_pv;
c('3') = l_t;
c('4') = l_w;
c('5') = l_loc;

% 画hist图
axes(handles.axes8);
hist(c(num2str(idx)));



% --- Executes during object creation, after setting all properties.
function pop_bar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_bar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fu1_low_Callback(hObject, eventdata, handles)
% hObject    handle to fu1_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fu1_low as text
%        str2double(get(hObject,'String')) returns contents of fu1_low as a double


% --- Executes during object creation, after setting all properties.
function fu1_low_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fu1_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fu1_high_Callback(hObject, eventdata, handles)
% hObject    handle to fu1_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fu1_high as text
%        str2double(get(hObject,'String')) returns contents of fu1_high as a double


% --- Executes during object creation, after setting all properties.
function fu1_high_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fu1_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in fu1.
function fu1_Callback(hObject, eventdata, handles)
% hObject    handle to fu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fu1


% --- Executes during object creation, after setting all properties.
function fu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fu2_low_Callback(hObject, eventdata, handles)
% hObject    handle to fu2_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fu2_low as text
%        str2double(get(hObject,'String')) returns contents of fu2_low as a double


% --- Executes during object creation, after setting all properties.
function fu2_low_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fu2_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fu2_high_Callback(hObject, eventdata, handles)
% hObject    handle to fu2_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fu2_high as text
%        str2double(get(hObject,'String')) returns contents of fu2_high as a double


% --- Executes during object creation, after setting all properties.
function fu2_high_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fu2_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in fu2.
function fu2_Callback(hObject, eventdata, handles)
% hObject    handle to fu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fu2


% --- Executes during object creation, after setting all properties.
function fu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fu3_low_Callback(hObject, eventdata, handles)
% hObject    handle to fu3_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fu3_low as text
%        str2double(get(hObject,'String')) returns contents of fu3_low as a double


% --- Executes during object creation, after setting all properties.
function fu3_low_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fu3_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fu3_high_Callback(hObject, eventdata, handles)
% hObject    handle to fu3_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fu3_high as text
%        str2double(get(hObject,'String')) returns contents of fu3_high as a double


% --- Executes during object creation, after setting all properties.
function fu3_high_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fu3_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in fu3.
function fu3_Callback(hObject, eventdata, handles)
% hObject    handle to fu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fu3


% --- Executes during object creation, after setting all properties.
function fu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% recognize
% 聚类识别模块
prpd_auto; %聚类为3
prpd_auto2; %聚类为2
prpd_auto3;%聚类为1

%dlmwrite('F:\局放GUI\data_lib\pd_lib.csv', handles.SavedSignal, 'delimiter',',','-append');



% --- Executes on selection change in pop_human.
function pop_human_Callback(hObject, eventdata, handles)
% hObject    handle to pop_human (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_human contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_human

% 放电类型选择 back
h_idx = get(handles.pop_human, 'Value');
handles.h_idx = h_idx;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function pop_human_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_human (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h_idx = handles.h_idx;
% 获得放电类型的标签
setappdata(0, 'h_idx', h_idx);
guidata(hObject, handles);


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
chakan_data;


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 获得信号标签
idx = get(handles.popupmenu1, 'Value');
a = handles.a;
setappdata(0, 'a', a);
% 相似信号分析模块
similar;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
