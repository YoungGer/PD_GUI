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

% Last Modified by GUIDE v2.5 29-Jan-2018 10:50:57

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
% uiwait(handles.gui0);


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

% [filename, filepath] = uigetfile('*');
% full_name = [filepath filename];

full_name = 'F:\局方GUI\PDData2\ygy_gui\C2Trace00011.trc';

% read data
data = ReadLeCroyBinaryWaveform(full_name);
data=data.y*1000;

% find pre_thre
pre_thre = str2double(get(handles.thre, 'string'));
pre_thre = pre_thre * 17.7828;
pre_thre
[data, SavedSignal, NoShakeSignalStartMaxStop, ThresthodValue] = extract_signal(data, pre_thre);
pre_thre
ThresthodValue


handles.ThresthodValue = ThresthodValue;
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
y0 = sin(x0) * 0.005;
y1 = ones(1,size(x0, 2)) * handles.ThresthodValue / 1000 /17.7828;
plot(y0, 'y');
plot(y1, 'b');
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

% save data for handler 
% similar.fig use
handles.a = handles.SavedSignal(idx,:);
guidata(hObject, handles);



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


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% batch_select();
n = 2;

set(handles.text_status, 'string', 'Begin Process Data');
pause(n);
set(handles.text_status, 'string', 'Analysis Data Structure');
pause(n);
set(handles.text_status, 'string', 'Analysis Data Similarity');
pause(n);
set(handles.text_status, 'string', 'Compare Data with Warehouse Data');
pause(n);
set(handles.text_status, 'string', 'Using Self-Study Algorithm to Judge');
pause(n);
set(handles.text_status, 'string', 'Find PD');
pause(n);
set(handles.text_status, 'string', 'Find NOISE');
pause(n);
set(handles.text_status, 'string', 'Finish');





% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%similar;
[select_signal, select_data] = find_similar_signal(handles.a);

handles.select_signal = select_signal;
handles.select_data = select_data;
handles.N = size(select_signal, 1);
% set popupmenu
b = 1:handles.N;
set(handles.popupmenu4, 'string',  num2str(b'));

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% prpd;
% plot pd data
axes(handles.axes4);
%M = csvread('./pd_all.csv');
M = csvread('F:\局方GUI\data\1.5mm dia 10kv inception\pd_all.csv');
hold on;
plot(M(:,1), M(:,6) .* M(:,7), 'bo')
x0 = linspace(0,3.1415926*2,2000000);
y0 = sin(x0) * 0.005;
plot(y0, 'y');
% plot NOISE PRPD
%M = csvread('./noise_all.csv');
M = csvread('F:\局方GUI\data\1.5mm dia 10kv inception\noise_all.csv');
plot(M(:,1), M(:,6) .* M(:,7), 'r+')
xlim([0 2000000]);
hold off;

% plot positive polar 
%M = csvread('./pd_all.csv');
M = csvread('F:\局方GUI\data\1.5mm dia 10kv inception\pd_all.csv');
[pos_loc, pos_val, neg_loc, neg_val] = polarsize(M);
axes(handles.axes5);
polar(pos_loc, pos_val, 'b.')
hold on;

M = csvread('F:\局方GUI\data\1.5mm dia 10kv inception\noise_all.csv');
[pos_loc, pos_val, neg_loc, neg_val] = polarsize(M);
polar(pos_loc, pos_val, 'r+')
hold off;

% plot negative polar 
%M = csvread('./pd_all.csv');
M = csvread('F:\局方GUI\data\1.5mm dia 10kv inception\pd_all.csv');
[pos_loc, pos_val, neg_loc, neg_val] = polarsize(M);
axes(handles.axes6);
polar(neg_loc, neg_val, 'b.')
hold on;

M = csvread('F:\局方GUI\data\1.5mm dia 10kv inception\noise_all.csv');
[pos_loc, pos_val, neg_loc, neg_val] = polarsize(M);
polar(neg_loc, neg_val, 'r+')
hold off;






% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4
idx = get(handles.popupmenu4, 'Value');
signals = handles.select_signal;
datas = handles.select_data;
axes(handles.axes3);
plot(datas(idx,:));

% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
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

% add pd
idx = get(handles.popupmenu4, 'Value');
dlmwrite('pd.csv', handles.select_signal(idx,:), 'delimiter', ',','-append');

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% add noise
idx = get(handles.popupmenu4, 'Value');
dlmwrite('noise.csv', handles.select_signal(idx,:), 'delimiter', ',','-append');


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[table_cell] = get_files_status();
set(handles.tt, 'data', table_cell);
