function R = rotMatrix(rot_x, rot_y, rot_z)

    a = [   1 0           0          ;
            0 cos(rot_x) -sin(rot_x) ;
            0 sin(rot_x)  cos(rot_x) ];

    b = [   cos(rot_y) 0 sin(rot_y)  ;
            0          1 0           ;
           -sin(rot_y) 0 cos(rot_y)  ]; 

    c = [   cos(rot_z) -sin(rot_z) 0 ;
            sin(rot_z)  cos(rot_z) 0 ;
            0           0          1 ]; 
            
     R=a*b*c;
end



