function disparity = computeLR(img1,img2,wx,wy,range)
% compute disparity map
% img1,img2: rectified images for disparity
% wx,wy: windows size (wx,wy)
% range: search range for correlation
% return disparty map with lr check marker (blue dots)
    s=size(img1);
    disparity = uint8(zeros(s(1),s(2)));
    
    dispimg1 = computeDisparity(img1,img2,wx,wy,range);
    dispimg2 = computeDisparity(img2,img1,wx,wy,range);
    
    for y=1:s(1) % rows
        for x=1:s(2) % cols
            disp1=dispimg1(y,x);
            disp2=dispimg2(y,x-disp1);
                        
            if(disp1==disp2)
                disparity=dispimg1(y,x);
            else
                disparity=-1;
            end
            
        end
    end
    
    
    % ausgabe mit blauen linien, vorher wert disp bei falschen muss -1 sein
    disparity = disparity/max(disparity(:));
    idx = find(disparity < 0);
    tmp = disparity;
    disparity(idx) = 0;
    tmp(idx) = 1;
    disparity(:,:,2) = disparity;
    disparity(:,:,3) = tmp;
    disparity = uint8(disparity*255);

end

% dipsarity map von beiden bildern berechnen
% compute diparity mit bildern vertauscht 2 mal aufrufen
% dann falsche korrespondenzen unterdrücken, ins linke bild gehen, disp
% wert anschauen, ohne faktor vorher, über alle pixel laufen und für jeden
% pixel die disp größe anschauen, dann im rechten bild an den
% korrspondieren pixel springen aber nicht an exakt gleiche kordinate
% sondern an x wert-aktuellen disp wert gehen und dort disp wert im rechten
% bild anschauen,die disp werte müssen gleich sein, sonst klappt das
% springen nicht

% für alle px, linkes bild disps, dann x-disp für das pixel machen und an das x im
% rechten bild gehen und schauen ob der gleiche disp wert dort steht
% wenn es das gleiche ist ist es gut, wenn nicht, falsche werte blau
% markieren, filter mit blauen punkten an den stellen, wenns nicht passt
% wert auf -1 setzen, das wird von matlab dann als blau ausgegeben

% ausgabe disparity wird /255 geteilt und 
%dann wird geschaut obs werte gibt die kleiner sind als 0???