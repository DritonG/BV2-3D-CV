function err = distance(F,correspondences)
%DISTANCE Compute distance to corresponding epipolar line
% F - fundamental matrix
% correspondences - corresponding points between left and right image
    err = 0;
    num_corr = size(correspondences,1);
    
    % linke punkte
    pl = correspondences(:,1:2);
    pl=cat(2,pl,ones(size(pl,1),1));
    
    % rechte punkte
    pr = correspondences(:,3:4);
    pr=cat(2,pr,ones(size(pr,1),1));
    
    % get a b c from line equation for each left point, a*x + b*y + c = 0 -> Vector of [a b c]
    % distance point to line eqaution: d=abs(a*x+b*y+c)/sqrt(a^2+b^2)
    % d=abs(vec(1).*x+vec(3).*y+vec(3))./sqrt(vec(1)^2+vec(2)^2);
    vec=zeros(num_corr,3);
    d=zeros(num_corr,1); 
    
    for i=1:num_corr
        % a b c from left point
        vec(i,:)=F*pl(i,:)';
        
        % distance to right point
        d(i)=abs(vec(i,1)*pr(i,1)+vec(i,2)*pr(i,2)+vec(i,3))/sqrt(vec(i,1)^2+vec(i,2)^2);
    end
    
    % avg distance
    err=mean(d);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%NOTES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% g�te von F

% durchschnittlichen abstand ausrechnen

% aus correspondences die linken punkte (homogenisiert) rausnehmen und mal
% F machen --> liniengleichung, und dann rechten punkt aus correspondances
% nehmen, die berechnete linie sollte durch den rechten punkt gehen,
% k�rzesten abstand zwischen linie und punkt berechnen (google),
% abst�nde f�r alle correspondances aufsummieren und dann noch durch anzahl
% der correspondences teilen

% gleichung nehmen und rechten punkt einsetzen und ein abs davor und dann
% durch durch irgendwelche quadrate teilen