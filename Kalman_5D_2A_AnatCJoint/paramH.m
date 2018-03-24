function [Y] = paramH(X)
%#codegen

Z0 = [0 0 1]';

qL = X(1:3:15);
qR = X(16:3:30);
dqL = X(2:3:15);
dqR = X(17:3:30);
ddqL = X(3:3:15);
ddqR = X(18:3:30);

qL = qL + [0 -pi/2 pi/2 -pi/2 0]';
qR = qR + [0 -pi/2 pi/2 -pi/2 0]';

Gam0L = rotDHL(qL,4)*[cos(qL(5)) 0; sin(qL(5)) 0; 0 1];
Gam2L = rotDHL(qL,2)*[cos(qL(3)) 0; sin(qL(3)) 0; 0 1];
OffGamL = [1 0; 0 0; 0 1]*[0.18 0]';

Gam0R = rotDHR(qR,4)*[cos(qR(5)) 0; sin(qR(5)) 0; 0 1];
Gam2R = rotDHR(qR,2)*[cos(qR(3)) 0; sin(qR(3)) 0; 0 1];
OffGamR = [1 0; 0 0; 0 1]*[-0.18 0]';

tmp4L = rotDHL(qL,4)*[cos(qL(5)) 0; sin(qL(5)) 0; 0 1];
tmp2L = rotDHL(qL,2)*[cos(qL(3)) 0; sin(qL(3)) 0; 0 1];

tmp4R = rotDHL(qL,4)*[cos(qL(5)) 0; sin(qL(5)) 0; 0 1];
tmp2R = rotDHL(qL,2)*[cos(qL(3)) 0; sin(qL(3)) 0; 0 1];

TL = modDHL(qL, X(31), X(32));

o1L = TL(1:3,1:3)'*dqL(1)*Z0;
o2L = TL(1:3,5:7)'*(o1L + dqL(2)*Z0);
o3L = TL(1:3,9:11)'*(o2L + dqL(3)*Z0);
o4L = TL(1:3,13:15)'*(o3L + dqL(4)*Z0);
o5L = TL(1:3,17:19)'*(o4L + dqL(5)*Z0);

%Compute joints omegadots
do1L = TL(1:3,1:3)'*ddqL(1)*Z0;
do2L = TL(1:3,5:7)'*(do1L+cross2(dqL(2)*o1L,Z0)+ddqL(2)*Z0);
do3L = TL(1:3,9:11)'*(do2L+cross2(dqL(3)*o2L,Z0)+ddqL(3)*Z0);
do4L = TL(1:3,13:15)'*(do3L+cross2(dqL(4)*o3L,Z0)+ddqL(4)*Z0);
do5L = TL(1:3,17:19)'*(do4L+cross2(dqL(5)*o4L,Z0)+ddqL(5)*Z0);

TR = modDHR(qR, X(33), X(34));

o1R = TR(1:3,1:3)'*dqR(1)*Z0;
o2R = TR(1:3,5:7)'*(o1R + dqR(2)*Z0);
o3R = TR(1:3,9:11)'*(o2R + dqR(3)*Z0);
o4R = TR(1:3,13:15)'*(o3R + dqR(4)*Z0);
o5R = TR(1:3,17:19)'*(o4R + dqR(5)*Z0);

%Compute joints omegadots
do1R = TR(1:3,1:3)'*ddqR(1)*Z0;
do2R = TR(1:3,5:7)'*(do1R+cross2(dqR(2)*o1R,Z0)+ddqR(2)*Z0);
do3R = TR(1:3,9:11)'*(do2R+cross2(dqR(3)*o2R,Z0)+ddqR(3)*Z0);
do4R = TR(1:3,13:15)'*(do3R+cross2(dqR(4)*o3R,Z0)+ddqR(4)*Z0);
do5R = TR(1:3,17:19)'*(do4R+cross2(dqR(5)*o4R,Z0)+ddqR(5)*Z0);

So5L = S(rotDHL(qL,5)*o5L);
So3L = S(rotDHL(qL,3)*o3L);

Sdo5L = S(rotDHL(qL,5)*do5L);
Sdo3L = S(rotDHL(qL,3)*do3L);

So5R = S(rotDHR(qR,5)*o5R);
So3R = S(rotDHR(qR,3)*o3R);

