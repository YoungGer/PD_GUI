function varargout = home_page(varargin)
% HOME_PAGE MATLAB code for home_page.fig
%      HOME_PAGE, by itself, creates a new HOME_PAGE or raises the existing
%      singleton*.
%
%      H = HOME_PAGE returns the handle to a new HOME_PAGE or the handle to
%      the existing singleton*.
%
%      HOME_PAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HOME_PAGE.M with the given input arguments.
%
%      HOME_PAGE('Property','Value',...) creates a new HOME_PAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before home_page_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to home_page_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help home_page

% Last Modified by GUIDE v2.5 10-Feb-2018 16:00:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @home_page_OpeningFcn, ...
                   'gui_OutputFcn',  @home_page_OutputFcn, ...
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


% --- Executes just before home_page is made visible.
function home_page_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to home_page (see VARARGIN)

% Choose default command line output for home_page
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes home_page wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% show files stats
[table_cell] = get_files_status();
set(handles.tt, 'data', table_cell);

% show image

% axes(handles.axes1); 
% imshow(imread('./analysis.jpg'));
% axes(handles.axes2); 
% imshow(imread('./prpd.jpg'));
% axes(handles.axes3); 
% imshow(imread('./pd.jpg'));
% axes(handles.axes4); 
% imshow(imread('./noise.jpg'));


% --- Outputs from this function are returned to the command line.
function varargout = home_page_OutputFcn(hObject, eventdata, handles) 
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

% show files stats
[table_cell] = get_files_status();
set(handles.tt, 'data', table_cell);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
single_pd_mtx;

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
files_analysis;

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pd_lib;
