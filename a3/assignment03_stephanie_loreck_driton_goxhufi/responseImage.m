function [im,nx,ny,min_corr,max_corr]=responseImage(img1,img2,x,y,wx,wy)
% compute response image of correlation between subimage of image 1 and
%   image 2
% x,y: gives the center of the subimage to find correlation for
% wx,wy: defines subimage size
% return
%   im: is the response image
%   nx,ny: defines the point in image 2 with the best correlation with x,y
%   min_corr,max_corr: defines the min/max value of the correlations
    
    % init with default
    [sy,sx,sz] = size(img1);
    %disp("img1 shape: "+[sy,sx,sz])
    max_corr = 0;
    min_corr = 999999999999999999999999999999999999; % beste correlation, siehe gui range
    ny = 0;
    nx = 0;
    %%%% Erst am Ende im = uint8(zeros(s(1),s(2))); 
    cim = zeros([sy,sx,sz]); 
    
    for ch = 1:sz
        wimg1 = getWindow(img1(:,:,ch),x,y,wx,wy);
        %immer channel weise????
        cmin_corr = 0;
        cmax_corr = 0;
    
        for row = 1:sy
            [cnx,ccorr]=correlation(wimg1,img2(:,:,ch),x,row,sx);
            
            cmin_corr = ccorr(cnx);
            cmax_corr = max(ccorr);
            
            if(cmin_corr<min_corr)
                min_corr = cmin_corr;
                nx = cnx;
                ny = row;
            end
            
            if(cmax_corr>max_corr)
                max_corr = cmax_corr;
            end
            
            % hier noch ein fehler corr muss nicht immer glieche größe wie
            % bild haben, hier doch, da kein range angegeben wirs
            cim(row,:,ch)=ccorr;
            %cim=normalize(cim)*255;
            
        end
    end
    
    % hier stimmt was nicht
    % (Wert-min) / (max-min) 
    %im = uint8(zeros(s(1),s(2)));
    %cim = rgb2gray(cim);
    %im = uint8(zeros(s(1),s(2)));

    im = mat2gray(cim, [max_corr, min_corr]);
    %im = normalize(cim);
    
    
end

% gibt response Image aus, in grayscale, 0 ist weiß ist am besten
% man kann parfor für die schleifen nehmen, fürs ganze bild machen
