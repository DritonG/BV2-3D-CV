function plotFlow(fig,im,w,V)
%PLOTFLOW Summary of this function goes here
%   Detailed explanation goes here

% image size
[ih, iw] = size(im);
w2 = floor(w/2);

if ishandle(fig)
    axes(fig);    
    imshow(uint8(im));
    axis off;
else    
    figure(fig);
    title('Image with Optical Flow');
end
hold 'on';

if w == 0
    X = floor(iw/2);
    Y = floor(ih/2);
else
    [X,Y] = meshgrid(w2:w:iw+w2-1,w2:w:ih+w2-1);
    X = X(:);
    Y = Y(:);
end

if size(V,2) > 2
    fstep = 5;
    fend = 100 - fstep;
    for i=0:fstep:fend
        idx = find(V(:,3) >= i & V(:,3) < i+fstep);
        quiver(X(idx),Y(idx),V(idx,1),V(idx,2), 0, 'Color', [1-i/fend,i/fend,0], 'lineWidth', 1, 'Autoscale','off');
    end
else
    quiver(X,Y,V(:,1),V(:,2), 0, '-b', 'lineWidth', 1);
end

end

