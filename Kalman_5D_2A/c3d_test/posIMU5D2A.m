%%
[thL, thR] = humanarm5D2A(3);
mark = btkGetMarkers(btkReadAcquisition('Human2A4IMU Cal 04.c3d'));

n = 9344;

El_mpR = (mark.El_exR + mark.El_inR)/2;
Wr_mpR = (mark.Wr_exR + mark.Wr_inR)/2;

El_mpL = (mark.El_exL + mark.El_inL)/2;
Wr_mpL = (mark.Wr_exL + mark.Wr_inL)/2;


for i=1:size(mark.Cl,1)
    
    Y0R = [0 0 1]';
    Y0L = [0 0 1]';
    
    O2L = (mark.ShL(i,:) - [0 0 45])';
    O2R = (mark.ShR(i,:) - [0 0 45])';

    aL = (O2L - mark.Cl(i,:)');
    X0L = aL - (Y0L'*aL)*Y0L;
    
    aR = (O2R - mark.Cl(i,:)');
    X0R = aR - (Y0R'*aR)*Y0R;
    
    X0L = X0L/norm(X0L);
    X0R = X0R/norm(X0R);
    
    Z0L = cross(X0L, Y0L);
    Z0R = cross(X0R, Y0R);
    
    n0L = [X0L Y0L Z0L];
    n0R = [X0R Y0R Z0R];
    
    % 16790 possible n-pose
    P1R(i,:) = n0R'*(mark.Imu1R(16790,:)' - O2R)*1e-3;
    P2R(i,:) = n0R'*(mark.Imu2R(i,:) - El_mpR(i,:))'*1e-3;
    
    P1L(i,:) = n0L'*(mark.Imu1L(i,:)' - O2L)*1e-3;
    P2L(i,:) = n0L'*(mark.Imu2L(i,:) - El_mpL(i,:))'*1e-3;
    
    
end
%% 




f1L = thL.Sens.Sifx{1};
f2L = thL.Sens.Sifx{2};

f1R = thR.Sens.Sifx{1};
f2R = thR.Sens.Sifx{2};

S1L = f1L(0);
S2L = f2L(0);

S1R = f1R(0);
S2R = f2R(0);

T1 = subs(thL.Ti{1},0);
T2 = subs(thL.Ti{2},0);
T3 = subs(thL.Ti{3},0);
T4 = subs(thL.Ti{4},0);
s1P1L = (T1(1:3,1:3)*T2(1:3,1:3)*S1L(1:3,1:3))'*P1L(n,:)';
s2P2L = (T1(1:3,1:3)*T2(1:3,1:3)*T3(1:3,1:3)*T4(1:3,1:3)*S2L(1:3,1:3))'*P2L(n,:)';

T1 = subs(thR.Ti{1},0);
T2 = subs(thR.Ti{2},0);
T3 = subs(thR.Ti{3},0);
T4 = subs(thR.Ti{4},0);
s1P1R = (T1(1:3,1:3)*T2(1:3,1:3)*S1R(1:3,1:3))'*P1R(n,:)';
s2P2R = (T1(1:3,1:3)*T2(1:3,1:3)*T3(1:3,1:3)*T4(1:3,1:3)*S2R(1:3,1:3))'*P2R(n,:)';
