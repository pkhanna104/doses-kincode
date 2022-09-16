function varargout = angle_validation_gui(varargin)
% ANGLE_VALIDATION_GUI MATLAB code for angle_validation_gui.fig
%      ANGLE_VALIDATION_GUI, by itself, creates a new ANGLE_VALIDATION_GUI or raises the existing
%      singleton*.
%
%      H = ANGLE_VALIDATION_GUI returns the handle to a new ANGLE_VALIDATION_GUI or the handle to
%      the existing singleton*.
%
%      ANGLE_VALIDATION_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANGLE_VALIDATION_GUI.M with the given input arguments.
%
%      ANGLE_VALIDATION_GUI('Property','Value',...) creates a new ANGLE_VALIDATION_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before angle_validation_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to angle_validation_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help angle_validation_gui

% Last Modified by GUIDE v2.5 24-Aug-2022 13:45:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @angle_validation_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @angle_validation_gui_OutputFcn, ...
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


% --- Executes just before angle_validation_gui is made visible.
function angle_validation_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to angle_validation_gui (see VARARGIN)

% Choose default command line output for angle_validation_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes angle_validation_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Try populating the table here
jts = {'Thumb MCP',
'Thumb DIP',
'Index DIP',
'Index PIP',
'Index MCP',
'Palm Flex',
'Palm Abd',
'Palm Prono',
'Elbow Flex',
'Shoulder Roll',
'Shoulder VertFlex',
'Shoulder HorzFlex'}; 

rows = {'Jt/Ang', 'Left', 'Right'}; 
cnt = 2; 
for j = 1:length(jts)
    [ang, ~] = jt_angle_list(convertCharsToStrings(jts{j})); 
    for a = 1:length(ang)
        rows{cnt, 1} = [jts{j} '_' num2str(ang(a))]; 
        rows{cnt, 2} = 0; 
        rows{cnt, 3} = 0; 
        cnt = cnt + 1; 
    end
end

% Set rows 
handles.status_table_data = rows;
set(handles.status_table, 'Data', rows)

guidata(hObject,handles)



% --- Outputs from this function are returned to the command line.
function varargout = angle_validation_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in jt_menu.
function jt_menu_Callback(hObject, eventdata, handles)
% hObject    handle to jt_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns jt_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from jt_menu

% Get selected angle 
contents = get(hObject,'String');
ang_str = contents{get(hObject,'Value')};

% Which angles to measure 
[angles, hint] = jt_angle_list(ang_str); 
set(handles.hint_box, 'String', hint); 
set(handles.angle_menu, 'String', angles); 
set(handles.angle_menu, 'Value', 1); 
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function jt_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to jt_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in hand_menu.
function hand_menu_Callback(hObject, eventdata, handles)
% hObject    handle to hand_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns hand_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from hand_menu


% --- Executes during object creation, after setting all properties.
function hand_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hand_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in angle_menu.
function angle_menu_Callback(hObject, eventdata, handles)
% hObject    handle to angle_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns angle_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from angle_menu


% --- Executes during object creation, after setting all properties.
function angle_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angle_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in collect_button.
function collect_button_Callback(hObject, eventdata, handles)
% hObject    handle to collect_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get data % 
Pos = {}; 
Ang = {};
for i = 1:100
    % get data
    [pos, ang] = get_positions(12);
    Pos{i} = pos; 
    Ang{i} = ang; 
end

% save this 
datastruct = load(handles.data_path); 
data = datastruct.data; 

jts = get(handles.jt_menu, 'String'); 
jt = jts{get(handles.jt_menu, 'Value')}; 

hnds = get(handles.hand_menu, 'String'); 
hnd = hnds{get(handles.hand_menu, 'Value')}; 

angles = get(handles.angle_menu, 'String'); 
ang = angles(get(handles.angle_menu, 'Value'), :); 
ang = strrep(ang, ' ', ''); % remove any spaces

newjt = strrep(jt,' ','_'); 
newang = strrep(ang, '-', 'n');

fld = [hnd '_' newjt '_' newang]; 

if isfield(data, fld)
    count = data.(fld).cnt; 
    
    pos_str = ['Pos' num2str(count + 1)]; 
    ang_str = ['Ang' num2str(count + 1)]; 
    
    data.(fld).(pos_str) = Pos; 
    data.(fld).(ang_str) = Ang; 
    data.(fld).cnt = count + 1; 
else
    ang_str = 'Ang1'; 
    data.(fld).Pos1 = Pos; 
    data.(fld).Ang1 = Ang;
    data.(fld).cnt = 1; 
