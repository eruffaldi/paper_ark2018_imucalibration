%%
th = humanarm(3);
% mark = btkGetMarkers(btkReadAcquisition('Human3IMU Cal 04.c3d'));

mark = btkGetMarkers(btkReadAcquisition('Human3IMU0302.c3d'));

% n = 5300; % for cap 0802
n = 24730; %For cap2 1203

El_mp = (mark.El_ex + mark.El_in)/2;
Wr_mp = (mark.Wr_ex + mark.Wr_in)/2;

a = zeros(3,size(mark.Cl,1));

for i=1:size(mark.Cl,1)
    
    Y1 = [0 0 1]';
    O2 = (mark.Sh(i,:) - [0 0 45])';
    a(:,i) = (O2 - mark.Cl(i,:)');
    X1 = a(:,i) - (Y1'*a(:,i))*Y1;
    X1 = X1/norm(X1);
    Z1 = cross(X1, Y1);
    n1 = [X1 Y1 Z1];
    
    
    P3(i,:) = n1'*(mark.IMU3(i,:) - mark.Cl(i,:))'*1e-3;
    P1(i,:) = n1'*(mark.IMU2(i,:)' - O2)*1e-3;
    P2(i,:) = n1'*(mark.IMU1(i,:) - El_mp(i,:))'*1e-3;
    % IMU2 pos for position error
    P2ch(i,:) = n1'*(mark.IMU1(i,:)' - O2)*1e-3;
    
end
%% 

f1 = th.Sens.Sifx{1};
f2 = th.Sens.Sifx{2};
f3 = th.Sens.Sifx{3};

S1 = f1(0);
S2 = f2(0);
S3 = f3(0);


T1 = subs(th.Ti{1},0);
T2 = subs(th.Ti{2},0);
T3 = subs(th.Ti{3},0);
T4 = subs(th.Ti{4},0);
T5 = subs(th.Ti{5},0);
T6 = subs(th.Ti{6},0);
s1P1 = (T2(1:3,1:3)*T3(1:3,1:3)*T4(1:3,1:3)*S1(1:3,1:3))'*P1(n,:)';
s2P2 = (T2(1:3,1:3)*T3(1:3,1:3)*T4(1:3,1:3)*T5(1:3,1:3)*T6(1:3,1:3)*S2(1:3,1:3))'*P2(n,:)';
s3P3 = S3(1:3,1:3)'*P3(n,:)';

