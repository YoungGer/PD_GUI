function varargout = prpd_auto(varargin)
% PRPD_AUTO MATLAB code for prpd_auto.fig
%      PRPD_AUTO, by itself, creates a new PRPD_AUTO or raises the existing
%      singleton*.
%
%      H = PRPD_AUTO returns the handle to a new PRPD_AUTO or the handle to
%      the existing singleton*.
%
%      PRPD_AUTO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PRPD_AUTO.M with the given input arguments.
%
%      PRPD_AUTO('Property','Value',...) creates a new PRPD_AUTO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before prpd_auto_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to prpd_auto_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help prpd_auto

% Last Modified by GUIDE v2.5 24-May-2018 20:21:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @prpd_auto_OpeningFcn, ...
                   'gui_OutputFcn',  @prpd_auto_OutputFcn, ...
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


% --- Executes just before prpd_auto is made visible.
function prpd_auto_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to prpd_auto (see VARARGIN)

% Choose default command line output for prpd_auto
handles.output = hObject;
pushbutton1_Callback(hObject, eventdata, handles);



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes prpd_auto wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = prpd_auto_OutputFcn(hObject, eventdata, handles) 
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
% 清除图上信息
cla(handles.axes1);
cla(handles.axes2);
cla(handles.axes3);
cla(handles.axes4);
cla(handles.axes5);
cla(handles.axes6);
cla(handles.axes7);
cla(handles.axes8);
cla(handles.axes9);
cla(handles.axes10);
% get feature 得到放电的特征
file_path = getappdata(0,'file_path');
size_file_path = size(file_path);
if (size_file_path(1)==0)
    [filename, filepath] = uigetfile('E:\PDData\t1\t2\t3\t4\*');
    full_name = [filepath filename];
else
    full_name = file_path{1};
end
% full_name = 'E:\PDData\t1\t2\t3\t4\13.txt';
% 读取数据抽取信号
[data] = read_pd_data(full_name);
[features, data_cell] = extract_signal2(data, -1);
% 自动识别
auto_recog2(features, data, handles);


% --- Executes during object creation, after setting all properties.
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2
