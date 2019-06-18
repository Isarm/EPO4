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

% Last Modified by GUIDE v2.5 18-Jun-2019 09:22:59

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

% --- Executes on button press in OpenConnection.
function OpenConnection_Callback(hObject, eventdata, handles)
% hObject    handle to OpenConnection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%The variables are defined as globals
global forbreak;
global sensorleft;
global sensorright;
global delay;
global voltage;
global time;

%The connection with the KITT is made
comport = get(handles.comport, 'string'); %% The value of the comport-field is asked and saved
Port = ['\\.\COM' comport] %Outgoing COM port 
result = EPOCommunications('open',Port) %Check the value of result

%The speed and direction are initialized and set at the textfields
speed = 150;
direction = 150;
set(handles.speed, 'string', speed);
set(handles.direction, 'string', direction);

%A infite while loop is made, such that the values keep updating
forbreak =0; %This value is set to zero
i=0;
while(1)
i=i+1;  
tic; %The function tic is called to measure the time difference between two measurements

% The values are asked by calling a function and are set at the textfields
[sensorleft(i), sensorright(i), delay(i), voltage(i)] = sensorDistance();
set(handles.sensor_left, 'string', sensorleft(i));
set(handles.sensor_right, 'string', sensorright(i));
set(handles.delaytime, 'string', delay(i));
set(handles.voltage, 'string', voltage(i));

pause(0.001); % A small delay is implemented

%If the variable 'forbreak' is put to 1 somewhere, this while loop will
%close
if (forbreak == 1);
    break
end

time(i) = toc; %The total time between two measurements is saved in the array time.
end

% --- Executes on button press in CloseConnection.
function CloseConnection_Callback(hObject, eventdata, handles)
% hObject    handle to CloseConnection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%The variable 'forbreak' is set to 1, so that the while loop will close
global forbreak;
forbreak = 1;

%The connection is closed
result = EPOCommunications('close') %Check the value of result


% --- Executes on button press in Drive_button.
function Drive_button_Callback(hObject, eventdata, handles)
% hObject    handle to Drive_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%The values speed and direction are asked from the text fields and new
%commands are send to the KITT
d = (get(handles.editdirection, 'string'))
s = (get(handles.editspeed, 'string'));
signal = ['D',d];
EPOCommunications('transmit',signal);
signal = ['M',s];
EPOCommunications('transmit',signal);

%The text fields in the bottem right corner are updated with the new speed
%and direction
set(handles.speed, 'string', s);
set(handles.direction, 'string', d);

% --- Executes on button press in Stopbutton.
function Stopbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Stopbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%The new speed and direction are defined
d = int2str(150);
s = int2str(144); %The speed is set to 144 in order to make the wheels spin backwards

%The new values are sent and the values in the textfields are updated
signal = ['D',d];
EPOCommunications('transmit',signal);
signal = ['M',s];
EPOCommunications('transmit',signal);
set(handles.speed, 'string', s);
set(handles.direction, 'string', d);

%After a small pause the values are both set to 150
pause(2.5);
d = int2str(150);
s = int2str(150);

%The new values are sent to the KITT
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


% --- Executes on button press in Challenge1Button.
function Challenge1Button_Callback(hObject, eventdata, handles)
% hObject    handle to Challenge1Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%The inputs is asked from the textfield
beginx = str2double(get(handles.beginx, 'string'));
beginy = str2double(get(handles.beginy, 'string'));
beginangle = str2double(get(handles.begin_angle, 'string'));
interx1 = str2double(get(handles.interx1, 'string'));
intery1 = str2double(get(handles.intery1, 'string'));
interx2 = str2double(get(handles.interx2, 'string'));
intery2 = str2double(get(handles.intery2, 'string'));
interx3 = str2double(get(handles.interx3, 'string'));
intery3 = str2double(get(handles.intery3, 'string'));

coor
%A while loop is made and waiting for the enter
while(1)
    start = get(gcf,'currentkey'); %Start will get the value of the last pushed keyboard button
    if(strcmp('return', start)) %if the enter button is pushed, challenge 1 will run
        drive2([interx1, intery1; interx2, intery2; interx3, intery3], beginangle, beginx, beginy,0);
        break
    else
        display('waiting');     %The car will let the user know it is waiting
        
        %If the escape button is pushed, the while loop is broken.
        if(strcmp('escape', start))
            break
        end
        pause(0.5);
        
    end
end


function beginx_Callback(hObject, eventdata, handles)
% hObject    handle to beginx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of beginx as text
%        str2double(get(hObject,'String')) returns contents of beginx as a double


% --- Executes during object creation, after setting all properties.
function beginx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beginx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function comport_Callback(hObject, eventdata, handles)
% hObject    handle to comport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of comport as text
%        str2double(get(hObject,'String')) returns contents of comport as a double


% --- Executes during object creation, after setting all properties.
function comport_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function challenge1input2_Callback(hObject, eventdata, handles)
% hObject    handle to challenge1input2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of challenge1input2 as text
%        str2double(get(hObject,'String')) returns contents of challenge1input2 as a double


