function T = modDHL(q, lua, lfa)
%#codegen

T = zeros(4,20);

dh1 = [0 pi/2 0 0 0];
dh2 = [0 pi/2 0 0 -pi/2];
dh3 = [lua 0 0 0 pi/2];
dh4 = [0 -pi/2 0 0 -pi/2];
dh5 = [0 0 lfa 0 0];

DHmatrix = [dh1;dh2;dh3;dh4;dh5];

for i=1:5
    a = DHmatrix(i,1);
    alpha = DHmatrix(i,2);
    d = DHmatrix(i,3);
    offset = DHmatrix(i,5);
    
    ct = cos(q(i) + offset);
    st = sin(q(i) + offset);
    ca = cos(alpha);
    sa = sin(alpha);
    T(1:4,(i-1)*4+1:(i-1)*4+4) = [ct -st*ca st*sa a*ct;
        st ct*ca -ct*sa a*st;
        0   sa      ca    d;
        0   0        0    1];
end


end