Sdo5R = S(rotDHR(qR,5)*do5R);
Sdo3R = S(rotDHR(qR,3)*do3R);

Phi4L = So5L*tmp4L;
Phi2L = So3L*tmp2L;

Phi4R = So5R*tmp4R;
Phi2R = So5R*tmp2R;

Psi4L = (Sdo5L+So5L*So5L)*tmp4L;
Psi2L = (Sdo3L+So3L*So3L)*tmp2L;

Psi4R = (Sdo5R+So5R*So5R)*tmp4R;
Psi2R = (Sdo3R+So3R*So3R)*tmp2R;

CL = [OffGamL(:,1) Gam2L(:,1) Gam0L(:,2) ;zeros(3,1) Phi2L(:,1) Phi4L(:,2) ;zeros(3,1) Psi2L(:,1) Psi4L(:,2) ];
CR = [OffGamR(:,1) Gam2R(:,1) Gam0R(:,2)  ;zeros(3,1) Phi2R(:,1) Phi4R(:,2) ;zeros(3,1) Psi2R(:,1) Psi4R(:,2) ];


C = [CL -CR];

Y = C*[1; X(31:32); 1 ; X(33); -X(34)];

end

function R = rotDHL(q, j)
%#codegen
% 
% dh1 = [pi/2 0];
% dh2 = [pi/2 -pi/2];
% dh3 = [0 pi/2];
% dh4 = [-pi/2 -pi/2];
% dh5 = [0 0];

% DHmatrix = [dh1;dh2;dh3;dh4;dh5];
alpha = [pi/2 pi/2 0 -pi/2 0];

R = eye(3);

for i=1:j
%     alpha = DHmatrix(i,1);
%     offset = DHmatrix(i,2);
    
%     ct = cos(q(i) + offset);
%     st = sin(q(i) + offset);
    ct = cos(q(i));
    st = sin(q(i));

    ca = cos(alpha(i));
    sa = sin(alpha(i));
    R = R*[ct -st*ca st*sa; st ct*ca -ct*sa; 0 sa ca];
end

end


function R = rotDHR(q, j)
%#codegen


% dh1 = [-pi/2 0];
% dh2 = [-pi/2 -pi/2];
% dh3 = [0 pi/2];
% dh4 = [pi/2 -pi/2];
% dh5 = [0 0];

% DHmatrix = [dh1;dh2;dh3;dh4;dh5];
alpha = [-pi/2 -pi/2 0 pi/2 0];
R = [-1 0 0; 0 1 0;0 0 -1];


for i=1:j
%     alpha = DHmatrix(i,1);
%     offset = DHmatrix(i,2);
%     
%     ct = cos(q(i) + offset);
%     st = sin(q(i) + offset);
    ct = cos(q(i));
    st = sin(q(i));
    ca = cos(alpha(i));
    sa = sin(alpha(i));
    R = R*[ct -st*ca st*sa; st ct*ca -ct*sa; 0 sa ca];
end


end


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
  
    ct = cos(q(i));
    st = sin(q(i));
    ca = cos(alpha);
    sa = sin(alpha);
    T(1:4,(i-1)*4+1:(i-1)*4+4) = [ct -st*ca st*sa a*ct;
        st ct*ca -ct*sa a*st;
        0   sa      ca    d;
        0   0        0    1];
end


end

function T = modDHR(q, lua, lfa)
%#codegen

T = zeros(4,20);

dh1 = [0 -pi/2 0 0 0];
dh2 = [0 -pi/2 0 0 -pi/2];
dh3 = [lua 0 0 0 pi/2];
dh4 = [0 pi/2 0 0 -pi/2];
dh5 = [0 0 -lfa 0 0];


DHmatrix = [dh1;dh2;dh3;dh4;dh5];

for i=1:5
    a = DHmatrix(i,1);
    alpha = DHmatrix(i,2);
    d = DHmatrix(i,3);
    
    ct = cos(q(i));
    st = sin(q(i));
    ca = cos(alpha);
    sa = sin(alpha);
    T(1:4,(i-1)*4+1:(i-1)*4+4) = [ct -st*ca st*sa a*ct;
        st ct*ca -ct*sa a*st;
        0   sa      ca    d;
        0   0        0    1];
end


end