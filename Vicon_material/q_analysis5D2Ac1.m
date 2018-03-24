%% get markers
clear,clc
close all

mark = btkGetMarkers(btkReadAcquisition('Human2A4IMU Cal 04.c3d'));

alfd = fieldnames(mark);
alfd = {'Cl','ShL','ShR','El_inL','El_exL','El_inR','El_exR','Wr_inL','Wr_exL','Wr_inR','Wr_exR'};
zm = [];
zM = [];
for i=1:length(alfd)
    q = pw_norm(mark.(alfd{i}));
    sen = ones(length(mark.(alfd{i})),1);
    sen(q==0)=0;
    for j=1:3
        y = signalreconst([sen';mark.(alfd{i})(:,j)'],10,1,'spline',3,-inf,inf,0);
        mark.(alfd{i})(:,j) = y';
%         title(sprintf('Marker %s coord %d',alfd{i},j))
    end
end

%% get q

n0 = 9130;
n = 1;
idxs = n0:size(mark.Cl)-n; %good q
% idxs = 2000: 6000; %close kin q
sL = length(idxs);

mark.ShL = mark.ShL - repmat([0 0 45],size(mark.ShL,1),1);
mark.ShR = mark.ShR - repmat([0 0 45],size(mark.ShL,1),1);

ShL = mark.ShL;
ShR = mark.ShR;

El_mpR = (mark.El_exR + mark.El_inR)/2;
Wr_mpR = (mark.Wr_exR + mark.Wr_inR)/2;

El_mpL = (mark.El_exL + mark.El_inL)/2;
Wr_mpL = (mark.Wr_exL + mark.Wr_inL)/2;


%limbs lengths
LuaL = pw_norm(mark.ShL(idxs,:) - El_mpL(idxs,:));
LfaL = pw_norm(El_mpL(idxs,:) - Wr_mpL(idxs,:));
LuaR = pw_norm(mark.ShR(idxs,:) - El_mpR(idxs,:));
LfaR = pw_norm(El_mpR(idxs,:) - Wr_mpR(idxs,:));

luaL = mean(LuaL); lfaL = mean(LfaL);
luaR = mean(LuaR); lfaR = mean(LfaR);

Ys0L = (mark.ShL(n0,:) - El_mpL(n0,:))';
Ys0L = Ys0L/norm(Ys0L);

Ys0R = (mark.ShR(n0,:) - El_mpR(n0,:))';
Ys0R = Ys0R/norm(Ys0R);


