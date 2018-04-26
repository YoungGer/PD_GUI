function varargout = pd_lib(varargin)
% PD_LIB MATLAB code for pd_lib.fig
%      PD_LIB, by itself, creates a new PD_LIB or raises the existing
%      singleton*.
%
%      H = PD_LIB returns the handle to a new PD_LIB or the handle to
%      the existing singleton*.
%
%      PD_LIB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PD_LIB.M with the given input arguments.
%
%      PD_LIB('Property','Value',...) creates a new PD_LIB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pd_lib_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pd_lib_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pd_lib

% Last Modified by GUIDE v2.5 30-Mar-2018 10:15:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pd_lib_OpeningFcn, ...
                   'gui_OutputFcn',  @pd_lib_OutputFcn, ...
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


% --- Executes just before pd_lib is made visible.
function pd_lib_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pd_lib (see VARARGIN)

% Choose default command line output for pd_lib
handles.output = hObject;
handles.M = csvread('F:\局放GUI\data_lib\pd_lib.csv');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pd_lib wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pd_lib_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

idx = get(handles.popupmenu1, 'Value');

%% get params and data
params = handles.M(idx, 1:20);
for i=21:size(handles.M, 2)
    if  handles.M(idx, i)==0
        break
    end
end
data =  handles.M(idx, 21:i-1);

%% plot orig data
axes(handles.axes2);
plot(1:size(data,2), data,'b')
hold on;
plot(101:size(data,2)-100, data(1, 101:size(data,2)-100),'r');
hold off;

%% others
labels = char('rise_time', 'peak_voltage',  't', 'w', 'loc');
set(handles.pop_xlabel, 'string', labels);
set(handles.pop_ylabel, 'string', labels);
set(handles.pop_bar, 'string', labels);


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


% --- Executes on selection change in pop_xlabel.
function pop_xlabel_Callback(hObject, eventdata, handles)
% hObject    handle to pop_xlabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_xlabel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_xlabel
% two axes data
x_idx = get(handles.pop_xlabel, 'Value');
y_idx = get(handles.pop_ylabel, 'Value');
axes(handles.axes3);
plot(handles.c(num2str(x_idx)), handles.c(num2str(y_idx)), '.')

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
x_idx = get(handles.pop_xlabel, 'Value');
y_idx = get(handles.pop_ylabel, 'Value');
axes(handles.axes3);
plot(handles.c(num2str(x_idx)), handles.c(num2str(y_idx)), '.')

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


% --- Executes on selection change in pop_bar.
function pop_bar_Callback(hObject, eventdata, handles)
% hObject    handle to pop_bar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_bar contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_bar

% hist plot
idx = get(handles.pop_bar, 'Value');
axes(handles.axes5);
hist(handles.c(num2str(idx)));

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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% get data
% refresh callback
M = csvread('F:\局放GUI\data_lib\pd_lib.csv');
N = size(M, 1);

% set num count
set(handles.num_cnt, 'string', num2str(N));
b = 1:N;
set(handles.popupmenu1, 'string',  num2str(b'));

% SAVE M
handles.M = M;


%% plot statis data
l_flag = handles.M(:, 7);
l_rise_time = handles.M(:, 4) .* l_flag;
l_loc = handles.M(:, 1);
l_pv = handles.M(:, 6) .* l_flag;
l_t = handles.M(:, 17) .* l_flag;
l_w = handles.M(:, 18) .* l_flag;

c = containers.Map;
c('1') = l_rise_time;
c('2') = l_pv;
c('3') = l_t;
c('4') = l_w;
c('5') = l_loc;
handles.c = c;
% pd - loc data
axes(handles.axes4);
plot(l_loc, l_pv, '.')
plot20ms(max(l_pv)*1.3);


guidata(hObject, handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% delete 
M = handles.M;
N = size(M, 1);

row_idx = get(handles.popupmenu1, 'Value');

M(row_idx,:) = [];

dlmwrite('F:\局放GUI\data_lib\pd_lib.csv', M, 'delimiter',',');
