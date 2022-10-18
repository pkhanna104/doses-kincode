function varargout = explore_dip_flip(varargin)
% EXPLORE_DIP_FLIP MATLAB code for explore_dip_flip.fig
%      EXPLORE_DIP_FLIP, by itself, creates a new EXPLORE_DIP_FLIP or raises the existing
%      singleton*.
%
%      H = EXPLORE_DIP_FLIP returns the handle to a new EXPLORE_DIP_FLIP or the handle to
%      the existing singleton*.
%
%      EXPLORE_DIP_FLIP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPLORE_DIP_FLIP.M with the given input arguments.
%
%      EXPLORE_DIP_FLIP('Property','Value',...) creates a new EXPLORE_DIP_FLIP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before explore_dip_flip_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to explore_dip_flip_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help explore_dip_flip

% Last Modified by GUIDE v2.5 18-Oct-2022 06:50:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @explore_dip_flip_OpeningFcn, ...
                   'gui_OutputFcn',  @explore_dip_flip_OutputFcn, ...
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


% --- Executes just before explore_dip_flip is made visible.
function explore_dip_flip_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to explore_dip_flip (see VARARGIN)

% Choose default command line output for explore_dip_flip
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes explore_dip_flip wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = explore_dip_flip_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Value = round(get(hObject, 'Value'));
set(hObject, 'Value', Value);
handles.N = Value; 
set(handles.text4, 'String', ['n = ' num2str(handles.N) '/' num2str(length(handles.angles_ind_dip))]);
handles = plot_3d(handles); 

guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in load_jt_data.
function load_jt_data_Callback(hObject, eventdata, handles)
% hObject    handle to load_jt_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile;
% load jt data
data_jt = load([pathname filename]); 
handles.Index_DIP = data_jt.angle_struct.Index_DIP; 
set(handles.jt_data_n, 'String', ['n = ' num2str(length(handles.Index_DIP))]);
handles.dip_line = plot(handles.dip_angle, handles.Index_DIP(1:100), 'r-'); hold all; 
handles.dip_dot = plot(handles.dip_angle, 1, handles.Index_DIP(1), 'b.'); 

guidata(hObject, handles);

% --- Executes on button press in load_angle_data.
function load_angle_data_Callback(hObject, eventdata, handles)
% hObject    handle to load_angle_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile;
% load angle data
data_ang = load([pathname filename]); 
index_dip = 7; 
index_pip = 6; 

handles.angles_ind_dip = data_ang.affected.angle_data(:, :, index_dip); 
handles.angles_ind_pip = data_ang.affected.angle_data(:, :, index_pip); 

set(handles.angle_data_n, 'String', ['n = ' num2str(length(handles.angles_ind_dip))]);
set(handles.text4, 'String', ['n = 1/' num2str(length(handles.angles_ind_dip))]);
set(handles.slider1, 'Max', length(handles.angles_ind_dip))
set(handles.slider1, 'Min', 1)
set(handles.slider1, 'Value', 1)
set(handles.slider1, 'SliderStep', [1/(length(handles.angles_ind_dip)-1), .1])

handles.N = 1; 

handles = plot_3d(handles); 
guidata(hObject, handles);


function [handles] = plot_3d(handles)
    N = handles.N; 

    % points in z direction; 
    [Z, Y, X] = cylinder(.1, 20); 
    cylinder_dat = cat(3, X, Y, Z); 
    cylinder_dat = permute(cylinder_dat, [3, 1, 2]); 

    R_dip = eul2rotm(deg2rad(handles.angles_ind_dip(N, :))); 
    R_pip = eul2rotm(deg2rad(handles.angles_ind_pip(N, :))); 
    
    handles.cyl_dip = []; 
    handles.cyl_pip = []; 
    
    for i = 1:21
        handles.cyl_dip = cat(3, handles.cyl_dip, R_dip*cylinder_dat(:, :, i));
        handles.cyl_pip = cat(3, handles.cyl_pip, R_pip*cylinder_dat(:, :, i));
    end
        
    if isfield(handles, 'dip')
        set(handles.dip, 'XData', squeeze(handles.cyl_dip(1, :, :)))
        set(handles.dip, 'YData', squeeze(handles.cyl_dip(2, :, :)))
        set(handles.dip, 'ZData', squeeze(handles.cyl_dip(3, :, :)))
        
        set(handles.pip, 'XData', squeeze(handles.cyl_pip(1, :, :)))
        set(handles.pip, 'YData', squeeze(handles.cyl_pip(2, :, :)))
        set(handles.pip, 'ZData', squeeze(handles.cyl_pip(3, :, :)))
        
    else
        axes(handles.axes_3d); hold all; grid on; xlim([-5, 5]); ylim([-5, 5]); zlim([-5, 5])
        handles.dip = surf(handles.axes_3d, squeeze(handles.cyl_dip(1, :, :)),...
                             squeeze(handles.cyl_dip(2, :, : )),...
                             squeeze(handles.cyl_dip(3, :, :)), "FaceColor","b"); 
        
        handles.pip = surf(handles.axes_3d, squeeze(handles.cyl_pip(1, :, :)),...
                             squeeze(handles.cyl_pip(2, :, : )),...
                             squeeze(handles.cyl_pip(3, :, :)), "FaceColor","g");
    end
    if N > 100
        indices = N-100:N+100;
    else
        indices = 1:200; 
    end

    set(handles.dip_line, 'YData', handles.Index_DIP(indices))
    set(handles.dip_line, 'XData', indices); 
    set(handles.dip_dot, 'XData', N); 
    set(handles.dip_dot, 'YData', handles.Index_DIP(N)); 


    
