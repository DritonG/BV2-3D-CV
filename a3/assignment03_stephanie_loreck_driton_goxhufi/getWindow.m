% Get subimage of image (img) by center (x,y) and size (wx - width, wy - height)
% If center is at the image border (e.g. 1,1), the missing information is
% padded with 0, so the subimage (w) has always the size of (wx,wy)
function w = getWindow(img,x,y,wx,wy)
    img_s = size(img);
    img_w = img_s(2);
    img_h = img_s(1);
        
    wy2 = floor(wy/2);
    wx2 = floor(wx/2);
    
    w = zeros(wy,wx,size(img,3));

    % get avalable image ranges for subimage
    ys = y-wy2;
    wys = 1;
    if ys <= 0
        wys = -ys + 2;
        ys = 1;
    end
    
    ye = y+wy2-1+mod(wy,2);
    wye = wy;
    if ye > img_h
        wye = wy - (ye - img_h);
        ye = img_h;
    end
    
    xs = x-wx2;
    wxs = 1;
    if xs <= 0
        wxs = -xs + 2;
        xs = 1;
    end
    
    xe = x+wx2-1+mod(wx,2);
    wxe = wx;
    if xe > img_w
        wxe = wx - (xe - img_w);
        xe = img_w;
    end
    
    % copy available image information to window
    w(wys:wye,wxs:wxe,:) = img(ys:ye,xs:xe,:);

end