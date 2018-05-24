function varargout = classify_pd_human(varargin)
% CLASSIFY_PD_HUMAN MATLAB code for classify_pd_human.fig
%      CLASSIFY_PD_HUMAN, by itself, creates a new CLASSIFY_PD_HUMAN or raises the existing
%      singleton*.
%
%      H = CLASSIFY_PD_HUMAN returns the handle to a new CLASSIFY_PD_HUMAN or the handle to
%      the existing singleton*.
%
%      CLASSIFY_PD_HUMAN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CLASSIFY_PD_HUMAN.M with the given input arguments.
%
%      CLASSIFY_PD_HUMAN('Property','Value',...) creates a new CLASSIFY_PD_HUMAN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before classify_pd_human_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to classify_pd_human_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help classify_pd_human

% Last Modified by GUIDE v2.5 09-May-2018 15:27:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @classify_pd_human_OpeningFcn, ...
                   'gui_OutputFcn',  @classify_pd_human_OutputFcn, ...
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


% --- Executes just before classify_pd_human is made visible.
function classify_pd_human_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to classify_pd_human (see VARARGIN)

% Choose default command line output for classify_pd_human
handles.output = hObject;



%savefig(save_name);
file_path = getappdata(0,'file_path');
size_file_path = size(file_path);
save_name = file_path{1};
save_name(1)='F';
save_name(length(save_name)-2:length(save_name))='fig';

axes(handles.axes1);
display(save_name);
%plot(1:10,1:10)
fig_handler= openfig(save_name, 'reuse');


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes classify_pd_human wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = classify_pd_human_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
