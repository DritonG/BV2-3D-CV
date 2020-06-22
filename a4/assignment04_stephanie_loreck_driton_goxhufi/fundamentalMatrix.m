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
    
    % eigentlich unnoetig, da schon implementiert
    % check if at least 8 points
    if (num_corr<8)
        return;
    end
    
    % mittelwerte
    % ml mittelwert linke punkte
    ml=mean(pl,1);
    mr=mean(pr,1);
    
    % durchschnittliche abstaende
    % dl für linke punkte
    dl=zeros(size(pl,1),1);
    dr=zeros(size(pr,1),1);
    for i=1:num_corr
        % abstand punkt zur mitte: d=sqrt((x-mx)^2+(y-my)^2)
        dl(i)=sqrt((pl(i,1)-ml(1))^2+(pl(i,2)-ml(2))^2);
        dr(i)=sqrt((pr(i,1)-mr(1))^2+(pr(i,2)-mr(2))^2);
    end
    dl=mean(dl);
    dr=mean(dr);
    
    % HL und HR
    HL=[1/dl   0       -ml(1)/dl ;
        0      1/dl    -ml(2)/dl ;
        0       0        1];
    
    HR=[1/dr   0       -mr(1)/dr ;
        0      1/dr    -mr(2)/dr ;
        0       0        1];
    
    % punkte homogenisieren
    pl=cat(2,pl,ones(size(pl,1),1));
    pr=cat(2,pr,ones(size(pr,1),1));
    
    % punkte normieren
    pl=HL*pl';
    pr=HR*pr';
    
    pl=pl';
    pr=pr';
    
%     %nur zur ueberpruefung
%     ml=mean(pl,1);
%     mr=mean(pr,1);
%     disp(ml);
%     disp(mr);
%     
%     for i=1:num_corr
%         % abstand punkt zur mitte: d=sqrt((x-mx)^2+(y-my)^2)
%         dl(i)=sqrt((pl(i,1)-ml(1))^2+(pl(i,2)-ml(2))^2);
%         dr(i)=sqrt((pr(i,1)-mr(1))^2+(pr(i,2)-mr(2))^2);
%     end
%     disp(mean(dl));
%     disp(mean(dr));
    
    % A matrix aufstellen
    xr=pr(:,1);
    yr=pr(:,2);
    xl=pl(:,1);
    yl=pl(:,2);
    
    % spalten: xrechts*xlinks,xrechts*ylinks, xrechts,xlinks*yrechts,
    % ylinks*yrechts,yrechts,xlinks,ylinks,1
    % A=nx9
    A=cat(2, xr.*xl, xr.*yl, xr, xl.*yr, yl.*yr, yr, xl, yl, ones(size(xr,1),1));
    
    % svd von A
    [U,S,V] = svd(A);
    
    % letzte spalte von V
    Fn=V(:,end);
    
    % Fn orthogonalisieren wie bei R --> reshape, evtl noch transponieren (ja)
    Fn=reshape(Fn,[3, 3])';
    
    % svd auf Fn
    [U,S,V] = svd(Fn);
    S(end,end)=0;
    
    Fn=U*S*V';
    
    % F aus Fn und H matrizen berechnen
    F=HR'*Fn*HL; % TODO dimensionen falsch
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%NOTES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% punkte mit hl und hr multiplizieren, da matrix 3*3 punkte um 1 in z
% richtung erweitern (homogene koordinaten) 

% folien 4:
% 10 punkte anklicken und als korrespondenzen setzen
% linke und rechte punkte extrahieren, schon gegeben
% erstmal hl und hr aufstellen (für r genau das gleiche)
% ml mittelwert linke punkte, mr mittelwert rechte punkte
% ml alle linken punkte nhemen und dafür mittelwert für je x und y
% berechnen, dl ist durchschnittliche länge (mittelwert länge: alle punkte
% nehmen und dann mittelwert davon abziehen, dann mittelwert davon ist dl?)
% durch dl teilen macht normierung
% mit H dann F berechnen (siehe folien)

% dann A matrix aufstellen (mit neun spalten, eine spalte wird aus einem
% paar von linkem und rechtem punkt berechnet, erste spalte: x koordinaten
% multiplizieren,xrechts*ylinks, xrechts,xlinks*yrechts,
% ylinks*yrechts,yrechts,xlinks,ylinks,1) das müsste der output von der
% herleitung sein

% mind 8 punktpaare, also mind 9 zeilen (kann auch mehr sein je nach anz 
% korrespondenzen, mit den 9 spalten aus A -->
% homogenes lineares gleichungssystem, svd drauf anwenden, v nehmen letzte
% spalte von V ist Fn, Fn orthogonalisieren (s.35), dann svd auf fn und 
% dann s davon nehmen und wert an stelle 3,3 (rechts unten) auf 0 setzten
% und dann u*s*v' und das ist dann das finale fn und daraus dann mit h f
% berechen % mit H dann F berechnen (siehe folien)

% % Fn orthogonalisieren wie bei R
%     %I=eye(size(Fn,1));
%     %Fn=Fn*I;
%     [U,S,V] = svd(Fn);
%     Fn=U*V;
%     
%     % svd auf Fn
%     [U,S,V] = svd(Fn);
%     S(end,end)=0;
%     
%     Fn=U*S*V;
%     
%     % F aus Fn und H matrizen berechnen
%     F=HR'*Fn*HL; % TODO dimensionen falsch