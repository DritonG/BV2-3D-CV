function varargout = gui(varargin)
% GUI M-file for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 25-Jun-2013 16:58:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global correspondences;
global F;
global im_left;
global im_right;

correspondences=[];
F=[];
im_left = 0;
im_right = 0;

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function filename_left_Callback(hObject, eventdata, handles)
% hObject    handle to filename_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filename_left as text
%        str2double(get(hObject,'String')) returns contents of filename_left as a double


% --- Executes during object creation, after setting all properties.
function filename_left_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filename_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function filename_right_Callback(hObject, eventdata, handles)
% hObject    handle to filename_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filename_right as text
%        str2double(get(hObject,'String')) returns contents of filename_right as a double


% --- Executes during object creation, after setting all properties.
function filename_right_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filename_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function click(src,ev)
    global im_left;
    global im_right;
    global corr_temp;
    global F;
    global correspondences;
    handles=guidata(src); %load handles structure.

    clicked=get(handles.axes_image_left,'currentpoint');
    xi = round(clicked(1,1,1));
    yi = round(clicked(1,2,1));
    
    if numel(F) > 1
        redraw_epipolar(handles,[xi yi]);

    else
        is_rect = get(handles.is_rect,'value');
        use_grayscale = get(handles.use_grayscale,'value');

        wsx = str2num(get(handles.window_x,'String'));
        wsy = str2num(get(handles.window_y,'String'));
        rx = str2num(get(handles.range_x,'String'));
        ry = str2num(get(handles.range_y,'String'));
        
        if (is_rect)
            ry = 0;
        end
        
        axes(handles.axes_image_left);    
        imshow(im_left);
        hold on
        plot(xi,yi,'m*');
        hold off;
        axis off;
        set(handles.messages,'String',sprintf('Selected point in left image: (%d,%d) - search for correspondence...',xi,yi));
        drawnow;
        
        if use_grayscale
            [a b] = correlation(rgb2gray(im_left),rgb2gray(im_right),xi,yi,wsx,wsy,rx,ry);
        else
            [a b] = correlation(im_left,im_right,xi,yi,wsx,wsy,rx,ry);
        end
        
        corr_temp=[xi yi a b];
        redraw_corr(handles,corr_temp);
        set(handles.messages,'String',sprintf('Selected point in left image: (%d,%d) - found correspondance in right image: (%d,%d).',xi,yi,a,b));
        set(handles.pushbutton_add,'Enable','on');
    end
   
function click_r(src,ev)
    global corr_temp;
    
    handles=guidata(src); %load handles structure.

    clicked=get(handles.axes_image_right,'currentpoint');
    xi = round(clicked(1,1,1));
    yi = round(clicked(1,2,1));
    
    corr_temp(3) = xi;
    corr_temp(4) = yi;
    redraw_corr(handles,corr_temp);
    set(handles.messages,'String',sprintf('Selected point in left image: (%d,%d) - corrected correspondance in right image: (%d,%d).',corr_temp(1),corr_temp(2),xi,yi));

function redraw_epipolar(handles,tmp)    
    global im_left;
    global im_right;
    global correspondences;
    global F;
    
    sc=size(correspondences);
    s=size(im_left);
    
    % "replot" left image
    axes(handles.axes_image_right);    
    imshow(im_right);
    hold on;
    if sc(1)>0
        plot_corr(correspondences(:,3:4));
        plot_epipolar(F,correspondences,s);
    end
    
    if numel(tmp) > 1
        % plot new epi line
        plot_epi_line(F,tmp,s(2),'b');
    end
    hold off;
    axis off;

    % "replot" right image
    axes(handles.axes_image_left);    
    im_handle = imshow(im_left);
    set(im_handle, 'ButtonDownFcn', @click); 
    hold on;
    if sc(1)>0
        plot_corr(correspondences(:,1:2));
    end
    if numel(tmp) > 1
        plot(tmp(1),tmp(2),'b*');
    end
    hold off;
    axis off;
    
function redraw_corr(handles,tmp)
    global im_left;
    global im_right;
    global correspondences;
    
    sc=size(correspondences);
    axes(handles.axes_image_left);    
    im_handle = imshow(im_left);
    set(im_handle, 'ButtonDownFcn', @click);
    hold on
    if sc(1)>0
        plot_corr(correspondences(:,1:2));
    end
    if numel(tmp) > 1
        plot(tmp(1),tmp(2),'b*');
    end
    hold off;
    axis off;

    axes(handles.axes_image_right);
    im_handle = imshow(im_right);
    hold on
    if sc(1)>0
        plot_corr(correspondences(:,3:4));
    end
    if numel(tmp) > 1
        plot(tmp(3),tmp(4),'b*');
        set(im_handle, 'ButtonDownFcn', @click_r);
    end
    hold off;
    axis off; 
   
