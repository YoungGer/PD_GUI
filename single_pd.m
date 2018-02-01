function varargout = single_pd(varargin)
% SINGLE_PD MATLAB code for single_pd.fig
%      SINGLE_PD, by itself, creates a new SINGLE_PD or raises the existing
%      singleton*.
%
%      H = SINGLE_PD returns the handle to a new SINGLE_PD or the handle to
%      the existing singleton*.
%
%      SINGLE_PD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SINGLE_PD.M with the given input arguments.
%
%      SINGLE_PD('Property','Value',...) creates a new SINGLE_PD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before single_pd_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to single_pd_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help single_pd

% Last Modified by GUIDE v2.5 01-Feb-2018 10:03:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @single_pd_OpeningFcn, ...
                   'gui_OutputFcn',  @single_pd_OutputFcn, ...
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


% --- Executes just before single_pd is made visible.
function single_pd_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to single_pd (see VARARGIN)

% Choose default command line output for single_pd
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes single_pd wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = single_pd_OutputFcn(hObject, eventdata, handles) 
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

%% choose data callback

[filename, filepath] = uigetfile('*');
full_name = [filepath filename];

% full_name = 'F:\¾Ö·½GUI\PDData2\ygy_gui\C2Trace00011.trc';

% judge if trc or txt
if strcmp(full_name(length(full_name)-2:length(full_name)), 'trc')
    trc_flag = 1;
else
    trc_flag = 0;
end

% get data from txt or trc
if trc_flag
    data = ReadLeCroyBinaryWaveform(full_name);
    data=data.y*1000;
else
    fileID = fopen(full_name);
    data = fscanf(fileID, '%f');
    fclose(fileID);
    data = data*1000;
end

% find pre_thre
pre_thre = str2double(get(handles.thre, 'string'));
pre_thre = pre_thre;
pre_thre
[data, SavedSignal, NoShakeSignalStartMaxStop, ThresthodValue] = extract_signal(data, pre_thre);
pre_thre
ThresthodValue

set(handles.currthre, 'string', num2str(ThresthodValue));


handles.ThresthodValue = ThresthodValue;
handles.SavedSignal = SavedSignal;
handles.data = data;
guidata(hObject, handles);
 
%% plot
% plot original data
axes(handles.axes2);
plot(data);
hold on;
% plot signals data
for idx = 1:100
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
% x0 = linspace(0,3.1415926*2,2000000);
% y0 = sin(x0) * 0.005;
% y1 = ones(1,size(x0, 2)) * handles.ThresthodValue / 1000 /17.7828;
% plot(y0, 'y');
% plot(y1, 'b');
thre_20ms = max(abs(SavedSignal(:, 6))) * 1.1;
plot20ms(thre_20ms);
plot20ms_thre(ThresthodValue);
xlim([0 2000000]);
hold off;
%% show signals count
set(handles.text_signal_cnt, 'string', num2str(length(start_idxs)));

%% set count iterate for popup menu
%b = int2str(  (1:length(start_idxs))'  );
%set(handles.popupmenu2, 'string',  num2str([1,2,3,4]'));
b = 1:length(start_idxs);
set(handles.popupmenu1, 'string',  num2str(b'));

%% prepare statis
l_rise_time = SavedSignal(:, 4);
l_loc = SavedSignal(:, 1);
l_flag = SavedSignal(:, 7);
l_pv = SavedSignal(:, 6);
l_t = SavedSignal(:, 17);
l_w = SavedSignal(:, 18);

% normal pic
axes(handles.axes4);
plot(l_loc, l_flag.*l_pv, '.')
plot20ms(5)
xlabel('PD Location')
ylabel('Peak Voltage')


% polar pic
axes(handles.axes5);
polar(l_loc, l_flag.*l_pv, '.')

% rise_time
axes(handles.axes6);
hist(l_rise_time)
xlabel('Rise Time')

% tw mapping
axes(handles.axes7);
plot(l_t, l_w, '.')
xlabel('T')
ylabel('W')



% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


idx = get(handles.popupmenu1, 'Value');

% plot concrete data
axes(handles.axes3);
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
