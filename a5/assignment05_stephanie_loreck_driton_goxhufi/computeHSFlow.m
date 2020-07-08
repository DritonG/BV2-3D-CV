function V = computeHSFlow(Dx,Dy,Dt,w,alpha,iter)
% compute optical flow (horn schunck)
% input: 
%   Dx,Dy,Dt - derivations of images
%   w - window size for every sample (image gets downsampled)
%   alpha - smoothness term
%   iter - number of iterations.
% output:
%   V - vector for every sample in image:
%   [u1 v1; ...; un vn]0


if w == 0
    w = 1;
end

%downsample gardients
if (w > 1)
    scale = 1/w;
    Dx = imresize(Dx,scale);
    Dy = imresize(Dy,scale);
    Dt = imresize(Dt,scale);
end

% initial value for flow vectors
V = zeros(numel(Dx),2);

% place your code here
% laplacian kernel
lapK=[1/12, 1/6, 1/12;
    1/6, 0, 1/6;
    1/12, 1/6, 1/12]; 



%%%%%%%%%%%%%%%%%%%NOTES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% kernel aus kap 8 aufs bisher berechnetes anwenden, itertiv wie in kap12
% u und v am anfang 0 und dann
% ableitungen und die vom bisherigen u und v abziehen
% bei jeder iteration den kernel davor ueber u und v laufen lassen


%ZU D
% LK hat keine iteration, HS ist iterativ
% was ist der unterschied, was aendert sich ber unterschiedlichen
% iteration, in welchen bildbereichen, aperture problem
