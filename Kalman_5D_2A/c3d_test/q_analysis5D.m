%%

mark = btkGetMarkers(btkReadAcquisition('Human3IMU0302.c3d'));

n = 24730;

start = 24000;

mark = resampleMark(mark);

abdidxs = find(mark.Wr_in(start:end,1)>1100);

El_mp = (mark.El_ex + mark.El_in)/2;
Wr_mp = (mark.Wr_ex + mark.Wr_in)/2;
Wr_mp(abdidxs+start,[1 3]) = mark.Wr_in(abdidxs+start,[1 3]);
Wr_mp(abdidxs+start,2) = mark.Wr_in(abdidxs+start,2)-30;


%% 

Ys0 = (mark.Sh(n,:) - El_mp(n,:))';
Ys0 = Ys0/norm(Ys0);
% a = (mark.Sh(n,:) - mark.Cl(n,:))';
% X0 = a - (Y0'*a)*Y0;
Xs0 = cross(mark.Sh(n,:) - El_mp(n,:), Wr_mp(n,:) - El_mp(n,:));
Xs0 = Xs0'/norm(Xs0);

Zs0 = cross(Xs0, Ys0);

q1 = zeros(1,size(mark.Cl,1)-start);
q2 = zeros(1,size(mark.Cl,1)-start);    
q3 = zeros(1,size(mark.Cl,1)-start);
q4 = zeros(1,size(mark.Cl,1)-start);
q5 = zeros(1,size(mark.Cl,1)-start);

bb = zeros(3,size(mark.Cl,1)-start);

idxs = start:size(mark.Cl,1);
% idxs = start:25660;


for i= idxs
    Yst = (mark.Sh(i,:) - El_mp(i,:))';
    Yst = Yst/norm(Yst);
    
    Xst = cross(mark.Sh(i,:) - El_mp(i,:), Wr_mp(i,:) - El_mp(i,:));
    Xst = Xst'/norm(Xst);
    
    Zst = cross(Xst, Yst);
    
    Rst = [Xs0 Ys0 Zs0]'*[Xst Yst Zst];
    
    
    q2(i-start+1) = -asin(Rst(3,1)); %to change sign
    q1(i-start+1) = atan2(Rst(2,1)/cos(q2(i-start+1)),Rst(1,1)/cos(q2(i-start+1))); %to change sign
    q3(i-start+1) = atan2(Rst(3,2)/cos(q2(i-start+1)),Rst(3,3)/cos(q2(i-start+1)));
    
    Yft = El_mp(i,:) - Wr_mp(i,:);
    Yft = Yft'/norm(Yft);

    Zft = (mark.Wr_in(i,:) - mark.Wr_ex(i,:));
    Zft = Zft'/norm(Zft);
    
    Xft = cross(Yft, Zft);
       
    Rft = [Xst Yst Zst]'*[Xft Yft Zft];
    
    q5(i-start+1) = asin(Rft(1,3)); %to change sign
    q4(i-start+1) = atan2(-Rft(2,3)/cos(q5(i-start+1)),Rft(3,3)/cos(q5(i-start+1))); %to change sign
    
%     
%     q71(i-start+1) = asin(Ret(1,3)); 
%     if abs(cos(q71(i-start+1))) < 1e-2 & i > start
%        q6(i-start+1) = q6(i-start); 
%        
%     else
%        q6(i-start+1) = atan2(-Ret(2,3)/cos(q71(i-start+1)),Ret(3,3)/cos(q71(i-start+1)));
%     end
%     if q6(i-start+1) > 0
%         q6(i-start+1) = q6(i-start+1)-pi;
%     end
%     q7(i-start+1) = atan2(sin(q71(i-start+1)),Ret(3,3)/cos(q6(i-start+1)));
%     if q7(i-start+1) < 0
%         q7(i-start+1) = q7(i-start+1)+pi;
%     end
end

%% Filtering
cutoff = 10;
rate = 50;
Wn = cutoff/(rate*0.5) ;
[B,A] = butter(2,Wn) ;
q1_f = filtfilt(B, A, q1);
q2_f = filtfilt(B, A, q2);
q3_f = filtfilt(B, A, q3);
q4_f = filtfilt(B, A, q4);
q5_f = filtfilt(B, A, q5);  

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
q2_s = -oq(1:plidx_end,2)*180/pi;
q3_s = -oq(1:plidx_end,3)*180/pi;
q4_s = -oq(1:plidx_end,4)*180/pi;
q5_s = -oq(1:plidx_end,5)*180/pi;


 
% q4_s = (q4_s - q4_s(n-start));
% q5_s = q5_s - q5_s(n-start);

% t0 = find(q7_s(12000:end) < 1*180/pi);
% v0 = interp1(t0, q7_s(t0+12000-1), 1:length(12000:length(q7_s)));
% q7_s(12000:end) = v0;

q_s = [q1_s q2_s q3_s q4_s q5_s];

if qplot == 1

h = figure;
set(h,'Name','Shoulder Joints');
subplot(3,1,1);
plot(q1_s);
title('Sh Abd');
subplot(3,1,2);
plot(q2_s);
title('Sh Rot');
subplot(3,1,3);
plot(q3_s);
title('Sh Flex');

h = figure;
set(h,'Name','Elbow Joints');
subplot(2,1,1);
plot(q4_s);
title('El Flex');
subplot(2,1,2);
plot(q5_s);
title('El Rot');

end