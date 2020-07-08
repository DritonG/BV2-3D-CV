function [Dx, Dy, Dt] = computeGradients(im1, im2, method)
% compute spatial and temporl derivations
% im1 - image 1
% im2 - image 2
% method - HS, BA, MA and DM (default)

if nargin < 3
% possibilities for 'method' are:
%     method = 'HS';         %% Horn-Schunck original method
%     method = 'BA';         %% Barron derivation
%     method = 'MA';         %% Matlab Gradient
     method = 'DM';          %% difference masks (default)
end

Dx = zeros(size(im1));
Dy = Dx;
Dt = Dy;

if strcmpi(method,'HS')
    % Horn-Schunck original method
	
    kernelx=[1,-1;1,-1]./4;
    kernely=[1,1;-1,-1]./4;
    
    kernelt1=[-1,-1;-1,-1]./4; 
    kernelt2=[1,1;1,1]./4; 
    
    Dx1 = conv2(im1,kernelx,'same');
    Dx2 = conv2(im2,kernelx,'same');
    Dy1 = conv2(im1,kernely,'same');
    Dy2 = conv2(im2,kernely,'same');
    Dt1 = conv2(im1,kernelt1,'same');
    Dt2 = conv2(im2,kernelt2,'same');
    
    Dx=Dx1+Dx2;
    Dy=Dy1+Dy2;
    Dt = Dt1 + Dt2;
elseif strcmpi(method,'BA') 
    % Horn-Schunck with Barron modification
    
    kernelx=[-1,8,0,-8,1]./12; 
    kernely=kernelx';
    
	Dx = conv2(im1,kernelx,'same');
    Dy = conv2(im1,kernely,'same');
    
    Dt = im2 - im1;
    
elseif strcmpi(method,'MA')
    % Matlab gradient
    [Dx,Dy] = gradient(im1);
    Dt = im2 - im1;
elseif strcmpi(method,'DM')
    % Alternative:  simple finite difference masks.
    Dx = conv2(im1,[1 -1],'same');
    Dy = conv2(im1,[1; -1],'same');
    Dt = im2 - im1;
end

%%%%%%%%%%%%%%%%%%%NOTES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% paper anschauen
% conv2 nutzen mit same parameter
% HS filter ist 2*2 matrix aus fehlerfunktion im paper (kap.7)
% --> ein bild wird vom andern abgezogen, in 3 zeilen impl
% e durch d ersetzen
% linkes bild mit kernel falten und rechtes jeweils, kernel ist der
% gleiche, dann das voneinander abziehen und fertig
% unterschiedliche kernel fuer x und y

%fuer dt auch so machen

% vier werte ergeben einen wert, durch 4 normiert, mit conv +1 fuer pos und
% -1 fuer neg

%barne s.5
%nur das linke bild, in x richtung kernel bestimmen, und y richtung
%transponierten kernel nehmen 
% fuer t bild 1 von bild 2 abziehen (nur unterschied)
