% mark = btkGetMarkers(btkReadAcquisition('Human2A4IMU Cal 04.c3d'));
mark = btkGetMarkers(btkReadAcquisition('Human2A4IMU Cal 05.c3d'));

% n = 9250;
n = 1;

mark.ShL = mark.C_18;

El_mpR = (mark.El_exR + mark.El_inR)/2;
Wr_mpR = (mark.Wr_exR + mark.Wr_inR)/2;

El_mpL = (mark.El_exL + mark.El_inL)/2;
Wr_mpL = (mark.Wr_exL + mark.Wr_inL)/2;

Ys0L = (mark.ShL(n,:) - El_mpL(n,:))';
Ys0L = Ys0L/norm(Ys0L);

Ys0R = (mark.ShR(n,:) - El_mpR(n,:))';
Ys0R = Ys0R/norm(Ys0R);

% a = (mark.ShL(n,:) - mark.Cl(n,:))';
% Xs0L = a - (Ys0L'*a)*Ys0L;
% % Xs0L = (mark.ShL(n,:) - mark.Cl(n,:))';
% Xs0L = Xs0L/norm(Xs0L);

Xs0L = cross(mark.ShL(n,:) - El_mpL(n,:),Wr_mpL(n,:) - El_mpL(n,:))';
Xs0L = Xs0L/norm(Xs0L);
Zs0L = cross(Xs0L, Ys0L);

Xs0R = cross(mark.ShR(n,:) - El_mpR(n,:),Wr_mpR(n,:) - El_mpR(n,:))';
Xs0R = Xs0R/norm(Xs0R);
Zs0R = cross(Xs0R, Ys0R);

% Ys0L = [0 0 1]';
% Xs0L = [1 0 0]';
% Zs0L = [0 -1 0]';

q1L = zeros(1,size(mark.Cl,1)-n);
q2L = zeros(1,size(mark.Cl,1)-n);    
q3L = zeros(1,size(mark.Cl,1)-n);
q1R = zeros(1,size(mark.Cl,1)-n);
q2R = zeros(1,size(mark.Cl,1)-n);    
q3R = zeros(1,size(mark.Cl,1)-n);

q4L = zeros(1,size(mark.Cl,1)-n);
q5L = zeros(1,size(mark.Cl,1)-n);
q4R = zeros(1,size(mark.Cl,1)-n);
q5R = zeros(1,size(mark.Cl,1)-n);    

for i=1:size(mark.Cl)-n
    I = n+i;
    
    YeL(:,i) = (mark.ShL(I,:) - El_mpL(I,:))';
    YeL(:,i) = YeL(:,i)/norm(YeL(:,i));
    
%     XeL(:,i) = cross(mark.ShL(I,:) - El_mpL(I,:),Wr_mpL(I,:) - El_mpL(I,:))';
%     XeL(:,i) = XeL(:,i)/norm(XeL(:,i));

    YeR(:,i) = (mark.ShR(I,:) - El_mpR(I,:))';
    YeR(:,i) = YeR(:,i)/norm(YeR(:,i));
    
    XeR(:,i) = cross(mark.ShR(I,:) - El_mpR(I,:),Wr_mpR(I,:) - El_mpR(I,:))';
    XeR(:,i) = XeR(:,i)/norm(XeR(:,i));
 
%     a = (mark.ShR(I,:) - mark.Cl(I,:))';
%     XeR(:,i) = a - (YeR(:,i)'*a)*YeR(:,i);
%     XeR(:,i) = XeR(:,i)/norm(XeR(:,i));
% 
    a = (mark.ShL(I,:) - mark.Cl(I,:))';
    XeL(:,i) = a - (YeL(:,i)'*a)*YeL(:,i);
    XeL(:,i) = XeL(:,i)/norm(XeL(:,i));

    ZeL(:,i) = cross(XeL(:,i), YeL(:,i));
    ZeR(:,i) = cross(XeR(:,i), YeR(:,i));
    
    RL = [Xs0L Ys0L Zs0L]'*[XeL(:,i) YeL(:,i) ZeL(:,i)];
    RR = [Xs0R Ys0R Zs0R]'*[XeR(:,i) YeR(:,i) ZeR(:,i)];
    
    q2L(i) = -asin(RL(3,1));
    q3L(i) = -atan2(RL(3,2)/cos(q2L(i)),RL(3,3)/cos(q2L(i)));
    q1L(i) = atan2(RL(2,1)/cos(q2L(i)),RL(1,1)/cos(q2L(i)));
    
    q2R(i) = -asin(RR(3,1));
    q3R(i) = -atan2(RR(3,2)/cos(q2R(i)),RR(3,3)/cos(q2R(i)));
    q1R(i) = -atan2(RR(2,1)/cos(q2R(i)),RR(1,1)/cos(q2R(i)));
    
    YwL(:,i) = (El_mpL(I,:) - Wr_mpL(I,:))';
    YwL(:,i) = YwL(:,i)/norm(YwL(:,i));
    ZwL(:,i) = mark.Wr_exL(I,:) - mark.Wr_inL(I,:);
    ZwL(:,i) = ZwL(:,i)'/norm(ZwL(:,i));
    XwL(:,i) = cross(YwL(:,i), ZwL(:,i));
 

    YwR(:,i) = (El_mpR(I,:) - Wr_mpR(I,:))';
    YwR(:,i) = YwR(:,i)/norm(YwR(:,i));
    ZwR(:,i) = mark.Wr_exR(I,:) - mark.Wr_inR(I,:);
    ZwR(:,i) = ZwR(:,i)'/norm(ZwR(:,i));
    XwR(:,i) = cross(YwR(:,i), ZwR(:,i));
    
    RL = [XeL(:,i) YeL(:,i) ZeL(:,i)]'*[XwL(:,i) YwL(:,i) ZwL(:,i)];
    RR = [XeR(:,i) YeR(:,i) ZeR(:,i)]'*[XwR(:,i) YwR(:,i) ZwR(:,i)];
    
    q5L(i) = -asin(RL(1,3));
    q4L(i) = -atan2(-RL(2,3)/cos(q5L(i)),RL(3,3)/cos(q5L(i)));
   
    q5R(i) = -asin(RR(1,3));
    q4R(i) = -atan2(-RR(2,3)/cos(q5R(i)),RR(3,3)/cos(q5R(i)));
end

q4L = q4L - q4L(1);
q4R = q4R - q4R(1);

% 
% figure;
% subplot(4,1,1)
% plot(q1L);
% subplot(4,1,2)
% plot(q2L);
% subplot(4,1,3)
% plot(q3L);
% subplot(4,1,4)
% plot(Wr_mpL(n:end,:))
% 
% figure;
% subplot(3,1,1)
% plot(q4L);
% subplot(3,1,2)
% plot(q5L);
% subplot(3,1,3)
% plot(Wr_mpL(n:end,:))

[B,A] = butter(2,0.2) ;
q1L_f = filtfilt(B, A, q1L);
q2L_f = filtfilt(B, A, q2L);
q3L_f = filtfilt(B, A, q3L);
q4L_f = filtfilt(B, A, q4L);
q5L_f = filtfilt(B, A, q5L);  

q1R_f = filtfilt(B, A, q1R);
q2R_f = filtfilt(B, A, q2R);
q3R_f = filtfilt(B, A, q3R);
q4R_f = filtfilt(B, A, q4R);
q5R_f = filtfilt(B, A, q5R);  

q = [q1L_f' q2L_f' q3L_f',q4L_f',q5L_f'];
allq;

q1L_s = oq(:,1)*180/pi;
q2L_s = oq(:,2)*180/pi;
q3L_s = oq(:,3)*180/pi;
q4L_s = oq(:,4)*180/pi;
q5L_s = oq(:,5)*180/pi;

q = [q1R_f' q2R_f' q3R_f',q4R_f',q5R_f'];
allq;

q1R_s = oq(:,1)*180/pi;
q2R_s = oq(:,2)*180/pi;
q3R_s = oq(:,3)*180/pi;
q4R_s = oq(:,4)*180/pi;
q5R_s = oq(:,5)*180/pi;

qR = [q1R_s q2R_s q3R_s q4R_s q5R_s];
qL = [q1L_s q2L_s q3L_s q4L_s q5L_s];

h = figure;
set(h,'Name','Shoulder Joints L');
subplot(3,1,1);
plot(q1L_s);
title('Sh Abd');
subplot(3,1,2);
plot(q2L_s);
title('Sh Rot');
subplot(3,1,3);
plot(q3L_s);
title('Sh Flex');

h = figure;
set(h,'Name','Elbow Joints L');
subplot(2,1,1);
plot(q4L_s);
title('El Flex');
subplot(2,1,2);
plot(q5L_s);
title('El Rot');

h = figure;
set(h,'Name','Shoulder Joints R');
subplot(3,1,1);
plot(q1R_s);
title('Sh Abd');
subplot(3,1,2);
plot(q2R_s);
title('Sh Rot');
subplot(3,1,3);
plot(q3R_s);
title('Sh Flex');

h = figure;
set(h,'Name','Elbow Joints R');
subplot(2,1,1);
plot(q4R_s);
title('El Flex');
subplot(2,1,2);
plot(q5R_s);
title('El Rot');
