function R = rotDHR(q, j)
%#codegen


dh1 = [-pi/2 0];
dh2 = [-pi/2 -pi/2];
dh3 = [0 pi/2];
dh4 = [pi/2 -pi/2];
dh5 = [0 0];

DHmatrix = [dh1;dh2;dh3;dh4;dh5];
R = [-1 0 0; 0 1 0;0 0 -1];
% R = eye(3);

for i=1:j
    alpha = DHmatrix(i,1);
    offset = DHmatrix(i,2);
    
    ct = cos(q(i) + offset);
    st = sin(q(i) + offset);
    ca = cos(alpha);
    sa = sin(alpha);
    R = R*[ct -st*ca st*sa; st ct*ca -ct*sa; 0 sa ca];
end


end