end



% Print out estimate of angle
angle_struct = get_jt_angles(data.(fld).(ang_str)); 
ang_dat = angle_struct.(newjt); 

disp([' Mean ' newjt ': ' num2str(mean(ang_dat)) ' +/- ' num2str(std(ang_dat))]); 


% Save this % 
save(handles.data_path, 'data'); 

% Update table with counter 
nm = [jt '_' num2str(ang)]; 

% Set rows 
table = handles.status_table_data; 
for i = 1:length(table(:, 1))
    if strmatch(table{i, 1}, nm)
        if strmatch(convertCharsToStrings(hnd), 'Left')
            table{i, 2} = data.(fld).cnt; 
        elseif strmatch(convertCharsToStrings(hnd), 'Right')
            table{i, 3} = data.(fld).cnt; 
        end
    end
end

handles.status_table_data = table; 
set(handles.status_table, 'Data', table)

guidata(hObject,handles)


    
function dataset_nm_Callback(hObject, eventdata, handles)
% hObject    handle to dataset_nm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dataset_nm as text
%        str2double(get(hObject,'String')) returns contents of dataset_nm as a double


% --- Executes during object creation, after setting all properties.
function dataset_nm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dataset_nm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in create_dir.
function create_dir_Callback(hObject, eventdata, handles)
% hObject    handle to create_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

main_path = 'C:\Users\Ganguly Lab\Desktop\Kinematics Reboot 2022\';
path = [main_path get(handles.dataset_nm,'String')]; 
if ~isdir(path)
    mkdir(path)
end

% setup path 
handles.data_path = [path '\valid_data.mat'];

% show in GUI %
set(handles.dir_path, 'String', handles.data_path); 

% save something to the path to load later % 
data = struct(); 
save(handles.data_path, 'data'); 
guidata(hObject,handles)


% --- Executes on button press in init_tracker.
function init_tracker_Callback(hObject, eventdata, handles)
% hObject    handle to init_tracker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Run tracker setup 
ok_init = tracker_setup; 

if and(ok_init, isfield(handles, 'data_path'))
    set(handles.status, 'String', 'Ready')
    set(handles.status, 'ForegroundColor', 'g')
elseif ~ok_init
    set(handles.status, 'String', 'Issue w/ Init')
    set(handles.status, 'ForegroundColor', 'r')
end
guidata(hObject,handles)

% --- Executes on button press in status_button.
function status_button_Callback(hObject, eventdata, handles)
% hObject    handle to status_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in clear_jt.
function clear_jt_Callback(hObject, eventdata, handles)
% hObject    handle to clear_jt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get current joint 
jts = get(handles.jt_menu, 'String'); 
jt = jts{get(handles.jt_menu, 'Value')}; 

hnds = get(handles.hand_menu, 'String'); 
hnd = hnds{get(handles.hand_menu, 'Value')}; 

angles = get(handles.angle_menu, 'String'); 
ang = angles(get(handles.angle_menu, 'Value'), :); 
ang = strrep(ang, ' ', ''); % remove any spaces

newjt = strrep(jt,' ','_'); 
newang = strrep(ang, '-', 'n');

relevant_fld = [hnd '_' newjt '_' newang]; 

load(handles.data_path); 

data = rmfield(data, relevant_fld); 

save(handles.data_path, 'data'); 


% --- Executes on button press in stream_toggle.
function stream_toggle_Callback(hObject, eventdata, handles)
% hObject    handle to stream_toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stream_toggle
if get(hObject,'Value')
    
    datastruct = load(handles.data_path); 
    temp_data = datastruct.data; 

    jts = get(handles.jt_menu, 'String'); 
    jt = jts{get(handles.jt_menu, 'Value')}; 

    hnds = get(handles.hand_menu, 'String'); 
    hnd = hnds{get(handles.hand_menu, 'Value')}; 

    angles = get(handles.angle_menu, 'String'); 
    ang = angles(get(handles.angle_menu, 'Value'), :); 
    ang = strrep(ang, ' ', ''); % remove any spaces

    newjt = strrep(jt,' ','_'); 
    newang = strrep(ang, '-', 'n');

    fld = [hnd '_' newjt '_' newang]; 

    for i = 1:500
        % get data -- 
        [~, ang] = get_positions(12);
        Ang{1} = ang; 
        [~, ang] = get_positions(12);
        Ang{2} = ang;
        
        angle_struct = get_jt_angles(Ang); 
        ang_dat = angle_struct.(newjt); 
        disp([ newjt ': ' num2str(ang_dat)]); 
        pause(.05);
    end
end
