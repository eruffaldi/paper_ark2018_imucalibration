% mark = btkGetMarkers(btkReadAcquisition('Human3IMU Cal 04.c3d'));

% mark = btkGetMarkers(btkReadAcquisition('Human3IMU0302.c3d'));

load mark7d.mat

marks =mark;
el_flex = 3840;
n = 24500;

start = 24500;

mark = resampleMark(mark);

abdidxs = find(mark.Wr_in(start:end,1)>1100);

if mode == 5
    mark.Sh = repmat(mean(mark.Sh(n:end,:)),size(mark.Sh,1),1);
end

El_mp = (mark.El_ex + mark.El_in)/2;
Wr_mp = (mark.Wr_ex + mark.Wr_in)/2;
Wr_mp(abdidxs+start,[1 3]) = mark.Wr_in(abdidxs+start,[1 3]);
Wr_mp(abdidxs+start,2) = mark.Wr_in(abdidxs+start,2)-30;


Yc0 = [0 0 -1]'; % Clav anteposition
% Xc0 = (mark.Sh(n,:) - mark.Cl(n,:))';
a = -(mark.Sh(n,:) - mark.Cl(n,:))';
Xc0 = a - (Yc0'*a)*Yc0;
% Xc0 = -(mark.Sh(n,:) - mark.Cl(n,:))';
Xc0 = Xc0/norm(Xc0);

Zc0 = cross(Xc0, Yc0); %Clav depression

q1 = zeros(1,size(mark.Cl,1)-start);
q2 = zeros(1,size(mark.Cl,1)-start);    
q3 = zeros(1,size(mark.Cl,1)-start);
q4 = zeros(1,size(mark.Cl,1)-start);
q5 = zeros(1,size(mark.Cl,1)-start);
q6 = zeros(1,size(mark.Cl,1)-start);
q7 = zeros(1,size(mark.Cl,1)-start);

bb = zeros(3,size(mark.Cl,1)-start);

idxs = start:size(mark.Cl,1);
% idxs = start:25660;

Xct2 = [-1 0 0]';
Yct2 = [0 0 -1]';
Zct2 = [0 -1 0]';
% 
% Xct3 = - cross(mark.Sh(n,:) - El_mp(n,:), Wr_mp(n,:) - El_mp(n,:)); %shoulder flexion
% Xct3 = Xct3'/norm(Xct3);
% Yct3 = -(mark.Sh(n,:) - El_mp(n,:));
% Yct3 = Yct3'/norm(Yct3);
% Zct3 = cross(Xct3, Yct3);


for i= idxs
    
    Yct = [0 0 -1]'; % Clav anteposition
    Yct = Yct/norm(Yct);
    
    a = -(mark.Sh(i,:) - mark.Cl(i,:))';
    
    Xct = -(mark.Sh(i,:)-mark.Cl(i,:))';
    Xct1 = a - (Yct'*a)*Yct;
    Xct = Xct/norm(Xct);
    Xct1 = Xct1/norm(Xct1);
    
    Zct = cross(Xct, Yct); %Clav depression
    
    Xct_out(:,i-start+1) = Xct;
    Yct_out(:,i-start+1) = Yct;
    Zct_out(:,i-start+1) = Zct;
    
    Rct = [Xc0 Yc0 Zc0]'*[Xct Yct Zct];
    
    RR{i-start+1} = Rct;
    
    q2(i-start+1) = asin(Rct(2,1));
    q1(i-start+1) = atan2(-Rct(3,1)/cos(q2(i-start+1)),Rct(1,1)/cos(q2(i-start+1)));
%     q2(i-start+1) = atan2(Rct(1,3)/cos(qx(i)),Rct(3,3)/cos(qx(i)));

    Yot = -(mark.Sh(i,:) - El_mp(i,:)); % shoulder extra/intra-rotation
    Yot = Yot'/norm(Yot);
    
    Xot = - cross(mark.Sh(i,:) - El_mp(i,:), Wr_mp(i,:) - El_mp(i,:)); %shoulder flexion
    Xot = Xot'/norm(Xot);

    
    Zot = cross(Xot, Yot); % shoulder abduction
    Zot = Zot/norm(Zot);

    Yot1 = Yot;
    Xot1 = -(mark.El_ex(i,:) - mark.El_in(i,:))' - (Yot1'*(mark.El_ex(i,:) - mark.El_in(i,:))')*Yot1;
    Xot1 = Xot1/norm(Xot1);
    Zot1 = cross(Xot1, Yot1); % shoulder abduction
    
    Rst1 = [Xct2 Yct2 Zct2]'*[Xot1 Yot1 Zot1];
    
    q41(i-start+1) = -asin(Rst1(3,1));
    
    Xot_out(:,i-start+1) = Xot;
    Yot_out(:,i-start+1) = Yot;
    Zot_out(:,i-start+1) = Zot;
    Rst = [Xct2 Yct2 Zct2]'*[Xot Yot Zot];
    
    q4(i-start+1) = -asin(Rst(3,1));
    q3(i-start+1) = atan2(Rst(2,1)/cos(q4(i-start+1)),Rst(1,1)/cos(q4(i-start+1)));
    q5(i-start+1) = atan2(Rst(3,2)/cos(q4(i-start+1)),Rst(3,3)/cos(q4(i-start+1))); 
%     
%     a = (Xot - Yot*(Yot'*Xct3)) - (Xct3 - Yot*(Yot'*Xct3));
%     b = cross(Yot,Xct3);
%     c = (Xct3 - Yot*(Yot'*Xct3)) - (Xot - Yot*(Yot'*Xct3));
%     
%     t1(1) = -b(1) + sqrt(b(1)^2 - 4*a(1)*c(1))./2*a(1);
%     t1(2) = -b(2) + sqrt(b(2)^2 - 4*a(2)*c(2))./2*a(2);
%     t1(3) = -b(3) + sqrt(b(3)^2 - 4*a(3)*c(3))./2*a(3);
%     
%     t2(1) = -b(1) - sqrt(b(1)^2 - 4*a(1)*c(1))./2*a(1);
%     t2(2) = -b(2) - sqrt(b(2)^2 - 4*a(2)*c(2))./2*a(2);
%     t2(3) = -b(3) - sqrt(b(3)^2 - 4*a(3)*c(3))./2*a(3);
%     
%     ct = (1-t2(3)^2)/(1+t2(3)^2);
%     st = 2*t2(3)/(1+t2(3));
%     q4r(i-start+1) = 2*atan2(st, ct);
    
    
    
    Yft = Wr_mp(i,:) - El_mp(i,:); % elbow supination
    Yft = Yft'/norm(Yft);

%     Xft = - (mark.Wr_ex(i,:) - mark.Wr_in(i,:)); %elbow flexion
    Xftd = -(Wr_mp(i,:) - mark.Wr_in(i,:))'; %elbow flexion
    Xft = Xftd - (Yft'*Xftd)*Yft;
    Xft = Xft/norm(Xft);
%     Xet = Xst;

    Zft = cross(Xft, Yft); %Dummy y rot
    
    Xft_out(:,i-start+1) = Xft;
    Yft_out(:,i-start+1) = Yft;
    Zft_out(:,i-start+1) = Zft;
    
    Ret = [Xot Yot Zot]'*[Xft Yft Zft];
    Ret_out{i-start+1} = Ret;
    
%     qy(i) = asin(Ret(1,3)); 
%     q4(i) = atan2(-Ret(2,3)/cos(qy(i)),Ret(3,3)/cos(qy(i)));
%     q5(i) = atan2(-Ret(1,2)/cos(qy(i)),Ret(1,1)/cos(qy(i)));
% c

    q71(i-start+1) = asin(Ret(1,3)); 
    if abs(cos(q71(i-start+1))) < 1e-2 & i > start
       q6(i-start+1) = q6(i-start); 
       
    else
       q6(i-start+1) = atan2(-Ret(2,3)/cos(q71(i-start+1)),Ret(3,3)/cos(q71(i-start+1)));
    end
    if q6(i-start+1) > 0
        q6(i-start+1) = q6(i-start+1)-pi;
    end
    q7(i-start+1) = atan2(sin(q71(i-start+1)),Ret(3,3)/cos(q6(i-start+1)));
    if q7(i-start+1) < 0
        q7(i-start+1) = q7(i-start+1)+pi;
    end
    
end

cutoff = 10;
rate = 50;
Wn = cutoff/(rate*0.5) ;
[B,A] = butter(2,Wn) ;
q1_f = filtfilt(B, A, q1);
q2_f = filtfilt(B, A, q2);
q3_f = filtfilt(B, A, q3);
q4_f = filtfilt(B, A, q41);
q5_f = filtfilt(B, A, q5);  
q6_f = filtfilt(B, A, q6);
q7_f = filtfilt(B, A, q7);

% h = figure;
% set(h,'Name','Shoulder Joints');
% subplot(3,1,1);
% plot(q1_f);
% title('Sh Abd');
% subplot(3,1,2);
% plot(q2_f);
% title('Sh Rot');
% subplot(3,1,3);
% plot(q3_f);
% title('Sh Flex');
% 
% h = figure;
% set(h,'Name','Elbow Joints');
% subplot(2,1,1);
% plot(q4_f);
% title('El Flex');
% subplot(2,1,2);
% plot(q5_f);
% title('El Rot');

%% Smooth
% plidx_end =10410;

allq;
plidx_end =length(oq);
q1_s = oq(1:plidx_end,1)*180/pi;
q2_s = oq(1:plidx_end,2)*180/pi;
q3_s = oq(1:plidx_end,3)*180/pi;
q4_s = oq(1:plidx_end,4)*180/pi;
q5_s = oq(1:plidx_end,5)*180/pi;
q6_s = oq(1:plidx_end,6)*180/pi;
q7_s = oq(1:plidx_end,7)*180/pi;

q1_s = -(q1_s - q1_s(1));
% q2_s = (q2_s - q2_s(1));
q2_s = -q2_s;

% q4_s = -(q4_s - q4_s(1));
q4_s = -q4_s;

q4t = [q4_s(1:1000)+(q4_s(1000)-q4_s(1)); q4_s(1001:end)];
t0 = [1:269 1059:length(q4t)];
interp1(t0, q4t(t0), 1:length(q4t));

q4_s = q4t;

q5_s = q5_s - q5_s(1);
q6_s = q6_s - q6_s(1);

q7_s = -(q7_s - q7_s(1));

t0 = find(q7_s(10000:end) < 1*180/pi);
v0 = interp1(t0, q7_s(t0+10000-1), 1:length(10000:length(q7_s)));
q7_s(10000:end) = v0;


t0 = [1:11500 11710:length(q7_s)];
v0 = interp1(t0, q7_s(t0), 1:length(q7_s));
q7_s = v0';

q_s = [q1_s q2_s q3_s q4_s q5_s q6_s q7_s];

if qplot == 1
h = figure;
set(h,'Name','Scapular Joints');
subplot(2,1,1);
plot(q1_s);
title('Scap Ant');
subplot(2,1,2);
plot(q2_s);
title('Scap Depr');


h = figure;
set(h,'Name','Shoulder Joints');
subplot(3,1,1);
plot(q3_s);
title('Sh Abd');
subplot(3,1,2);
plot(q4_s);
title('Sh Rot');
subplot(3,1,3);
plot(q5_s);
title('Sh Flex');

h = figure;
set(h,'Name','Elbow Joints');
subplot(2,1,1);
plot(q6_s);
title('El Flex');
subplot(2,1,2);
plot(q7_s);
title('El Rot');

end