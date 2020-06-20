function M = camMatrix(rot, trans, fov, w, h)
% compute camera matrix from camera parameters

    % change of world base to camera base
    % extrinsic
    T = [eye(3) -trans; 0 0 0 1];
    R = [rot [0; 0; 0]; 0 0 0 1];
    
    
    % Projection
    f = (w/2)/tan(fov/2); % brennweite
    P = [f 0 0 0;
         0 f 0 0;
         0 0 1 0;
         0 0 0 1];
       
    % Transformation for image plane
    % intrinsix
    I = [1 0 w/2 0;
         0 1 h/2 0;
         0 0  1  0];
    
    M = I*P*R*T;
end
