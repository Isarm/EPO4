function varargout = matlabgui(varargin)
%MATLABGUI MATLAB code file for matlabgui.fig
%      MATLABGUI, by itself, creates a new MATLABGUI or raises the existing
%      singleton*.
%
%      H = MATLABGUI returns the handle to a new MATLABGUI or the handle to
%      the existing singleton*.
%
%      MATLABGUI('Property','Value',...) creates a new MATLABGUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to matlabgui_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      MATLABGUI('CALLBACK') and MATLABGUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in MATLABGUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help matlabgui

% Last Modified by GUIDE v2.5 06-May-2019 12:32:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @matlabgui_OpeningFcn, ...
                   'gui_OutputFcn',  @matlabgui_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before matlabgui is made visible.
function matlabgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for matlabgui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes matlabgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = matlabgui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ReadSensors.
function ReadSensors_Callback(hObject, eventdata, handles)
% hObject    handle to ReadSensors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sensorleft
global sensorright
global delay
global time
tic
n= 1000;            %number of samples
duration = 10;      %length of sampling interval
for i = 1:n
[sensorleft(i), sensorright(i), delay(i)] = getdistance();

set(handles.sensor_left, 'string', sensorleft(i));
set(handles.sensor_right, 'string', sensorright(i));
set(handles.delaytime, 'string', delay(i));
time(i) = i;
% speed(i) = str2num(get(handles.speed, 'string'));
% direction(i) = str2num(get(handles.direction, 'string'));
% input = get(gcf, 'currentkey');
% [new_speed(i), new_direction(i)]=drive(speed(i), direction(i), input);
% %plot(time,sensorleft);
% set(handles.speed, 'string', new_speed(i));
% set(handles.direction, 'string', new_direction(i));
pause(0.01);
end
% time = [1 : n]*duration/n;
% figure;
% plot(time,sensorleft);
% plot(time,sensorright);
% plot(time,delay); 
% xlabel('time(s)')
% ylabel('sensordistance(cm)')
% title('sensormeasurements');



% --- Executes on button press in OpenConnection.
function OpenConnection_Callback(hObject, eventdata, handles)
% hObject    handle to OpenConnection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Port = '\\.\COM10'; %Outgoing COM port 
result = EPOCommunications('open',Port) %Check the value of result
speed = 150;
direction = 150;
set(handles.speed, 'string', speed);
set(handles.direction, 'string', direction);

% --- Executes on button press in CloseConnection.
function CloseConnection_Callback(hObject, eventdata, handles)
% hObject    handle to CloseConnection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
disp(sensorleft)
disp(sensorright)
% handles    structure with handles and user data (see GUIDATA)
result = EPOCommunications('close') %Check the value of result


% --- Executes on button press in Drive_button.
function Drive_button_Callback(hObject, eventdata, handles)
% hObject    handle to Drive_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
d = (get(handles.editdirection, 'string'))
s = (get(handles.editspeed, 'string'));
signal = ['D',d];
EPOCommunications('transmit',signal);
signal = ['M',s];
EPOCommunications('transmit',signal);
set(handles.speed, 'string', s);
set(handles.direction, 'string', d);

% --- Executes on button press in Stopbutton.
function Stopbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Stopbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
d = int2str(150);
s = int2str(150);
signal = ['D',d];
EPOCommunications('transmit',signal);
signal = ['M',s];
EPOCommunications('transmit',signal);
set(handles.speed, 'string', s);
set(handles.direction, 'string', d);



function editspeed_Callback(hObject, eventdata, handles)
% hObject    handle to editspeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editspeed as text
%        str2double(get(hObject,'String')) returns contents of editspeed as a double


% --- Executes during object creation, after setting all properties.
function editspeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editspeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editdirection_Callback(hObject, eventdata, handles)
% hObject    handle to editdirection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editdirection as text
%        str2double(get(hObject,'String')) returns contents of editdirection as a double


% --- Executes during object creation, after setting all properties.
function editdirection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editdirection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Challenge1button.
function Challenge1button_Callback(hObject, eventdata, handles)
% hObject    handle to Challenge1button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
distance = str2num(get(handles.challenge1input, 'string'));
challenge1(distance);



function challenge1input_Callback(hObject, eventdata, handles)
% hObject    handle to challenge1input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of challenge1input as text
%        str2double(get(hObject,'String')) returns contents of challenge1input as a double


% --- Executes during object creation, after setting all properties.
function challenge1input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to challenge1input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
