%%
th = humanarm5D(3);
mark = btkGetMarkers(btkReadAcquisition('Human3IMU03_1302_2.c3d'));

n = 24690;

El_mp = (mark.El_ex + mark.El_in)/2;
Wr_mp = (mark.Wr_ex + mark.Wr_in)/2;

for i=1:size(mark.Cl,1)
    
    Y0 = [0 0 1]';
    O2 = (mark.Sh(i,:) - [0 0 45])';
    a = (O2 - mark.Cl(i,:)');
    X0 = a - (Y0'*a)*Y0;
    X0 = X0/norm(X0);
%     X0 = cross(mark.Sh(i,:) - El_mp(i,:), Wr_mp(i,:) - El_mp(i,:));
%     X0 = X0'/norm(X0);
    Z0 = cross(X0, Y0);
    n0 = [X0 Y0 Z0];
    
    P1(i,:) = n0'*(mark.IMU2(i,:)' - O2)*1e-3;
    P2(i,:) = n0'*(mark.IMU1(i,:) - El_mp(i,:))'*1e-3;
    % IMU2 pos for position error
%     P2ch(i,:) = n1'*(mark.IMU1(i,:)' - O2)*1e-3;
    
end
%% 

f1 = th.Sens.Sifx{1};
f2 = th.Sens.Sifx{2};

S1 = f1(0);
S2 = f2(0);

T1 = subs(th.Ti{1},0);
T2 = subs(th.Ti{2},0);
T3 = subs(th.Ti{3},0);
T4 = subs(th.Ti{4},0);
s1P1 = (T1(1:3,1:3)*T2(1:3,1:3)*S1(1:3,1:3))'*P1(n,:)';
s2P2 = (T1(1:3,1:3)*T2(1:3,1:3)*T3(1:3,1:3)*T4(1:3,1:3)*S2(1:3,1:3))'*P2(n,:)';

lFa = sqrt(sum((El_mp-mark.Sh).^2,2));
lUa = sqrt(sum((Wr_mp-El_mp).^2,2));