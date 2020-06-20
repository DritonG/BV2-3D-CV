%% Team:

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

% Place your code here...

matrixFromPointsSol(box,box2d);



%% b) Compute camera parameters from M

% 1. Implement camParams
% 2. Plot results and compare them to real camera parameters
% 3. Modify 2d coords and check effects to parameters

% Place your code here...

camParamsSol(M_new, box(:,1));



%% c) Compute parameters of your camera

% 1. Define 3d point list
% 2. Define edge list
% 3. Define 2d point list
% 4. Compute camera parameters
% 5. Project 3d Points with M, plot 2d points and compute error

% Place your code here...
