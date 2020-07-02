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

% Last Modified by GUIDE v2.5 10-Jun-2014 20:59:21

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

global im_left;
global im_right;

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


function [gm s ofm w a i] = getConfig(handles)
    
    w = str2num(get(handles.option_samplerate,'String'));
    a = str2num(get(handles.option_alpha,'String'));
    i = str2num(get(handles.option_iter,'String'));
    s = 0;
    if get(handles.is_smooth,'Value') == 1
        s = str2num(get(handles.option_smooth,'String'));
    end;
    
    ofm = 'LK';
    if get(handles.OF_HS,'Value') == 1
        ofm = 'HS';
    end
    
    gm = 'DM';
	if get(handles.HS,'Value') == 1
        gm = 'HS';
    elseif get(handles.BA,'Value') == 1
        gm = 'BA';
    elseif get(handles.MA,'Value') == 1
        gm = 'MA';
    elseif get(handles.DM,'Value') == 1
        gm = 'DM';
    end
    


% --- Executes on button press in pushbutton_load.
function pushbutton_load_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_left;
global im_right;

image_file_name_left=get(handles.filename_left,'String');
image_file_name_right=get(handles.filename_right,'String');
if ~isempty(image_file_name_left) && ~isempty(image_file_name_right)
    im_left = imread(char(image_file_name_left));
    im_right = imread(char(image_file_name_right));
    
    % convert to grayscale
    if (size(im_left,3) > 2)
        im_left = rgb2gray(im_left); 
    end

    if (size(im_right,3) > 2)
        im_right = rgb2gray(im_right);
    end
    
    % convert to double
    im_left = double(im_left);
    im_right = double(im_right);

    axes(handles.image_2);    
    imshow(uint8(im_right));
    axis off;
    axes(handles.image_1);    
    imshow(uint8(im_left));
    axis off;
    set(handles.messages,'String','Images successfully loaded. Press Compute Gradients or Compute Flow.');
    set(handles.pushbutton_flow,'Enable','on');
    set(handles.pushbutton_grad,'Enable','on');
end 


function im = smoothImage(img,sigma)
    fs = ceil(5*sigma)+1; %for 99% 
    if mod(fs,2) == 0
        fs = fs+1;
    end
  
    %filter kernel
    fk = fspecial('gaussian',fs,sigma);
    % apply kernel
    im = imfilter(img, fk, 'replicate');

% --- Executes on button press in pushbutton_grad.
function pushbutton_grad_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_grad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_left;
global im_right;

% copy images
im1 = im_left;
im2 = im_right;

% get config
[gm s] = getConfig(handles);

% smoothing
if s ~= 0
  im1 = smoothImage(im1,s);
  im2 = smoothImage(im2,s); 
end

% compute gradients
[Dx, Dy, Dt] = computeGradients(im1,im2,gm);
axes(handles.image_1);    
imshow(Dx);
axis off;
axes(handles.image_2);    
imshow(Dy);
axis off;
axes(handles.image_3);    
imshow(Dt);
axis off;
set(handles.messages,'String','Computed Gradients: Dx, Dy, Dt');


% --- Executes on button press in pushbutton_flow.
function pushbutton_flow_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_flow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_left;
global im_right;

% copy images
im1 = im_left;
im2 = im_right;

%get config
[gm s ofm w a i] = getConfig(handles);

% smoothing
if s ~= 0
  im1 = smoothImage(im1,s);
  im2 = smoothImage(im2,s); 
end

axes(handles.image_2);    
imshow(uint8(im1));
axis off;
axes(handles.image_1);    
imshow(uint8(im2));
axis off;

% compute gradients
[Dx, Dy, Dt] = computeGradients(im1,im2,gm);

%compute flow
if ofm == 'LK'
    V = computeLKFlow(Dx,Dy,Dt,w);
else
    V = computeHSFlow(Dx,Dy,Dt,w,a,i);
end

plotFlow(handles.image_3,im1,w,V);

set(handles.messages,'String','Computed Optical Flow');

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


function option_samplerate_Callback(hObject, eventdata, handles)
% hObject    handle to option_samplerate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of option_samplerate as text
%        str2double(get(hObject,'String')) returns contents of option_samplerate as a double


% --- Executes during object creation, after setting all properties.
function option_samplerate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to option_samplerate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function option_alpha_Callback(hObject, eventdata, handles)
% hObject    handle to option_alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of option_alpha as text
%        str2double(get(hObject,'String')) returns contents of option_alpha as a double


% --- Executes during object creation, after setting all properties.
function option_alpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to option_alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function option_iter_Callback(hObject, eventdata, handles)
% hObject    handle to option_iter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of option_iter as text
%        str2double(get(hObject,'String')) returns contents of option_iter as a double


% --- Executes during object creation, after setting all properties.
function option_iter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to option_iter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over OF_HS.
function OF_HS_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to OF_HS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton_grad.
function pushbutton_grad_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_grad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton_flow.
function pushbutton_flow_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_flow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over OF_LK.
function OF_LK_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to OF_LK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in is_smooth.
function is_smooth_Callback(hObject, eventdata, handles)
% hObject    handle to is_smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of is_smooth
if get(handles.is_smooth,'Value') == 1
    set(handles.option_smooth,'Enable','on');
else
    set(handles.option_smooth,'Enable','off');
end


function option_smooth_Callback(hObject, eventdata, handles)
% hObject    handle to option_smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of option_smooth as text
%        str2double(get(hObject,'String')) returns contents of option_smooth as a double


% --- Executes during object creation, after setting all properties.
function option_smooth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to option_smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in fmethod.
function fmethod_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in fmethod 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

 if get(handles.OF_LK,'Value') == 1
    set(handles.label_alpha,'Visible','off');
    set(handles.option_alpha,'Visible','off');
    set(handles.label_iter,'Visible','off');
    set(handles.option_iter,'Visible','off')
 else
    set(handles.label_alpha,'Visible','on');
    set(handles.option_alpha,'Visible','on');
    set(handles.label_iter,'Visible','on');
    set(handles.option_iter,'Visible','on');
 end
