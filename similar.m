function varargout = similar(varargin)
% SIMILAR MATLAB code for similar.fig
%      SIMILAR, by itself, creates a new SIMILAR or raises the existing
%      singleton*.
%
%      H = SIMILAR returns the handle to a new SIMILAR or the handle to
%      the existing singleton*.
%
%      SIMILAR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMILAR.M with the given input arguments.
%
%      SIMILAR('Property','Value',...) creates a new SIMILAR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before similar_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to similar_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help similar

% Last Modified by GUIDE v2.5 13-Jan-2018 15:40:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @similar_OpeningFcn, ...
                   'gui_OutputFcn',  @similar_OutputFcn, ...
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


% --- Executes just before similar is made visible.
function similar_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to similar (see VARARGIN)

% Choose default command line output for similar
handles.output = hObject;



% UIWAIT makes similar wait for user response (see UIRESUME)
% uiwait(handles.gui1);

% get data from pd_gui1
h = findobj('Tag', 'gui0');
g1data = guidata(h);
% get data for this handler
a = g1data.a;
[select_signal, select_data] = find_similar_signal(a);
handles.select_signal = select_signal;
handles.select_data = select_data;
handles.N = size(select_signal, 1);
guidata(hObject, handles);
% set popupmenu
b = 1:handles.N;
set(handles.popupmenu1, 'string',  num2str(b'));

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = similar_OutputFcn(hObject, eventdata, handles) 
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
signals = handles.select_signal;
datas = handles.select_data;
plot(datas(idx,:));


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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% add pd
idx = get(handles.popupmenu1, 'Value');
dlmwrite('pd.csv', handles.select_signal(idx,:), 'delimiter', ',','-append');

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% add noise
idx = get(handles.popupmenu1, 'Value');
dlmwrite('noise.csv', handles.select_signal(idx,:), 'delimiter', ',','-append');
