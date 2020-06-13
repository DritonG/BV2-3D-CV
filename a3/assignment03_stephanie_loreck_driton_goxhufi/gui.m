function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
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

% Last Modified by GUIDE v2.5 20-Jun-2013 15:51:36

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
% for parfor -> set number of threads to use
%if matlabpool('size') == 0 
%    matlabpool open 4;
%end

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



function file_left_Callback(hObject, eventdata, handles)
% hObject    handle to file_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of file_left as text
%        str2double(get(hObject,'String')) returns contents of file_left as a double


% --- Executes during object creation, after setting all properties.
function file_left_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file_left (see GCBO)
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
    
    handles = guidata(src); %load handles structure.
    clicked = get(handles.image_left,'currentpoint');
    xi = round(clicked(1,1,1));
    yi = round(clicked(1,2,1));
    
    is_rect = get(handles.is_rect,'value');
    is_grayscale = get(handles.is_grayscale,'value');

    wsx = str2num(get(handles.x_window_size,'String'));
    wsy = str2num(get(handles.y_window_size,'String'));
    range = str2num(get(handles.search_range,'String'));

    im_left_tmp = markImage(im_left,xi,yi,wsx,wsy,[255,0,0]);
    set(handles.text_left,'String',sprintf('Selected point: (%d,%d)', xi,yi));

    axes(handles.image_left);    
    im_handle = imshow(im_left_tmp);
    set(im_handle, 'ButtonDownFcn', @click); 
    axis off;
    
    if numel(im_right) > 1
        if is_rect
            if size(im_right) == size(im_left)
                if (is_grayscale)
                    [im_corr,nx,ny,min_corr,max_corr] = responseImageRect(rgb2gray(im_left),rgb2gray(im_right),xi,yi,wsx,wsy,range);
                else
                    [im_corr,nx,ny,min_corr,max_corr] = responseImageRect(im_left,im_right,xi,yi,wsx,wsy,range);
                end
            else
                set(handles.text_right,'String',sprintf('Abort: No rectified images!'));
                return;
            end
        else
            if (is_grayscale)
                [im_corr,nx,ny,min_corr,max_corr] = responseImage(rgb2gray(im_left),rgb2gray(im_right),xi,yi,wsx,wsy);
            else
                [im_corr,nx,ny,min_corr,max_corr] = responseImage(im_left,im_right,xi,yi,wsx,wsy);
            end
        end
        
        im_right_tmp = markImage(im_right,nx,ny,wsx,wsy,[255,0,0]);
        set(handles.text_right,'String',sprintf('Best correlation: (%d,%d) - Range: (%d,%d)',nx,ny,min_corr,max_corr));
        axes(handles.image_right);    
        imshow(im_right_tmp);
        axis off;

        axes(handles.image_corr);
        set(handles.text_corr,'String','Correlation Map');
        imshow(im_corr);
        axis off;
    end

function im=markImage(image,x,y,wx,wy,color)
    im=image;
    img_w = size(im);
    img_h = img_w(1);
    img_w = img_w(2);
    
    w=uint32(1);
    
    ys = y-w;
    if ys <= 0
        ys = 1;
    end
    ye = y+w;
    if ye > img_h
        ye = img_h;
    end
    xs = x-w;
    if xs <= 0
        xs = 1;
    end
    xe = x+w;
    if xe > img_w
        xe = img_w;
    end
    
    im(ys:ye,xs:xe,1) = color(1);
    im(ys:ye,xs:xe,2) = color(2);
    im(ys:ye,xs:xe,3) = color(3);
    
    wx2 = floor(wx/2);
    wy2 = floor(wy/2);
    
    if (wx > 2)
        xs = x-wx2;
        if xs <= 0
            xs = 1;
        end
        xe = x+wx2;
        if xe > img_w
            xe = img_w;
        end
        
        if y-wy2 > 0
            im(y-wy2,xs:xe,:) = color(1);
            im(y-wy2,xs:xe,2) = color(2);
            im(y-wy2,xs:xe,3) = color(3);
        end
        
        if y+wy2 <= img_h
            im(y+wy2,xs:xe,1) = color(1);
            im(y+wy2,xs:xe,2) = color(2);
            im(y+wy2,xs:xe,3) = color(3);
        end
    end
    
    if (wy > 2)
        ys = y-wy2;
        if ys <= 0
            ys = 1;
        end
        ye = y+wy2;
        if ye > img_h
            ye = img_h;
        end
        
        if x-wx2 > 0
            im(ys:ye,x-wx2,1) = color(1);
            im(ys:ye,x-wx2,2) = color(2);
            im(ys:ye,x-wx2,3) = color(3);
        end
        
        if x+wx2 <= img_w
            im(ys:ye,x+wx2,1) = color(1);
            im(ys:ye,x+wx2,2) = color(2);
            im(ys:ye,x+wx2,3) = color(3);
        end
    end    