function plot_corr(corr)
    s = size(corr);
    for i = 1:s(1)
        plot(corr(i,1),corr(i,2),'r*');
    end

function plot_epipolar(F,correspondences,im_size)
    sc = size(correspondences);
    for i = 1:sc(1)
        plot_epi_line(F,correspondences(i,1:2),im_size(2),'r');
    end
       
% --- Executes on button press in pushbutton_load.
function pushbutton_load_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_left;
global im_right;
global correspondences;
global F;

image_file_name_left=get(handles.filename_left,'String');
image_file_name_right=get(handles.filename_right,'String');
if ~isempty(image_file_name_left) && ~isempty(image_file_name_right)
    im_left=imread(char(image_file_name_left));
    im_right=imread(char(image_file_name_right));
    correspondences=[];
    F=[];
    axes(handles.axes_image_right);    
    imshow(im_right);
    axis off;
    axes(handles.axes_image_left);    
    im_handle = imshow(im_left);
    set(im_handle, 'ButtonDownFcn', @click); 
    axis off;
    set(handles.messages,'String','Images successfully loaded. Click in left image to find correspondences.');
end 


% --- Executes on button press in pushbutton_reset.
function pushbutton_reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global correspondences;
global F;
correspondences=[];
F=[];
set(handles.pushbutton_fundamental,'Enable','off');
set(handles.pushbutton_add,'Enable','off');
set(handles.messages,'String','Reset done. Click in left image to find correspondences.');
redraw_corr(handles,[]);


% --- Executes on button press in pushbutton_add.
function pushbutton_add_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global corr_temp;
global correspondences;

if numel(correspondences) < 4
    correspondences = corr_temp;
else
    correspondences(end+1,:) = corr_temp;
end
redraw_corr(handles,[]);
if size(correspondences,1) > 7;
    set(handles.pushbutton_fundamental,'Enable','on');
end
set(handles.messages,'String',sprintf('Added new correspondance (total of %d).',size(correspondences,1)));


% --- Executes on button press in pushbutton_fundamental.
function pushbutton_fundamental_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_fundamental (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global correspondences;
global F;
F = fundamentalMatrix(correspondences);
err = distance(F,correspondences);
set(handles.messages,'String',sprintf('Fundamental Matrix computed (Quality: %d). Click on the left image to show the corresponding epiporlar-line in the right image.',err));
set(handles.pushbutton_add,'Enable','off');
set(handles.pushbutton_fundamental,'Enable','off');
redraw_epipolar(handles,[]);

% --- Executes on button press in pushbutton_compute_disparity.
function pushbutton_compute_disparity_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_compute_disparity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_left;
global im_right;
global F;

IM=compute_disparity_map(im_left,im_right,F,7,32);
axes(handles.axes_disparity);    
image(IM*(256/32));
axis off;
imwrite(IM,'depth.png');

% --- Executes on button press in open_left.
function open_left_Callback(hObject, eventdata, handles)
% hObject    handle to open_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, path] = uigetfile({'*.jpg;*.png','Image File(*.jpg,*.png)';'*.jpg','JPG File';'*.png','PNG File'},'Select the right image file');
filename = fullfile(path, filename)
if ~isempty(filename)
    set(handles.filename_left,'String',filename);
end

% --- Executes on button press in open_right.
function open_right_Callback(hObject, eventdata, handles)
% hObject    handle to open_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, path] = uigetfile({'*.jpg;*.png','Image File(*.jpg,*.png)';'*.jpg','JPG File';'*.png','PNG File'},'Select the right image file');
filename = fullfile(path, filename)
if ~isempty(filename)
    set(handles.filename_right,'String',filename);
end

% --- Executes on button press in is_rect.
function is_rect_Callback(hObject, eventdata, handles)
% hObject    handle to is_rect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of is_rect


% --- Executes on button press in use_grayscale.
function use_grayscale_Callback(hObject, eventdata, handles)
% hObject    handle to use_grayscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of use_grayscale



function range_x_Callback(hObject, eventdata, handles)
% hObject    handle to range_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of range_x as text
%        str2double(get(hObject,'String')) returns contents of range_x as a double


% --- Executes during object creation, after setting all properties.
function range_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to range_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function range_y_Callback(hObject, eventdata, handles)
% hObject    handle to range_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of range_y as text
%        str2double(get(hObject,'String')) returns contents of range_y as a double


% --- Executes during object creation, after setting all properties.
function range_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to range_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function window_x_Callback(hObject, eventdata, handles)
% hObject    handle to window_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of window_x as text
%        str2double(get(hObject,'String')) returns contents of window_x as a double


% --- Executes during object creation, after setting all properties.
function window_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to window_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function window_y_Callback(hObject, eventdata, handles)
% hObject    handle to window_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of window_y as text
%        str2double(get(hObject,'String')) returns contents of window_y as a double


% --- Executes during object creation, after setting all properties.
function window_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to window_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
