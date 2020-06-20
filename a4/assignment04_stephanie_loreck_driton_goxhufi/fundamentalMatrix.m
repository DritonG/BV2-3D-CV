function F = fundamentalMatrix(correspondences)
% FUNDAMENTALMATRIX uses the correspondences between two images (as 2d
% point lists) to compute the fundamental matrix F (min. 8 corr. required)
% correspondences -> matrix with 
%   pl - point list of left image
%   pr - point list of right image
% F - computed fundamental matrix

    F = 0;
    num_corr = size(correspondences,1);
    pl = correspondences(:,1:2);
    pr = correspondences(:,3:4);
    
    % place your code here
end


% HL=   [1/dl     0       -ml(1)/dl; *dl = durchschnittliche länge
%         0      1/dl     -ml(2)/dl; *ml = mittelinks
%         0       0              1];

% HR=   [1/dr     0       -mr(1)/dr;
%         0      1/dr     -mr(2)/dr;
%         0       0              1];

%koords (x,y) mit einem wert erweitern("z") damit die multiplikation mit HR
%HL multiplizierbar ist.

% A=UDVT: 9 Spalten -"homogenes lineares gleichungssystem"- <-- SVD
% (V-rausnehmen = FN) <-- orthogonalized, value 3x3 = 0.            |&FN= F'
%
% Ist A=UDVT die n x 9 - Matrix des Gleichungssystems,
% so sind die Koeffizienten von F die Einträge der
% Zeile von VT, die zum SingularValue 0 (bzw. zum
% kleinsten SV) gehört.
% F hat normalerweise wg. numerischer Probleme noch
% nicht Rang 2; dies wird wiederum mit Hilfe der SVD
% erreicht (analog zur Orthogonalisierung von R, s. o.)
%
% 2 x SVD berechnung,
%
% Spalten:
% 1 x Value
% 2 yl*xr value
% 3
% 4
% 5 yl*yr
% 6 y value
% xl value
% yl value
% 9 = 1