% --- Executes during object creation, after setting all properties.
function challenge1input2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to challenge1input2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Find_wall.
function Find_wall_Callback(hObject, eventdata, handles)
% hObject    handle to Find_wall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
wallfinder();



function intery2_Callback(hObject, eventdata, handles)
% hObject    handle to intery2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of intery2 as text
%        str2double(get(hObject,'String')) returns contents of intery2 as a double


% --- Executes during object creation, after setting all properties.
function intery2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to intery2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function intery3_Callback(hObject, eventdata, handles)
% hObject    handle to intery3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of intery3 as text
%        str2double(get(hObject,'String')) returns contents of intery3 as a double


% --- Executes during object creation, after setting all properties.
function intery3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to intery3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function interx3_Callback(hObject, eventdata, handles)
% hObject    handle to interx3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of interx3 as text
%        str2double(get(hObject,'String')) returns contents of interx3 as a double


% --- Executes during object creation, after setting all properties.
function interx3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to interx3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function interx2_Callback(hObject, eventdata, handles)
% hObject    handle to interx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of interx2 as text
%        str2double(get(hObject,'String')) returns contents of interx2 as a double


% --- Executes during object creation, after setting all properties.
function interx2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to interx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function intery1_Callback(hObject, eventdata, handles)
% hObject    handle to intery1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of intery1 as text
%        str2double(get(hObject,'String')) returns contents of intery1 as a double


% --- Executes during object creation, after setting all properties.
function intery1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to intery1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function interx1_Callback(hObject, eventdata, handles)
% hObject    handle to interx1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of interx1 as text
%        str2double(get(hObject,'String')) returns contents of interx1 as a double


% --- Executes during object creation, after setting all properties.
function interx1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to interx1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function beginy_Callback(hObject, eventdata, handles)
% hObject    handle to beginy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of beginy as text
%        str2double(get(hObject,'String')) returns contents of beginy as a double


% --- Executes during object creation, after setting all properties.
function beginy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beginy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function begin_angle_Callback(hObject, eventdata, handles)
% hObject    handle to begin_angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of begin_angle as text
%        str2double(get(hObject,'String')) returns contents of begin_angle as a double


% --- Executes during object creation, after setting all properties.
function begin_angle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to begin_angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Challenge2button.
function Challenge2button_Callback(hObject, eventdata, handles)
% hObject    handle to Challenge2button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%The inputs is asked from the textfield
beginx = str2double(get(handles.beginx, 'string'));
beginy = str2double(get(handles.beginy, 'string'));
beginangle = str2double(get(handles.begin_angle, 'string'));
interx1 = str2double(get(handles.interx1, 'string'));
intery1 = str2double(get(handles.intery1, 'string'));
interx2 = str2double(get(handles.interx2, 'string'));
intery2 = str2double(get(handles.intery2, 'string'));
interx3 = str2double(get(handles.interx3, 'string'));
intery3 = str2double(get(handles.intery3, 'string'));

coor
%A while loop is made and waiting for the enter
while(1)
    start = get(gcf,'currentkey'); %Start will get the value of the last pushed keyboard button
    if(strcmp('return', start)) %if the enter button is pushed, challenge 1 will run
        drive2([interx1, intery1; interx2, intery2; interx3, intery3], beginangle, beginx, beginy,0);
        break
    else
        display('waiting');     %The car will let the user know it is waiting
        
        %If the escape button is pushed, the while loop is broken.
        if(strcmp('escape', start))
            break
        end
        pause(0.5);
        
    end
end


% --- Executes on button press in Challenge3button.
function Challenge3button_Callback(hObject, eventdata, handles)
% hObject    handle to Challenge3button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%The inputs is asked from the textfield
beginx = str2double(get(handles.beginx, 'string'));
beginy = str2double(get(handles.beginy, 'string'));
beginangle = str2double(get(handles.begin_angle, 'string'));
interx1 = str2double(get(handles.interx1, 'string'));
intery1 = str2double(get(handles.intery1, 'string'));
interx2 = str2double(get(handles.interx2, 'string'));
intery2 = str2double(get(handles.intery2, 'string'));
interx3 = str2double(get(handles.interx3, 'string'));
intery3 = str2double(get(handles.intery3, 'string'));

coor
%A while loop is made and waiting for the enter
while(1)
    start = get(gcf,'currentkey'); %Start will get the value of the last pushed keyboard button
    if(strcmp('return', start)) %if the enter button is pushed, challenge 1 will run
        drive2([interx1, intery1; interx2, intery2; interx3, intery3], beginangle, beginx, beginy,1);
        break
    else
        display('waiting');     %The car will let the user know it is waiting
        
        %If the escape button is pushed, the while loop is broken.
        if(strcmp('escape', start))
            break
        end
        pause(0.5);
        
    end
end


% --- Executes on button press in wallbutton.
function wallbutton_Callback(hObject, eventdata, handles)
% hObject    handle to wallbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[wallx wally, circlex, circley]= wallfinder(200,200,6*pi/4);
figure
plot(circlex, circley)
hold on;
plot(wallx, wally , 'x')
xlim([0 460]);
ylim([0 460]);
