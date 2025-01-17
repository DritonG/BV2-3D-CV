function M = matrixFromPoints(p3d, p2d)
% compute camera matrix from a set of related 3d and 2d points

% projektionsmatrix, grosse buchstaben sind 3d punkt, kleine 2d punkt
% 1 punkt ist in spalte gespeichert

cols = size(p3d,2);

A = zeros(cols*2,12);

% compute A
for col = 1:cols
    point3d = p3d(:,col);
    x = p2d(1,col);
    y = p2d(1,col);

    % x values
    A(col,:) = [point3d(1), point3d(2), point3d(3),1,0,0,0,0,...
        -1*x*point3d(1), -1*x*point3d(2), -1*x*point3d(3),-1*x];
    % y values
    A(col*2,:) = [0,0,0,0,point3d(1), point3d(2), point3d(3),1,...
        -1*y*point3d(1), -1*y*point3d(2), -1*y*point3d(3),-1*y];
end

% svd von A, 
[U,S,V] = svd(A);
% m ist letzte spalte von V, m ist spaltenvektor
m = V(:,end);

M = [m(1),m(2),m(3),m(4);
    m(5),m(6),m(7),m(8);
    m(9),m(10),m(11),m(12)];

q3 = [m(9);m(10);m(11)];

% skalierungsfaktor
gamma = abs(sqrt(q3.'*q3));

M = M./gamma;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%% NOTES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ssd sum of squared differences, summe �ber alle projectionen, abstand
% quadriert nehmen, parabelform dann, stare abst�nde sind st�rker
% dargesellt, man kann auch lineare abst�nde nehmen, fehlerwert nur
% irgendwie bestimmen,

% foliensatz vision3 nehmen, matrix A aufstellen wie es da steht (S.28 folien), svd
% anwenden mit matlab, svd funktion von matlab nehmen, auf matrix anwenden,
% folie 17, usv zur�ck, letzte spalte der v matrix nehmen um m zu bekommen,
% letzte spalte vom v ist m, folgende folien (30 und so), klein m was
% bestimmt ist sind schon werte von unserer projektionsmatrix, schauen
% welches klein m an welcher stelle in gro� m ist und dann M nur noch
% skalieren wie in folie 31 beschrieben, M teilen durch skalierungsfaktor
% (siehe folie), skalierungsfacktor mit q3 bestimmen, quadrierter betrag,
% dann wurzel ziehen, dann M dadurch teilen, dann fertige projektionsmatrix
