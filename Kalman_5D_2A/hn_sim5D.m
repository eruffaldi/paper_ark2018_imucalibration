function [ Y ] = hn_sim5D( x, params )
%#codegen
g = [0 0 -9.81]';
Z0 = [0 0 1]';
m01 = [18.4548   18.6514  -39.0012]';
m02 = [18.5557   12.7107  -41.8936]';

% unpack state
q = x(1:3:(5*3-2))';
dq = x(2:3:(5*3-1))';
ddq = x(3:3:(5*3))';

%Compute parents to sensors transformations
t3 = q(3)-0.0020;
y1 =  0.5003;
x1 = -0.0523;
S11 = [cos(t3) -sin(t3) 0 0;sin(t3) cos(t3) 0 0;0 0 1 0;0 0 0 1];
S12 = [cos(y1) 0 sin(y1) 0; 0 1 0 0;-sin(y1) 0 cos(y1) 0; 0 0 0 1];
S13 = [1 0 0 0;0 cos(x1) -sin(x1) 0;0 sin(x1) cos(x1) 0; 0 0 0 1];
S14 = [[eye(3); 0 0 0] [-0.0139    0.2289   -0.0657 1]'];
S1 = S11*S12*S13*S14;

t5 = q(5)-0.0525;
y2 =  0.1269;
x2 =  -1.5582;
S21 = [cos(t5) -sin(t5) 0 0;sin(t5) cos(t5) 0 0;0 0 1 0;0 0 0 1];
S22 = [cos(y2) 0 sin(y2) 0; 0 1 0 0;-sin(y2) 0 cos(y2) 0; 0 0 0 1];
S23 = [1 0 0 0;0 cos(x2) -sin(x2) 0;0 sin(x2) cos(x2) 0; 0 0 0 1];
S24 = [[eye(3); 0 0 0] [0.0609   -0.1686   -0.0503 1]'];
S2 = S21*S22*S23*S24;

T = modDH(q);
T0 = [1 0 0 0;0 0 -1 0;0 1 0 0; 0 0 0 1];

%Compute joints omegas
omega1 = T(1:3,1:3)'*dq(1)*Z0;
omega2 = T(1:3,5:7)'*(omega1 + dq(2)*Z0);
omega3 = T(1:3,9:11)'*(omega2 + dq(3)*Z0);
omega4 = T(1:3,13:15)'*(omega3 + dq(4)*Z0);

%Compute joints omegadots
omegadot1 = T(1:3,1:3)'*ddq(1)*Z0;
omegadot2 = T(1:3,5:7)'*(omegadot1+cross2(dq(2)*omega1,Z0)+ddq(2)*Z0);
omegadot3 = T(1:3,9:11)'*(omegadot2+cross2(dq(3)*omega2,Z0)+ddq(3)*Z0);
omegadot4 = T(1:3,13:15)'*(omegadot3+cross2(dq(4)*omega3,Z0)+ddq(4)*Z0);

%Compute joints vdots
P1 = T(1:3,1:3)'*T(1:3,4);
vdot1 = cross2(omegadot1, P1) + cross2(omega1,cross2(omega1,P1));
P2 = T(1:3,5:7)'*T(1:3,8);
vdot2 = (cross2(omegadot2, P2)+cross2(omega2,cross2(omega2,P2))+T(1:3,5:7)'*vdot1);
P3 = T(1:3,9:11)'*T(1:3,12);
vdot3 = (cross2(omegadot3, P3)+cross2(omega3,cross2(omega3,P3))+T(1:3,9:11)'*vdot2);
P4 = T(1:3,13:15)'*T(1:3,16);
vdot4 = (cross2(omegadot4, P4)+cross2(omega4,cross2(omega4,P4))+T(1:3,13:15)'*vdot3);

%Compute sensors omegas
omegas1 = S1(1:3,1:3)'*(omega2 + dq(3)*Z0);
omegas2 = S2(1:3,1:3)'*(omega4 + dq(5)*Z0);

%Compute sensors omegadots
omegadots1 = S1(1:3,1:3)'*(omegadot2+cross2(dq(3)*omega2,Z0)+ddq(3)*Z0);
omegadots2 = S2(1:3,1:3)'*(omegadot4+cross2(dq(5)*omega4,Z0)+ddq(5)*Z0);

%Compute sensors vdots
PS1 = S1(1:3,1:3)'*S1(1:3,4);
vdots1 = (cross2(omegadots1, PS1)+cross2(omegas1,cross2(omegas1,PS1))+S1(1:3,1:3)'*vdot2);
PS2 = S2(1:3,1:3)'*S2(1:3,4);
vdots2 = (cross2(omegadots2, PS2)+cross2(omegas2,cross2(omegas2,PS2))+S2(1:3,1:3)'*vdot4);

Sg1 = T0(1:3,1:3)*T(1:3,1:3)*T(1:3,5:7)*S1(1:3,1:3);
Sg2 = T0(1:3,1:3)*T(1:3,1:3)*T(1:3,5:7)*T(1:3,9:11)*T(1:3,13:15)*S2(1:3,1:3);

%Compute measurement
Y = [omegas1; (vdots1+Sg1'*g)/9.81; Sg1'*m01; omegas2 ; (vdots2+Sg2'*g)/9.81; Sg2'*m02];

end