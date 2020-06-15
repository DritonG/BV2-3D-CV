% fast way to compute correlation for one line
% wim1 - window or subimage to find correlation within image2
% x,y - defines at which point in image2 we are searching for the
% best correlation with wim1
% range_x, range_y - gives the +-range to search for the correlation at x,y. If 
% range > as image width/height, range is trimmed to image width/height
% ix, iy returns the image column and row index of the best correlation of 
% wim1 in image2 (within the given range)
% mn is the best correlation value
% cx cy are the index within corr of the min
% corr are all ssd values of the search window
function [ix iy mn cx cy corr] = correlation(image1,image2,x,y,wx,wy,range_x,range_y)
    % get window for image1
    wim1 = getWindow(image1,x,y,wx,wy);
    
    % get image size
    im_w = size(image2,2);
    im_h = size(image2,1);
    
    % get search window of image2
    wim2 = getWindow(image2,x,y,2*range_x+wx,2*range_y+wy);
    
    % trim window x start
    xs = x-range_x-1;
    if x-range_x <= 0
        wim2 = wim2(:,-(x-range_x)+2:end,:);
        xs = 0;
    end
    
    % trim window y start
    ys = y-range_y-1;
    if y-range_y <= 0
        wim2 = wim2(-(y-range_y)+2:end,:,:);
        ys = 0;
    end
    
    % trim window x end
    wim_w = size(wim2,2);
    if x+range_x > im_w
        wim2 = wim2(:,1:wim_w-(x+range_x-im_w),:);
    end
    wim_w = size(wim2,2)-wx+1;
    
    % trim window y end
    wim_h = size(wim2,1);
    if y+range_y > im_h
        wim2 = wim2(1:wim_h-(y+range_y-im_h),:,:);
    end
    wim_h = size(wim2,1)-wy+1;
    
    % slice big search window into small windows with same size as wim1 
    w2col = im2col(wim2(:,:,1),[wy,wx]);
    w2s = size(w2col,2);
    % create w2s copies of wim1 for fast vectorized computatuin of SSD 
    w1col = repmat(reshape(wim1(:,:,1),wx*wy,1),1,w2s);
    
    % condition for color images - just add the other color planes to the
    % cols for ssd
    for i = 2:size(image2,3)
        w2col = [w2col; im2col(wim2(:,:,i),[wy,wx])];
        w1col = [w1col; repmat(reshape(wim1(:,:,i),wx*wy,1),1,w2s);];
    end
    
    % compute SSD for all slices at once and reshape to search window size
    tmp = sum((w2col - w1col).^2);
    corr = reshape(tmp,wim_h,wim_w);
        
    % get index of min value to get best correlation
    [mn,idx] = min(corr(:));
    
    % convert index to coords within search window
    [cy,cx] = ind2sub([wim_h wim_w],idx);
    
    % convert window coords to image coords
    ix = cx+xs;
    if ix > im_w
        ix = im_w;
    end
    iy = cy+ys;
    if iy > im_h
        iy = im_h;
    end
end
