function points = projectPoints(hpoints, M)
% project points with M
   
    % projection
    hpoints = M*hpoints;
    
    % normalization of homogeneous coords
    points(1,:) = hpoints(1,:)./hpoints(3,:);
    points(2,:) = hpoints(2,:)./hpoints(3,:);
    
end