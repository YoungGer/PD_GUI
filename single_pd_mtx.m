function varargout = single_pd_mtx(varargin)
% SINGLE_PD_MTX MATLAB code for single_pd_mtx.fig
%      SINGLE_PD_MTX, by itself, creates a new SINGLE_PD_MTX or raises the existing
%      singleton*.
%
%      H = SINGLE_PD_MTX returns the handle to a new SINGLE_PD_MTX or the handle to
%      the existing singleton*.
%
%      SINGLE_PD_MTX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SINGLE_PD_MTX.M with the given input arguments.
%
%      SINGLE_PD_MTX('Property','Value',...) creates a new SINGLE_PD_MTX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before single_pd_mtx_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to single_pd_mtx_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help single_pd_mtx

% Last Modified by GUIDE v2.5 02-Feb-2018 16:06:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @single_pd_mtx_OpeningFcn, ...
                   'gui_OutputFcn',  @single_pd_mtx_OutputFcn, ...
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


% --- Executes just before single_pd_mtx is made visible.
function single_pd_mtx_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to single_pd_mtx (see VARARGIN)

% Choose default command line output for single_pd_mtx
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes single_pd_mtx wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = single_pd_mtx_OutputFcn(hObject, eventdata, handles) 
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

%% read data
[filename, filepath] = uigetfile('*');
full_name = [filepath filename];
%full_name = 'F:\局方GUI\PDData2\data\C1_12EG018A002__2012_06_14_12_07_38.txt';
%full_name = 'F:\局方GUI\PDData2\ygy_gui\C2Trace00011.trc';
handles.full_name = full_name;
[data] = read_pd_data(full_name);

%% extract signal
pre_thre = str2double(get(handles.thre, 'string'));
[handles] = extract_signal(data, pre_thre, handles);

set(handles.currthre, 'string', num2str(handles.ThresthodValue));


%% plot original data
axes(handles.axes2);
[handles] = plot_orig(handles);

set(handles.text_signal_cnt, 'string', num2str(length(handles.start_idxs)));

b = 1:length(handles.start_idxs);
set(handles.popupmenu1, 'string',  num2str(b'));

%% prepare statis
l_rise_time = handles.SavedSignal(:, 4);
l_loc = handles.SavedSignal(:, 1);
l_flag = handles.SavedSignal(:, 7);
l_pv = handles.SavedSignal(:, 6);
l_t = handles.SavedSignal(:, 17);
l_w = handles.SavedSignal(:, 18);

% normal pic
axes(handles.axes4);
plot(l_loc, l_flag.*l_pv, '.')
plot20ms(5)
xlabel('PD Location')
ylabel('Peak Voltage')

%% other things"
%labels = ["rise_time"; 'peak_voltage'; 't'; 'w'; 'loc'];
labels = char('rise_time', 'peak_voltage',  't', 'w', 'loc');
set(handles.pop_xlabel, 'string', labels);
set(handles.pop_ylabel, 'string', labels);

select_idx = zeros(size(handles.SavedSignal, 1),1)==1 ;
handles.select_idx = select_idx;
guidata(hObject, handles);


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

idx = get(handles.popupmenu1, 'Value');

%% plot concrete data
axes(handles.axes3);
m = handles.start_idxs(idx);
n = handles.end_idxs(idx);
plot(m-100:n+100, handles.data(m-100:n+100),'b')
hold on;
plot(m:n, handles.data(m:n),'r')
hold off;


%% plot origianl data with vertical line
axes(handles.axes2);

[handles] = plot_orig(handles);
hold on;
thre_1pd = max(abs(handles.SavedSignal(:, 6))) * 1.1;
plot([(m+n)/2, (m+n)/2], [-thre_1pd, thre_1pd],'k--')
hold off;

% save data for handler 
% similar.fig use
handles.a = handles.SavedSignal(idx,:);
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


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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


[data] = read_pd_data(handles.full_name);

%% extract signal
pre_thre = str2double(get(handles.thre, 'string'));
[handles] = extract_signal(data, pre_thre, handles);

set(handles.currthre, 'string', num2str(handles.ThresthodValue));


%% plot original data
axes(handles.axes2);
[handles] = plot_orig(handles);

set(handles.text_signal_cnt, 'string', num2str(length(handles.start_idxs)));

b = 1:length(handles.start_idxs);
set(handles.popupmenu1, 'string',  num2str(b'));



%% get idx of select data point
% pv_low, pv_high
pv_low = str2num(get(handles.pv_low, 'string'));
pv_high = str2num(get(handles.pv_high, 'string'));
rt_low = str2num(get(handles.rt_low, 'string'));
rt_high = str2num(get(handles.rt_high, 'string'));


select_idx = ones(size(handles.SavedSignal, 1),1)==1 ;
if pv_low~=-1 & pv_high~=-1
    pv_idx = handles.SavedSignal(:, 6)>pv_low & handles.SavedSignal(:, 6)<pv_high;
    select_idx = select_idx & pv_idx;
end
if rt_low~=-1 & rt_low~=-1
    rt_idx = handles.SavedSignal(:, 4)>rt_low & handles.SavedSignal(:, 4)<rt_high;
    select_idx = select_idx & rt_idx;
end
if pv_low==-1 & rt_low==-1
    select_idx = zeros(size(handles.SavedSignal, 1),1)==1 ;
end
handles.select_idx = select_idx;

%% plot select data point
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

%% prepare statis

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
