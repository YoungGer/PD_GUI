function varargout = chakan_data(varargin)
% CHAKAN_DATA MATLAB code for chakan_data.fig
%      CHAKAN_DATA, by itself, creates a new CHAKAN_DATA or raises the existing
%      singleton*.
%
%      H = CHAKAN_DATA returns the handle to a new CHAKAN_DATA or the handle to
%      the existing singleton*.
%
%      CHAKAN_DATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHAKAN_DATA.M with the given input arguments.
%
%      CHAKAN_DATA('Property','Value',...) creates a new CHAKAN_DATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before chakan_data_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to chakan_data_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help chakan_data

% Last Modified by GUIDE v2.5 18-May-2018 16:01:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @chakan_data_OpeningFcn, ...
                   'gui_OutputFcn',  @chakan_data_OutputFcn, ...
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


% --- Executes just before chakan_data is made visible.
function chakan_data_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to chakan_data (see VARARGIN)

% Choose default command line output for chakan_data
handles.output = hObject;

%  load('F:\PDData\t1\t2\t3\t4\3_sta.mat');
% SavedSignal = rst.SavedSignal;

file_path = getappdata(0,'file_path');
size_file_path = size(file_path);
if (size_file_path(1)==0)
    [filename, filepath] = uigetfile('*');
    full_name = [filepath filename];
else
    full_name = file_path{1};
end

rst_name = full_name;
rst_name = [rst_name(1:length(rst_name)-4),'_sta.mat'];
rst_name(1)='F';
load(rst_name);

data = rst.data;
SavedSignal = rst.SavedSignal;


set(handles.tt, 'data', SavedSignal(:,1:18));  % 前4个是地点，第5个文件，第6，7是系统，人工标注的放电个数，8 is location

handles.curr_data = SavedSignal(:,1:18);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes chakan_data wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = chakan_data_OutputFcn(hObject, eventdata, handles) 
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
curr_data = handles.curr_data;
uisave('curr_data');
