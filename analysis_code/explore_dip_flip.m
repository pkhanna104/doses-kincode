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

% Last Modified by GUIDE v2.5 05-Mar-2023 17:58:37

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
guidata(hObject, handles);


function [handles] = plot_3d(handles)
    N = handles.N; 

    % points in z direction; 
    [Z, Y, X] = cylinder(.01, 20); 
    cylinder_dat = cat(3, X, Y, Z); 

    % Now points in the x direction 
    cylinder_dat = permute(cylinder_dat, [3, 1, 2]); 

    R_dip = eul2rotm(deg2rad(handles.angles_ind_dip(N, :))); 
    R_pip = eul2rotm(deg2rad(handles.angles_ind_pip(N, :))); 
    
    handles.cyl_dip = []; 
    handles.cyl_pip = []; 
    
    for i = 1:21
        handles.cyl_dip = cat(3, handles.cyl_dip, R_dip*cylinder_dat(:, :, i));
        handles.cyl_pip = cat(3, handles.cyl_pip, R_pip*cylinder_dat(:, :, i));
    end
        
    % planes based on baseline 
    % r15j affected: 
    hand_nm = 'Left'; 
    
    % Rotate vectors by rotation matrix 
    roll1 = diff_roll(handles.dip_bl(3), handles.angles_ind_dip(N, 3), hand_nm);
    dip2 = [handles.angles_ind_dip(N, 1) handles.angles_ind_dip(N, 2) roll1]; 

    roll2 = diff_roll(handles.pip_bl(3), handles.angles_ind_pip(N, 3), hand_nm);
    pip2 = [handles.angles_ind_pip(N, 1) handles.angles_ind_pip(N, 2) roll2];
    
    R_dip2 = eul2rotm(deg2rad(dip2)); 
    R_pip2 = eul2rotm(deg2rad(pip2)); 
    
    [X, Y, Z] = meshgrid(0:.1:1, 0:.1:1, 0:.1:0); 
    X = reshape(X, [numel(X), 1]); 
    Y = reshape(Y, [numel(Y), 1]); 
    Z = reshape(Z, [numel(Z), 1]); 
    D = [X Y Z]'; % 3 x ndata
    
    V1 = R_dip2*D; 
    V2 = R_pip2*D; 
    
    % Plot plane 
    v1 = R_dip2*[1 0 0; 0 1 0]'; 
    v2 = R_pip2*[1 0 0; 0 1 0]'; 
    
    cross1 = cross(v1(:, 1), v1(:, 2)); %normal vector to  vector1 and 2 on plane 1; 
    cross1_norm = cross1 / norm(cross1); 
     
    % Project vector1 from plane 2 in direction of sensor V2(:, 1) onto
    % plane 1; 
    proj_V2_plane1 = v2(:, 1) - (dot(v2(:, 1), cross1_norm)*cross1_norm); 
    V2_plane2 = v2(:, 1); 

    % Bend angle b/w proj_V2_plane1 and vector2 
    ba = acosd(dot(proj_V2_plane1, v2(:, 1)));
     
    % Determining whether bend angle is up or down (pos or neg).  
    pn = cross(proj_V2_plane1, v2(:, 1));  %determine normal vector to vector 1 and projected vector 3
    norm_rot = R_pip2'*pn;  %undo rotation from vector to plane
    
    % Convention -- flexion is +
    index = 2;  sgn = 1; 
    if norm_rot(index) < 0; sgn = -1; end

    if isfield(handles, 'dip')
        set(handles.dip, 'XData', squeeze(handles.cyl_dip(1, :, :)))
        set(handles.dip, 'YData', squeeze(handles.cyl_dip(2, :, :)))
        set(handles.dip, 'ZData', squeeze(handles.cyl_dip(3, :, :)))
        
        set(handles.pip, 'XData', squeeze(handles.cyl_pip(1, :, :)))
        set(handles.pip, 'YData', squeeze(handles.cyl_pip(2, :, :)))
        set(handles.pip, 'ZData', squeeze(handles.cyl_pip(3, :, :)))

        set(handles.dip_plane, 'XData', V1(1, :))
        set(handles.dip_plane, 'YData', V1(2, :))
        set(handles.dip_plane, 'ZData', V1(3, :))

        set(handles.pip_plane, 'XData', V2(1, :))
        set(handles.pip_plane, 'YData', V2(2, :))
        set(handles.pip_plane, 'ZData', V2(3, :))
        
        set(handles.pip_vect, 'XData', [0, V2_plane2(1)])
        set(handles.pip_vect, 'YData', [0, V2_plane2(2)])
        set(handles.pip_vect, 'ZData', [0, V2_plane2(3)])
        
        set(handles.dip_vect, 'XData', [0, proj_V2_plane1(1)])
        set(handles.dip_vect, 'YData', [0, proj_V2_plane1(2)])
        set(handles.dip_vect, 'ZData', [0, proj_V2_plane1(3)])

        set(handles.sign_text, 'String', ['sign = ' num2str(sgn)]);

        

    else
        axes(handles.axes_3d); hold all; grid on; 
        xlim([-1, 1]); ylim([-1, 1]); zlim([-1, 1])
        xlabel('x')
        ylabel('y')
        zlabel('z')
        handles.dip = surf(handles.axes_3d, squeeze(handles.cyl_dip(1, :, :)),...
                             squeeze(handles.cyl_dip(2, :, : )),...
                             squeeze(handles.cyl_dip(3, :, :)), "FaceColor","b"); 
        
        handles.pip = surf(handles.axes_3d, squeeze(handles.cyl_pip(1, :, :)),...
                             squeeze(handles.cyl_pip(2, :, : )),...
                             squeeze(handles.cyl_pip(3, :, :)), "FaceColor","g");

        handles.dip_plane = plot3(handles.axes_3d, V1(1, :), V1(2, :), V1(3, :), "b.-");
        handles.pip_plane = plot3(handles.axes_3d, V2(1, :), V2(2, :), V2(3, :), "g.-");
        
        handles.pip_vect = plot3(handles.axes_3d, [0, V2_plane2(1)], [0, V2_plane2(2)],...
            [0, V2_plane2(3)], 'g-'); 
        handles.dip_vect = plot3(handles.axes_3d, [0, proj_V2_plane1(1)], [0, proj_V2_plane1(2)],...
            [0, proj_V2_plane1(3)], 'b-'); 

        set(handles.sign_text, 'String', ['sign = ' num2str(sgn)]);
        
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


% --- Executes on button press in load_baseline.
function load_baseline_Callback(hObject, eventdata, handles)
% hObject    handle to load_baseline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile;
% load baseline data
data_ang = load([pathname filename]); 

index_dip = 7; 
index_pip = 6; 

handles.dip_bl = data_ang.data.angles.(['sensor' num2str(index_dip)])(end, :); 
handles.pip_bl = data_ang.data.angles.(['sensor' num2str(index_pip)])(end, :); 

guidata(hObject, handles);
