%% Team: Stephanie Loreck, Sandra Moraa, Driton Goxhufi

%% Initialization
clear; close all; clc

%% Known camera parameters
% field of view angle in rad (rad = deg*pi/180)
fov = 60/180*pi; 
% dim of image plane
w = 600;
h = 600;
% camera rotation
r_x = 0/180*pi;
r_y = 0/180*pi; 
r_z = 0/180*pi;
R = rotMatrix(r_x,r_y,r_z);
% camera translation
T = [0;0;-5];

%% 3D points of box
box = [
    -1     1     1    -1    -1     1     1    -1;
    -1    -1     1     1    -1    -1     1     1;
    -1    -1    -1    -1     1     1     1     1;
     1     1     1     1     1     1     1     1
    ];

%% Compute M from given camera parameters
M = camMatrix(R,T,fov,w,h);

%% Compute 2D points of box
box2d = projectPoints(box,M);

%% a) Compute M from 2d and 3d points and test M

% 1. Implement matrixFromPoints
% 2. Compute M
% 3. Test M

M_new = matrixFromPoints(box,box2d);
box2d_Mnew = projectPoints(box,M_new);

matrixFromPointsSol(box,box2d);

% fehler zwischen mit M_new geschaetzten und wirklichen 2d punkten bestimmen mit ssd
Pointdif = box2d - box2d_Mnew;
ssd_points = sum(Pointdif.^2);
ssd = sum(Pointdif(:).^2);


%% b) Compute camera parameters from M

% 1. Implement camParams
% 2. Plot results and compare them to real camera parameters
% 3. Modify 2d coords and check effects to parameters

[R_new, T_new, ox_new, oy_new, fx_new, fy_new] = camParams(M_new,box(:,1));

camParamsSol(M_new, box(:,1));

% fehler zwischen mit geschaetzten und wirklichen caramParams bestimmen mit ssd
Rdif = R - R_new;
Tdif = T - T_new;

ssd_Rpoints = sum(Rdif.^2);
ssd_R = sum(Rdif(:).^2);
ssd_T = sum(Tdif.^2);

% Wie wirken sich Ungenauigkeiten in der Messung der 2D-Koordinaten (durch zufällige Verschiebungen)
% auf die Genauigkeit der geschätzten Parameter aus? Was passiert wenn nur eine 2D-Koordinate
% sehr stark abweicht (z.B. SSD nutzen)?

% TODO: antwort

%% c) Compute parameters of your camera

% 1. Define 3d point list
% 2. Define edge list
% 3. Define 2d point list
% 4. Compute camera parameters
% 5. Project 3d Points with M, plot 2d points and compute error

% Place your code here...
