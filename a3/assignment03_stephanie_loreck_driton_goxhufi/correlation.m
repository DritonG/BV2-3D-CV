function [nx, corr] = correlation(wimg1,img2,x,y,range)
% compute correlation for one line
% wimg1: window or subimage to find correlation within img2
% x,y: defines at which point in img2 we are searching for the
%   best correlation within wimg1
% range: gives the range to search for the correlation in row y. If 
% range > image width, range is trimmed to image width
% return
%   nx: returns the new column index of the best correlation of wimg1 
%       within img2 at line y in the given range at x (x-+range)
%   corr: correlation vector

    % nur ein channel sollte übergegben werden
    nx = 0;
    startsearch=0;
    endsearch=0;
    index = [];
    corr = [];
    
    [wx,wy]=size(wimg1);
    
    % set range if to big
    if(range>(size(img2,2)/2))
        startsearch = 1;
        endsearch = size(img2,2);
    elseif(x<range)
        startsearch=1;
        endsearch=x+range;
    elseif(x>range)
        startsearch=x-range;
        endsearch=size(img2,2);  
    else
        startsearch=x-range;
        endsearch=x+range;
    end
    
    % wenn x nicht in der mitte ist das ein problem
    %-1 vors erste?
    for col = startsearch:endsearch
        wimg2 = getWindow(img2,y,col,wy,wx);
        
        % ssd
        dif = wimg1-wimg2;
        ssd = sum(dif(:).^2);
        
        index = [index,col];
        corr = [corr,ssd];
    end
    
    min_corr = min(corr);
    i = find(corr==min_corr);
    
    nx = index(i);
    
end

% man darf die funktion getWindow benutzen
% vorsicht, weil bild bei getWindow mit nullen gepadded wird, aber ist ok
% ssd berechnen, quadrieren ist unnötig, diff am geringsten, min
% bei rgb für alle 3 channels machen, funktion soll nur nicht abstürzen,
% sonst rand egal
% grayscale option implementieren
% wsl dif doch quadrieren

% wenn range ganz groß, range ist bildbreite
