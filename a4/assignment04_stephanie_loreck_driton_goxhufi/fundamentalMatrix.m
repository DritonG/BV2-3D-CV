function F = fundamentalMatrix(correspondences)
% FUNDAMENTALMATRIX uses the correspondences between two images (as 2d
% point lists) to compute the fundamental matrix F (min. 8 corr. required)
% correspondences -> matrix with 
%   pl - point list of left image
%   pr - point list of right image
% F - computed fundamental matrix

    F = 0;
    num_corr = size(correspondences,1);
    pl = correspondences(:,1:2);
    pr = correspondences(:,3:4);
    
    % place your code here
end