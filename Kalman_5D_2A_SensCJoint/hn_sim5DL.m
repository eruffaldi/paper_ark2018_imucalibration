function [ Y, a ] = hn_sim5DL( x, p, params )
%#codegen
g = [0 0 -9.81]';
Z0 = [0 0 1]';
% cap2
%m02 = [17.7740   12.9559  -42.3288]';
%m01 = [16.5387   15.9820  -40.5761]';
% cap1
% m01 = [18.1780   16.3333  -39.6435]';
% m02 = [19.3934   14.7100  -41.5265]';

%Unpack params

% params first row: uarm forearm
lua = params(1,1);
lfa = params(1,2);

%[s.m0,s.qoffset,s.ry,s.rx,s.txyz];
m01 = params(2,1:3)';
m02 = params(3,1:3)';
xr = [params(2,4:6); params(3,4:6)];

% unpack state
q = x(1:3:(5*3-2))';
dq = x(2:3:(5*3-1))';
ddq = x(3:3:(5*3))';                
    
                           
                      
%Compute parents to sensors transformations
t3 = q(3) + xr(1,1);
y1 =  xr(1,2);
x1 = xr(1,3);

S11 = [cos(t3) -sin(t3) 0 0;sin(t3) cos(t3) 0 0;0 0 1 0;0 0 0 1];
S12 = [cos(y1) 0 sin(y1) 0; 0 1 0 0;-sin(y1) 0 cos(y1) 0; 0 0 0 1];
S13 = [1 0 0 0;0 cos(x1) -sin(x1) 0;0 sin(x1) cos(x1) 0; 0 0 0 1];
S1 = S11*S12*S13;

t5 = q(5) + xr(2,1);
y2 =  xr(2,2);
x2 =  xr(2,3);

S21 = [cos(t5) -sin(t5) 0 0;sin(t5) cos(t5) 0 0;0 0 1 0;0 0 0 1];
S22 = [cos(y2) 0 sin(y2) 0; 0 1 0 0;-sin(y2) 0 cos(y2) 0; 0 0 0 1];
S23 = [1 0 0 0;0 cos(x2) -sin(x2) 0;0 sin(x2) cos(x2) 0; 0 0 0 1];
S2 = S21*S22*S23;

T = modDHL(q, lua, lfa);
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
PS1 = p(1:3)';
vdots1 = (cross2(omegadots1, PS1)+cross2(omegas1,cross2(omegas1,PS1))+S1(1:3,1:3)'*vdot2);
PS2 = p(4:6)';
vdots2 = (cross2(omegadots2, PS2)+cross2(omegas2,cross2(omegas2,PS2))+S2(1:3,1:3)'*vdot4);

Sg1 = T0(1:3,1:3)*T(1:3,1:3)*T(1:3,5:7)*S1(1:3,1:3);
Sg2 = T0(1:3,1:3)*T(1:3,1:3)*T(1:3,5:7)*T(1:3,9:11)*T(1:3,13:15)*S2(1:3,1:3);

%Compute measurement
 
Y = [omegas1; (vdots1+Sg1'*g)/9.81; Sg1'*m01; omegas2 ; (vdots2+Sg2'*g)/9.81; Sg2'*m02];
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