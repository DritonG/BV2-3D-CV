function [im,nx,ny,min_corr,max_corr]=responseImageRect(img1,img2,x,y,wx,wy,range)
% compute correlation between subimage of image 1 and image 2 of a single 
%   row, since the images are rectified -> translation only in x
% x,y: gives the center of the subimage to find correlation for
% wx,wy: defines subimage size 
% range: range to search for best correlation 
% return
%   im: is the response image
%   nx,ny: defines the point in image 2 with the best correlation with x, y
%   min_corr,max_corr: defines the min/max value of the correlations

    % init with default
    [sy,sx,sz] = size(img1);
    max_corr = 0;
    min_corr = 999999999999999999999999999999999999;
    ny = y;
    nx = 0;
    %im = uint8(zeros([sy,sx,sz]));   
    cmin_corr = [];
    cmax_corr = [];
    index=[];
    cim=[];
    
    for ch=1:sz
        wimg1 = getWindow(img1(:,:,ch),x,y,wx,wy);
        [cnx,ccorr]=correlation(wimg1,img2(:,:,ch),x,ny,range);
            
        cmin_corr = [cmin_corr,ccorr(cnx)];
        cmax_corr = [cmax_corr,max(ccorr)];
        if(cnx<range)
            idx = x - (cnx-1);
        else 
            idx = x + ((cnx-1) - range);
        end
        
        index=[index,idx];
        %cim[1,:,sz=[cim, ccorr];  
        cim(1,:,ch)=ccorr;
    end    
    
    %im=mean(cim,1);
    
    min_corr=min(cmin_corr);
    max_corr=max(cmax_corr);
    
    i = find(cmin_corr==min_corr);
    if(size(i,2)>1)
        i=i(1);
    end
    nx = index(i);
    im = mat2gray(cim, [max_corr, min_corr]);
end

% bild ist nicht in der höhe verschoben 
% man kann in der selben bild zeile suchen im bereich vom search range
% (nach links und nach rechts, doppelter search range insgesamt) und dann 
% besten pixel zurückgeben
% nur für eine zeile