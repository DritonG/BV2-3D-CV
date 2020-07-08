function V = computeLKFlow(Dx,Dy,Dt,w)
% compute optical flow (lucas kanade)
% input: 
%   Dx,Dy,Dt - derivations of images
%   w - window size (if w = 0, vector of whole image is computed)
% output:
%   V - vector for every sample in image with reliability:
%   [u1 v1 r1; ...; un vn rn]


if w == 0
    V = flowVector(Dx(:),Dy(:),Dt(:));
else
    DxC = im2col(Dx,[w w],'distinct');
    DyC = im2col(Dy,[w w],'distinct');
    DtC = im2col(Dt,[w w],'distinct');
    cols = size(DxC,2);
    V = zeros(cols,3);
    for i=1:cols
        V(i,:) = flowVector(DxC(:,i),DyC(:,i),DtC(:,i));
    end
%    fv = @flowVector;
%    parfor i=1:cols
%        V(i,:) = fv(DxC(:,i),DyC(:,i),DtC(:,i));
%    end
end

function v = flowVector(dx,dy,dt)
    v = [0 0 0];
	
    % place your code here
    % v = [A'W^2A]^-1 A'W^2b
	A = [dx;dy]';
    b = [dt]';
    mat1 = A'.*A;
    mat2 = A'.*b;
    print(mat1);
    print(mat2);
end

end


%%%%%%%%%%%%%%%%%%%NOTES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% b ist seitlicher gradient, einer der gradienten
% A setzt sich aus 2 gradienten zusammen
% noch checks: auf det von A'A checken und dann noch auf eigenwerte schauen
% wie groß
% und gegebenenfalls unterschiedlich behandeln

% zu fragen der eigenwerte:
% wikipedia aperture problem, motion perception
