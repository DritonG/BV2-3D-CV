function [R T ox oy fx fy] = camParams(M,p3D)
% compute camera parameter from camera matrix

% vorzeichen sigma
p = M*p3D;

if(p(3)<0)
    sigma = -1;
else
    sigma = 1;
end


q1 = [M(1,1);M(1,2);M(1,3)];
q2 = [M(2,1);M(2,2);M(2,3)];
q3 = [M(3,1);M(3,2);M(3,3)];
%q4 = [M(1,4);M(2,4);M(3,4)];

% mittelpunkte ox und oy
ox = q1.'*q3;
oy = q2.'*q3;

fx = sqrt(q1.'*q1-ox^2);
fy = sqrt(q2.'*q2-oy^2);

% rot mat
r1 = sigma*(M(1,:)-ox.*M(3,:))./fx;
r2 = sigma*(M(2,:)-oy.*M(3,:))./fy;
r3 = sigma*M(3,:);

R = [r1(1:3);r2(1:3);r3(1:3)];

% trans mat
tz = sigma*M(3,4);
tx = sigma*(M(1,4)-ox*tz)/fx;
ty = sigma*(M(2,4)-oy*tz)/fy;

T = [tx;ty;tz];

% R orthonormalisieren
[U,S,V] = svd(R);
R = U*V; % abchecken ob V^t raus kommt

% T ohne rotation, T = -R*T', ges: T'
T = (-1.*(R.'))*T;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%% NOTES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% aus M erhalten wir T, siehe Hinweis auf blatt, wie man an T' kommt, 

% camParams bekommt satz oder einen punkt und M, ges rot trans, brennweite,
% pos mittelpunkt, instrinsic und extrinsic cam params bestimmen, folien
% s.30 , aus qs aus M wir in folien 31ff, fx und fy wie s32 ach aus qs und
% mittelpunkten, rot und T auch wie auf folien beschrieben bestimmen, i ist
% index f�r jeweiliges m, dann haben wir T, sigma berechnen mit beliebigem
% punkt der �bergeben wird (vorzeichen bestimmen), dann vektor, enth�lt w',
% dann aus w' vorzeichen ablesen und noch auf T und rot anwenden

% wenn rot bestimmt, dann noch mit svd orthonormalisieren, folie 17, svd
% auf r anwenden

% dann T' aus T ausrechen und T' zur�ckgeben (siehe hinweis)
% t ist rot und trans gemischt und wir brauchen aber nur tran was t'
% entspricht

% zusatzfragen beantworten: ssd als fehlerfunktion nutzen90


% zu c:
% foto von w�rfel auf kariertem paier, gr��e ablesen mit geodreichen, dann
% dareingeben und man bekommt cam params raus
% siehe bsp, vermessung w�rfel, mit gimp zb bildkoordinaten rausbekommen,
% 2d und 3d koordinaten assoziieren?, dann w�rfel projezieren
