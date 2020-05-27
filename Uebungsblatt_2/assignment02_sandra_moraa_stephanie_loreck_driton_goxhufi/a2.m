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

Tsol = camParamsSol(M_new, box(:,1));

% fehler zwischen mit geschaetzten und wirklichen caramParams bestimmen mit ssd
Rdif = R - R_new;
Tdif = T - T_new;

ssd_Rpoints = sum(Rdif.^2);
ssd_R = sum(Rdif(:).^2);
ssd_T = sum(Tdif.^2);

% Wie wirken sich Ungenauigkeiten in der Messung der 2D-Koordinaten (durch zufällige Verschiebungen)
% auf die Genauigkeit der geschätzten Parameter aus? Was passiert wenn nur eine 2D-Koordinate
% sehr stark abweicht (z.B. SSD nutzen)?

% (Teil 1:) Durch SSD haben kleine Ungenauigkeiten (Verschiebungen) nur kleine 
% Auswirkungen, da die Differenz (bspw. 0.5) quadriert wird und somit die 
% Ungenauigkeit nur ein kleiner Faktor auch in der Summe ist.
% (Teil 2:) Weist jedoch eine einzelne 2D-Koordinate sehr starke Abweichungen 
% auf, wird durch die Quadierung der Differenz auch eine sehr starke
% Ungenauigkeit in die Summe addiert. --> starke Auswirkung

%% c) Compute parameters of your camera

% 1. Define 3d point list
% 2. Define edge list
% 3. Define 2d point list
% 4. Compute camera parameters
% 5. Project 3d Points with M, plot 2d points and compute error
% -----------------------

myimg = imread('cam.jpg'); % gegebenes bild
%myimg = imread('gegenstand.jpg'); %13,5 x 16 x 8,2

% width and height, dim of image plane
myw=4352;
myh=2448;

% x=breite,y=länge,z=höhe
scale = [9.3,9.1,6.3]; % gegebenes bild
% da normalbox kantenlänge von 2 hat scale halbieren
scale=0.5.*scale;
%scale = [8.2,16.0,13.5]; % gegenstand

%1. Define 3d point list
% normalbox = [
%     -1     1     1    -1    -1     1     1    -1;
%     -1    -1     1     1    -1    -1     1     1;
%     -1    -1    -1    -1     1     1     1     1;
%      1     1     1     1     1     1     1     1
%     ];

% nur sichtbare punkte (dritter punkt entfernt), kantenlänge von 2
normalbox = [
    -1     1    -1    -1     1     1    -1;
    -1    -1     1    -1    -1     1     1;
    -1    -1    -1     1     1     1     1;
     1     1     1     1     1     1     1
    ];

% scale und trans matrix
ScaleMat = [
    scale(1)     0     0    0;
    0     scale(2)     0    0;
    0     0     scale(3)    0;
    0     0     0    1
    ];

TranslateMat = [
    1     0     0    1;
    0     1     0    1;
    0     0     1    1;
    0     0     0    1
    ];

mybox3d=zeros(size(normalbox));

for col=1:size(normalbox,2)
    mybox3d(:,col) = TranslateMat * normalbox(:,col);
    mybox3d(:,col) = ScaleMat * mybox3d(:,col);
end

%mybox3d(4,:)=[1     1     1     1     1     1     1];


% 2. Define edge list
% Edges of Box, alle kanten mit verbindung zu punkt 3 entfernen
myedges = [1 2; 4 1;...
         5 6; 6 7; 7 8; 8 5;...
         1 5; 2 6; 4 8];
     
% 3. Define 2d point list
% 2d - Bildkoordinaten: (x,y)
% 1925x1926|1888x1394(ursprung "0"), 3025x1518|3209x949 (x=9.3),
% 1556x1058|1483x491 (y = 9.1), 2570x242(diag von 0)

% nur sichtbare punkte (dritter punkt entfernt)
mybox2d = [
    1925     3025    1556    1888    3209     2570    1483;
    1926     1518    1058    1394     949      242     491;
    1     1     1     1     1     1     1
    ];

%2dpl = [170.096189432334,429.903810567666,429.903810567666,170.096189432334,213.397459621556,386.602540378444,386.602540378444,213.397459621556;170.096189432334,170.096189432334,429.903810567666,429.903810567666,213.397459621556,213.397459621556,386.602540378444,386.602540378444]
%mybox2d = projectPoints(mybox3d,M);

% 4. Compute camera parameters
M_mybox = matrixFromPoints(mybox3d,mybox2d);
[R_mybox T_mybox ox_mybox oy_mybox fx_mybox fy_mybox] = camParams(M_mybox,mybox3d);

% 5. Project 3d Points with M, plot 2d points and compute error
mybox2d_proj = projectPoints(mybox3d,M_mybox);

mybox2d_proj3 = cat(1,mybox2d_proj,[1     1     1     1     1     1     1]);

%error
MyPointdif = mybox2d - mybox2d_proj3;
myssd_points = sum(MyPointdif.^2);
myssd = sum(MyPointdif(:).^2);

%plot
figure();
subplot(1,3,1);
imshow(myimg);
title('My Image');
subplot(1,3,2);
plotPoints(mybox2d, myedges, myw, myh);
title('Box');
%subplot(1,3,3);
%plotPoints(mybox2d_proj3, myedges, myw, myh);
%title('Projected Box');




