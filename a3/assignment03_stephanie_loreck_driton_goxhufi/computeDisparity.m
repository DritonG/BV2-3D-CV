function disparity = computeDisparity(img1,img2,wx,wy,range)
% compute disparity map
% img1,img2: rectified images for disparity
% wx,wy: windows size (wx,wy)
% range: search range for correlation
% return disparty map
    
    s = size(img1);
    disparity = uint8(zeros(s(1),s(2)));
    
    rows=s(1);
    cols=s(2);
    
    parfor y=1:rows
        for x=1:cols
            [im,nx,ny,min_corr,max_corr]=responseImageRect(img1,img2,x,y,wx,wy,range);
            cdisp=abs(x-nx); % verschiebung in spaltenrichtung
            disparity(y,x)=cdisp;
%             disp('next');
%             disp(x);
%             disp(y);
%             disp(cdisp);
        end
    end
    
    disparity = double(disparity)/double(max(disparity(:)));
    disparity = uint8(disparity*255);
    disparity = imcomplement(disparity);
    
end

% fürs linke bild
% tiefenbild in graustufen zurückgeben
% übers komplette bild laufen und für jedes pixel die funktion response img
% rect aufrufen weil man da die verschiebung in x richtung raus bekommt,
% dann den x wert in disparity speichern und dann das disparity zurückgeben
% das graustufen bild entspricht, verschiebeung im hintergrund ist kleiner
% als im vordergrund, 0 im graustufen bild ist schwarz

%sonst normalisieren
% evtl oder werte skaliernen? nein keinen faktor

% bei responseimgrect bekommt man nx raus und gibt x rein und ergebnis ist
% dann abs(x-nx)