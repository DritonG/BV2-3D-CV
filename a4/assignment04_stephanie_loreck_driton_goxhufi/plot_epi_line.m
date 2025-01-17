function l = plot_epi_line(F,point,width,color)
%LINE_EQ Compute line equation from F and point and plot line
% F - fundamental matrix
% point - point of correspondences
% width - width of image
% color - color for line as string: 'r' or 'b'...
% line - line equation a*x + b*y + c = 0 -> Vector of [a b c]

l = 0;

% point homogenisieren, punkt hat spalten
point=cat(2,point,[1]);

% get a b c from line equation, vec hat zeilen
vec=F*point';

% x und y vetoren mit start und endpunkt werten
x=[1, width];
y=[0, 0];

% get correct ys, vec(1)*x+vec(2)*y+vec(3)=0, y=-1*(vec(1)*x+vec(3))/vec(2)
y=-1.*(vec(1).*x+vec(3))./vec(2); 

% plot line
line(x,y,'Color',color);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%NOTES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% linie aus F berechnen
% liniengleichung ax+by+c=0, dann F*punkt multiplizieren (p muss homogen
% sein), dann haben wir linie in form der liniengleichung

% linie ins bild zeichnen: line funktion von matlab nutzen, x und y sind
% jeweils vetoren, x enth�lt alle x wert (start und end punkt) und f�r y
% genauso, hier erster x wert ist 1 und zweiter ist width of bild und dann
% nur noch y werte ausrechenen, weil man linie �bers ganze bild haben will

% f*punkt gibt vector mit a b c, liniengleichung umstellen nach y und abc
% vektor einsetzten und f�r x=1 und x=bildbreite die y ausrechnen und dann
% hat man alles und in die line funktion einsetzen
