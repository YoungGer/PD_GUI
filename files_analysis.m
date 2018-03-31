function varargout = files_analysis(varargin)
% FILES_ANALYSIS MATLAB code for files_analysis.fig
%      FILES_ANALYSIS, by itself, creates a new FILES_ANALYSIS or raises the existing
%      singleton*.
%
%      H = FILES_ANALYSIS returns the handle to a new FILES_ANALYSIS or the handle to
%      the existing singleton*.
%
%      FILES_ANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FILES_ANALYSIS.M with the given input arguments.
%
%      FILES_ANALYSIS('Property','Value',...) creates a new FILES_ANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before files_analysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to files_analysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help files_analysis

% Last Modified by GUIDE v2.5 31-Mar-2018 16:17:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @files_analysis_OpeningFcn, ...
                   'gui_OutputFcn',  @files_analysis_OutputFcn, ...
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


% --- Executes just before files_analysis is made visible.
function files_analysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to files_analysis (see VARARGIN)

% Choose default command line output for files_analysis
handles.output = hObject;

labels = char('rise_time', 'peak_voltage',  't', 'w', 'loc');
set(handles.pop_xlabel, 'string', labels);
set(handles.pop_ylabel, 'string', labels);
set(handles.pop_bar, 'string', labels);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes files_analysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = files_analysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in pop_xlabel.
function pop_xlabel_Callback(hObject, eventdata, handles)
% hObject    handle to pop_xlabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_xlabel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_xlabel
x_idx = get(handles.pop_xlabel, 'Value');
y_idx = get(handles.pop_ylabel, 'Value');
axes(handles.axes1);
plot(handles.c(num2str(x_idx)), handles.c(num2str(y_idx)), '.');

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
axes(handles.axes1);
plot(handles.c(num2str(x_idx)), handles.c(num2str(y_idx)), '.');

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
axes(handles.axes3);
idx = get(handles.pop_bar, 'Value');
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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% choose data callback, get features
[filename, filepath] = uigetfile('*');
files = dir(filepath);
features = [];
%full_names = [];
for i = 3:size(files,1)
    % get full_name 
    file_name = files(i).name;
    full_name = [filepath file_name];
    %full_names = [full_names, full_name];
    % get data
    [data] = read_pd_data(full_name);
    % get features
    [feature] = extract_signal2(data, -1);
    features = [features; feature];
end

%save('features','features');
%load('features.mat')
%% preapare plot
l_rise_time = features(:, 4);
l_loc = features(:, 1);
l_flag = features(:, 7);
l_pv = features(:, 6);
l_t = features(:, 17);
l_w = features(:, 18);


c = containers.Map;
c('1') = l_rise_time;
c('2') = l_pv;
c('3') = l_t;
c('4') = l_w;
c('5') = l_loc;
handles.c = c;
%% normal pic
axes(handles.axes2);
plot(l_loc, l_flag.*l_pv, '.')
plot20ms(max(abs(l_pv))*1.3);
xlabel('PD Location')
ylabel('Peak Voltage')

%% 
% statis matrix plot
x_idx = get(handles.pop_xlabel, 'Value');
y_idx = get(handles.pop_ylabel, 'Value');
axes(handles.axes1);
plot(c(num2str(x_idx)), c(num2str(y_idx)), '.');
% hist plot
axes(handles.axes3);
idx = get(handles.pop_bar, 'Value');
hist(c(num2str(idx)));

set(handles.text3, 'string', num2str(size(l_rise_time,1)));

guidata(hObject, handles);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
