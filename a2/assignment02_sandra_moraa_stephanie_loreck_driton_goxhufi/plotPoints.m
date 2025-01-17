function plotPoints(points, projPoints, edges, w, h)
% draw figure by projected points
% points - project points with depth information
% edges - edge list of connected points, e.g. [1 2; 2 3; ...]
% w, h - width and height of projection plane
    
% Place your code here...
% load the original image
myimg = imread('cam.jpg');

figure('Position', [0 0 w h]);
title('plot-for-ass02');
axis([0 w 0 h]);
imshow(myimg);
box on;
hold on;

for a=1:length(points)
    if points(3,a) > 0
        plot(points(1,a), points(2,a), '*', 'HandleVisibility','off');
    end
end
for a=1:length(edges)
    if points(3, edges(a,1)) > 0 || points(3, edges(a,2)) > 0
        if a ==1
            line([points(1, edges(a,1)) points(1, edges(a,2))],[points(2, edges(a,1)) points(2, edges(a,2))], 'Color', 'green', 'LineWidth', 3, 'DisplayName','Messung');
        else
            line([points(1, edges(a,1)) points(1, edges(a,2))],[points(2, edges(a,1)) points(2, edges(a,2))], 'Color', 'green', 'LineWidth', 3, 'HandleVisibility','off');
        end
    end
end
hold on;


for a=1:length(projPoints)
    if projPoints(3,a) > 0
        plot(projPoints(1,a), projPoints(2,a), '*', 'HandleVisibility','off');
    end
end
for a=1:length(edges)
    if projPoints(3, edges(a,1)) > 0 || projPoints(3, edges(a,2)) > 0
        if a == 1
            line([projPoints(1, edges(a,1)) projPoints(1, edges(a,2))],[projPoints(2, edges(a,1)) projPoints(2, edges(a,2))], 'Color', 'blue','LineWidth', 3, 'DisplayName','projektion');
        else
            line([projPoints(1, edges(a,1)) projPoints(1, edges(a,2))],[projPoints(2, edges(a,1)) projPoints(2, edges(a,2))], 'Color', 'blue','LineWidth', 3, 'HandleVisibility','off');
        end
    end 
end
hold off;
legend;
end