% a = (mark.ShL(n,:) - mark.Cl(n,:))';
% Xs0L = a - (Ys0L'*a)*Ys0L;
% % Xs0L = (mark.ShL(n,:) - mark.Cl(n,:))';
% Xs0L = Xs0L/norm(Xs0L);
% 
% Xs0L = cross(mark.ShL(n0,:) - El_mpL(n0,:),Wr_mpL(n0,:) - El_mpL(n0,:))';
% Xs0L = Xs0L/norm(Xs0L);
% Zs0L = cross(Xs0L, Ys0L);
% 
% Xs0R = cross(mark.ShR(n0,:) - El_mpR(n0,:),Wr_mpR(n0,:) - El_mpR(n0,:))';
% Xs0R = Xs0R/norm(Xs0R);
% Zs0R = cross(Xs0R, Ys0R);

Ys0L = [0 0 1]';
Xs0L = [1 0 0]';
Zs0L = [0 -1 0]';

Ys0R = [0 0 1]';
Xs0R = [1 0 0]';
Zs0R = [0 -1 0]';

q1L = zeros(1,sL); q2L = zeros(1,sL); q3L = zeros(1,sL);
q1R = zeros(1,sL); q2R = zeros(1,sL); q3R = zeros(1,sL);
q4L = zeros(1,sL); q5L = zeros(1,sL);
q4R = zeros(1,sL); q5R = zeros(1,sL);    

uaL= zeros(3,sL); faL= zeros(3,sL); uaR= zeros(3,sL); faR= zeros(3,sL);
XeL = zeros(3,sL); YeL = zeros(3,sL); ZeL = zeros(3,sL);
XeR = zeros(3,sL); YeR = zeros(3,sL); ZeR = zeros(3,sL);
XwL = zeros(3,sL); YwL = zeros(3,sL); ZwL = zeros(3,sL);
XwR = zeros(3,sL); YwR = zeros(3,sL); ZwR = zeros(3,sL);
pElr_L = zeros(3,sL); pWrr_L = zeros(3,sL); pElr_R = zeros(3,sL); pWrr_R = zeros(3,sL);

R0v = [Xs0L Ys0L Zs0L];

for i=1:sL
    I = idxs(1)+i;
    
    uaL(:,i) = -(mark.ShL(I,:) - El_mpL(I,:))';
    faL(:,i) = (Wr_mpL(I,:) - El_mpL(I,:))';
    
    uaR(:,i) = -(mark.ShR(I,:) - El_mpR(I,:))';
    faR(:,i) = (Wr_mpR(I,:) - El_mpR(I,:))';
    
    
    YeL(:,i) = -uaL(:,i)/norm(uaL(:,i));
    
    XeL(:,i) = cross(-uaL(:,i),faL(:,i));
    XeL(:,i) = XeL(:,i)/norm(XeL(:,i));

    YeR(:,i) = -uaR(:,i)/norm(uaR(:,i));
    
    XeR(:,i) = cross(-uaR(:,i),faR(:,i));
    XeR(:,i) = XeR(:,i)/norm(XeR(:,i));
 
%     a = (mark.ShR(I,:) - mark.Cl(I,:))';
%     XeR(:,i) = a - (YeR(:,i)'*a)*YeR(:,i);
%     XeR(:,i) = XeR(:,i)/norm(XeR(:,i));
% 
%     a = (mark.ShL(I,:) - mark.Cl(I,:))';
%     XeL(:,i) = a - (YeL(:,i)'*a)*YeL(:,i);
%     XeL(:,i) = XeL(:,i)/norm(XeL(:,i));

    ZeL(:,i) = cross(XeL(:,i), YeL(:,i));
    ZeR(:,i) = cross(XeR(:,i), YeR(:,i));
    
    RLe = [Xs0L Ys0L Zs0L]'*[XeL(:,i) YeL(:,i) ZeL(:,i)];
    RRe = [Xs0R Ys0R Zs0R]'*[XeR(:,i) YeR(:,i) ZeR(:,i)];
    
    pElr_L(:,i) = RLe*[0 -norm(uaL(:,i)) 0]';
    pElr_R(:,i) = RRe*[0 -norm(uaR(:,i)) 0]';
    
    q2L(i) = -asin(RLe(3,1));
    q3L(i) = -atan2(RLe(3,2),RLe(3,3));
    q1L(i) = atan2(RLe(2,1),RLe(1,1));

    q2R(i) = -asin(RRe(3,1));
    q3R(i) = -atan2(RRe(3,2),RRe(3,3));
    q1R(i) = -atan2(RRe(2,1),RRe(1,1));

    YwL(:,i) = -faL(:,i)/norm(faL(:,i));
    ZwL(:,i) = mark.Wr_exL(I,:) - mark.Wr_inL(I,:);
    ZwL(:,i) = ZwL(:,i)'/norm(ZwL(:,i));
    XwL(:,i) = cross(YwL(:,i), ZwL(:,i));

    YwR(:,i) = -faR(:,i)/norm(faR(:,i));
    ZwR(:,i) = mark.Wr_exR(I,:) - mark.Wr_inR(I,:);
    ZwR(:,i) = ZwR(:,i)'/norm(ZwR(:,i));
    XwR(:,i) = cross(YwR(:,i), ZwR(:,i));
    
    RLw = [XeL(:,i) YeL(:,i) ZeL(:,i)]'*[XwL(:,i) YwL(:,i) ZwL(:,i)];
    RRw = [XeR(:,i) YeR(:,i) ZeR(:,i)]'*[XwR(:,i) YwR(:,i) ZwR(:,i)];
    
    pWrr_L(:,i) = R0v*(pElr_L(:,i) + RLe*RLw*[0 -norm(faL(:,i)) 0]');
    pWrr_R(:,i) = R0v*(pElr_R(:,i) + RRe*RRw*[0 -norm(faR(:,i)) 0]');

%     q5L(i) = -asin(RLw(3,1));
%     q4L(i) = atan2(RLw(3,2),RLw(3,3));
    
%     q4L(i) = acos(YeL(:,i)'*YwL(:,i));
%     q5L(i) = atan2(ZeL(:,i)'*XwL(:,i),XeL(:,i)'*XwL(:,i));

    q5L(i) = -asin(RLw(1,3));
    q4L(i) = -atan2(-RLw(2,3),RLw(3,3));
    
%     q5R(i) = -asin(RRw(3,1));
%     q4R(i) = atan2(-RRw(3,2),RRw(3,3));

    q5R(i) = -asin(RRw(1,3));
    q4R(i) = -atan2(-RRw(2,3),RRw(3,3));   
%     q4R(i) = acos(YeR(:,i)'*YwR(:,i)); 
%     q5R(i) = acos(-XeR(:,i)'*XwR(:,i));
end

q4L = q4L - q4L(1);
q4R = q4R - q4R(1);

q5L = - (q5L - q5L(1));
q5R = - (q5R - q5R(1));
q2L = - q2L;

% 
figure;
subplot(3,1,1)
plot(q1L*180/pi);
subplot(3,1,2)
plot(q2L*180/pi);
subplot(3,1,3)
plot(q3L*180/pi);

figure;
subplot(2,1,1)
plot(q4L*180/pi);
subplot(2,1,2)
plot(q5L*180/pi);

figure;
subplot(3,1,1)
plot(q1R*180/pi);
subplot(3,1,2)
plot(q2R*180/pi);
subplot(3,1,3)
plot(q3R*180/pi);

figure;
subplot(2,1,1)
plot(q4R*180/pi);
subplot(2,1,2)
plot(q5R*180/pi);

%% adjust q to match imu est

% [B,A] = butter(2,0.2);
% q1L_f = filtfilt(B, A, q1L);
% q2L_f = filtfilt(B, A, q2L);
% q3L_f = filtfilt(B, A, q3L);
% q4L_f = filtfilt(B, A, q4L);
% q5L_f = filtfilt(B, A, q5L);  
% 
% q1R_f = filtfilt(B, A, q1R);
% q2R_f = filtfilt(B, A, q2R);
% q3R_f = filtfilt(B, A, q3R);
% q4R_f = filtfilt(B, A, q4R);
% q5R_f = filtfilt(B, A, q5R);  


q1L_f =  q1L;
q2L_f =  q2L;
q3L_f = q3L;
q4L_f = q4L;
q5L_f = q5L;  

q1R_f = q1R;
q2R_f = q2R;
q3R_f =  q3R;
q4R_f =  q4R;
q5R_f =  q5R;  

%% correct q if necessary
close all

badidxsL =[];
badidxsR =[];
tall = 1:length(q1L_f);
tred = setdiff(tall,badidxsL);

if isempty(badidxsL)==0
    q1L_ff = q1L_f(tred);
    q1L_ff = interp1(tred,q1L_ff,tall,'spline');
    q2L_ff = q2L_f(tred);
    q2L_ff = interp1(tred,q2L_ff,tall,'spline');
    q3L_ff = q3L_f(tred);
    q3L_ff = interp1(tred,q3L_ff,tall,'spline');
    q4L_ff = q4L_f(tred);
    q4L_ff = interp1(tred,q4L_ff,tall,'spline');
    q5L_ff = q5L_f(tred); 
    q5L_ff = interp1(tred,q5L_ff,tall,'spline');
else
    q1L_ff = q1L_f;
    q2L_ff = q2L_f;
    q3L_ff = q3L_f;
    q4L_ff = q4L_f;
    q5L_ff = q5L_f; 
end

if isempty(badidxsR)==0
    q1R_ff = q1R_f(tred);
    q1R_ff = interp1(tred,q1R_ff,tall,'spline');
    q2R_ff = q2R_f(tred);
    q2R_ff = interp1(tred,q2R_ff,tall,'spline');
    q3R_ff = q3R_f(tred);
    q3R_ff = interp1(tred,q3R_ff,tall,'spline');
    q4R_ff = q4R_f(tred);
    q4R_ff = interp1(tred,q4R_ff,tall,'spline');
    q5R_ff = q5R_f(tred); 
    q5R_ff = interp1(tred,q5R_ff,tall,'spline');
else
    q1R_ff = q1R_f;
    q2R_ff = q2R_f;
    q3R_ff = q3R_f;
    q4R_ff = q4R_f;
    q5R_ff = q5R_f; 
end

figure
subplot(3,1,1)
plot(q1L_f), hold on
plot(q1L_ff,'r')
subplot(3,1,2)
plot(q2L_f), hold on
plot(q2L_ff,'r')
subplot(3,1,3)
plot(q3L_f), hold on
plot(q3L_ff,'r')

figure
subplot(2,1,1)
plot(q4L_f), hold on
plot(q4L_ff,'r')
subplot(2,1,2)
plot(q5L_f), hold on
plot(q5L_ff,'r')

simq = [q1L_ff' zeros(length(q1L_ff),2) q2L_ff' zeros(length(q1L_ff),2) q3L_ff' zeros(length(q1L_ff),2) q4L_ff' zeros(length(q1L_ff),2) q5L_ff' zeros(length(q1L_ff),2) ...
    q1R_ff' zeros(length(q1L_ff),2) q2R_ff' zeros(length(q1L_ff),2) q3R_ff' zeros(length(q1L_ff),2) q4R_ff' zeros(length(q1L_ff),2) q5R_ff' zeros(length(q1L_ff),2)]; %to check q with animation


q = [q1L_ff' q2L_ff' q3L_ff',q4L_ff',q5L_ff'];
% allq;
% 
% q1L_s = oq(:,1)*180/pi;
% q2L_s = oq(:,2)*180/pi;
% q3L_s = oq(:,3)*180/pi;
% q4L_s = oq(:,4)*180/pi;
% q5L_s = oq(:,5)*180/pi;

q1L_s = q1L_ff'*180/pi;
q2L_s = q2L_ff'*180/pi;
q3L_s = q3L_ff'*180/pi;
q4L_s = q4L_ff'*180/pi;
q5L_s = q5L_ff'*180/pi;

q = [q1R_ff' q2R_ff' q3R_ff',q4R_ff',q5R_ff'];
% allq;

% q1R_s = oq(:,1)*180/pi;
% q2R_s = oq(:,2)*180/pi;
% q3R_s = oq(:,3)*180/pi;
% q4R_s = oq(:,4)*180/pi;
% q5R_s = oq(:,5)*180/pi;

q1R_s = q1R_ff'*180/pi;
q2R_s = q2R_ff'*180/pi;
q3R_s = q3R_ff'*180/pi;
q4R_s = q4R_ff'*180/pi;
q5R_s = q5R_ff'*180/pi;


qR = [q1R_s q2R_s q3R_s q4R_s q5R_s];
qL = [q1L_s q2L_s q3L_s q4L_s q5L_s];

p_wrL_v = (Wr_mpL(idxs,:)-ShL(idxs,:))*0.001;
p_wrR_v = (Wr_mpR(idxs,:)-ShR(idxs,:))*0.001;

% save qp2ac1_jfr2.mat qL qR p_wrL_v p_wrR_v
%% plot q

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