% --- Executes on button press in open_left.
function open_left_Callback(hObject, eventdata, handles)
% hObject    handle to open_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_left;
global im_right;
[filename, path] = uigetfile({'*.jpg;*.png','Image File(*.jpg,*.png)';'*.jpg','JPG File';'*.png','PNG File'},'Select the right image file');
filename = fullfile(path, filename)
if ~isempty(filename)
    set(handles.file_left,'String',filename);
    im_left=imread(filename);
    axes(handles.image_left);    
    im_handle = imshow(im_left);
    set(im_handle, 'ButtonDownFcn', @click); 
    axis off;
else
    im_left = 0;
end
if numel(im_left) > 1 && numel(im_right)
    set(handles.disparity_button,'Enable','on');
    set(handles.lr_button,'Enable','on');
    set(handles.search_range,'Enable','on');
    set(handles.text_search_range,'Enable','on');
end


function file_right_Callback(hObject, eventdata, handles)
% hObject    handle to file_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of file_right as text
%        str2double(get(hObject,'String')) returns contents of file_right as a double


% --- Executes during object creation, after setting all properties.
function file_right_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in open_right.
function open_right_Callback(hObject, eventdata, handles)
% hObject    handle to open_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_left;
global im_right;
[filename, path] = uigetfile({'*.jpg;*.png','Image File(*.jpg,*.png)';'*.jpg','JPG File';'*.png','PNG File'},'Select the right image file');
filename = fullfile(path, filename)
if ~isempty(filename)
    set(handles.file_right,'String',filename);
    im_right=imread(filename);
    axes(handles.image_right);    
    imshow(im_right);
    axis off;
else
    im_right = 0;
end
if numel(im_left) > 1 && numel(im_right)
    set(handles.disparity_button,'Enable','on');
    set(handles.lr_button,'Enable','on');
    set(handles.search_range,'Enable','on');
    set(handles.text_search_range,'Enable','on');
end


function x_window_size_Callback(hObject, eventdata, handles)
% hObject    handle to x_window_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_window_size as text
%        str2double(get(hObject,'String')) returns contents of x_window_size as a double


% --- Executes during object creation, after setting all properties.
function x_window_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_window_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_window_size_Callback(hObject, eventdata, handles)
% hObject    handle to y_window_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_window_size as text
%        str2double(get(hObject,'String')) returns contents of y_window_size as a double


% --- Executes during object creation, after setting all properties.
function y_window_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_window_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in is_rect.
function is_rect_Callback(hObject, eventdata, handles)
% hObject    handle to is_rect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of is_rect


% --- Executes on button press in disparity_button.
function disparity_button_Callback(hObject, eventdata, handles)
% hObject    handle to disparity_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_left;
global im_right;
wsx = str2num(get(handles.x_window_size,'String'));
wsy = str2num(get(handles.y_window_size,'String'));

if size(im_right) == size(im_left)
    is_grayscale = get(handles.is_grayscale,'value');
    range = str2num(get(handles.search_range,'String'));
    if is_grayscale
        disp = computeDisparity(rgb2gray(im_left),rgb2gray(im_right),wsx,wsy,range);
    else
        disp = computeDisparity(im_left,im_right,wsx,wsy,range);
    end
    axes(handles.image_corr);
    set(handles.text_corr,'String','Disparity Map');
    imshow(disp);
    axis off;
else
    set(handles.text_right,'String',sprintf('Abort: No rectified images!'));
end




% --- Executes on button press in lr_button.
function lr_button_Callback(hObject, eventdata, handles)
% hObject    handle to lr_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_left;
global im_right;
wsx = str2num(get(handles.x_window_size,'String'));
wsy = str2num(get(handles.y_window_size,'String'));

if size(im_right) == size(im_left)
    is_grayscale = get(handles.is_grayscale,'value');
    range = str2num(get(handles.search_range,'String'));
    if is_grayscale
        disp = computeLR(rgb2gray(im_left),rgb2gray(im_right),wsx,wsy,range);
    else
        disp = computeLR(im_left,im_right,wsx,wsy,range);
    end
    axes(handles.image_corr);
    set(handles.text_corr,'String','LR Disparity Map');
    imshow(disp);
    axis off;
else
    set(handles.text_right,'String',sprintf('Abort: No rectified images!'));
end

% --- Executes on button press in is_grayscale.
function is_grayscale_Callback(hObject, eventdata, handles)
% hObject    handle to is_grayscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of is_grayscale



function search_range_Callback(hObject, eventdata, handles)
% hObject    handle to search_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of search_range as text
%        str2double(get(hObject,'String')) returns contents of search_range as a double


% --- Executes during object creation, after setting all properties.
function search_range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to search_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
