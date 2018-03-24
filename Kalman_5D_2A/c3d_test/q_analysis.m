mark = btkGetMarkers(btkReadAcquisition('Human3IMU Cal 04.c3d'));

n_ind = 5300;
el_flex = 3840;

El_mp = (mark.El_ex + mark.El_in)/2;
Wr_mp = (mark.Wr_ex + mark.Wr_in)/2;

Ys0 = -(mark.Sh(n_ind,:) - El_mp(n_ind,:)); % shoulder extra/intra-rotation
Ys0 = Ys0'/norm(Ys0);

Xs0 = - cross(mark.Sh(n_ind,:) - El_mp(n_ind,:), Wr_mp(n_ind,:) - El_mp(n_ind,:)); %shoulder flexion
Xs0 = Xs0'/norm(Xs0);

Zs0 = cross(Xs0, Ys0); % shoulder abduction
Zs0 = Zs0/norm(Zs0);

Ze0 = Wr_mp(n_ind,:) - El_mp(n_ind,:); % elbow supination
Ze0 = Ze0'/norm(Ze0);

Xe0 = - (mark.Wr_ex(n_ind,:) - mark.Wr_in(n_ind,:)); %elbow flexion
% Xe0 = Xs0;
Xe0 = Xe0'/norm(Xe0);

Ye0 = cross(Ze0, Xe0); %Dummy y rot

q1 = zeros(1,size(mark.Cl,1));
q2 = zeros(1,size(mark.Cl,1));  
q3 = zeros(1,size(mark.Cl,1));
q4 = zeros(1,size(mark.Cl,1));
q5 = zeros(1,size(mark.Cl,1));


for i=1:size(mark.Cl,1)

    Yst = -(mark.Sh(i,:) - El_mp(i,:)); % shoulder extra/intra-rotation
    Yst = Yst'/norm(Yst);
    
    Xst = - cross(mark.Sh(i,:) - El_mp(i,:), Wr_mp(i,:) - El_mp(i,:)); %shoulder flexion
    Xst = Xst'/norm(Xst);
    
    Zst = cross(Xst, Yst); % shoulder abduction
    Zst = Zst/norm(Zst);

    Rst = [Xs0 Ys0 Zs0]'*[Xst Yst Zst];
    
    q2(i) = -asin(Rst(3,1));
    q1(i) = atan2(Rst(2,1)/cos(q2(i)),Rst(1,1)/cos(q2(i)));
    q3(i) = atan2(Rst(3,2)/cos(q2(i)),Rst(3,3)/cos(q2(i))); 
    
    Zet = Wr_mp(i,:) - El_mp(i,:); % elbow supination
    Zet = Zet'/norm(Zet);

    Xet = - (mark.Wr_ex(i,:) - mark.Wr_in(i,:)); %elbow flexion
    Xet = Xet'/norm(Xet);
%     Xet = Xst;

    Yet = cross(Zet, Xet); %Dummy y rot
    
    Ret = [Xst Yst Zst]'*[Xet Yet Zet];
    
%     qy(i) = asin(Ret(1,3)); 
%     q4(i) = atan2(-Ret(2,3)/cos(qy(i)),Ret(3,3)/cos(qy(i)));
%     q5(i) = atan2(-Ret(1,2)/cos(qy(i)),Ret(1,1)/cos(qy(i)));
% 

    q5(i) = -asin(Ret(1,2)); 
    q4(i) = atan2(Ret(3,2)/cos(q5(i)),Ret(2,2)/cos(q5(i)));

end

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
q2_s = oq(1:plidx_end,2)*180/pi;
q3_s = oq(1:plidx_end,3)*180/pi;
q4_s = oq(1:plidx_end,4)*180/pi;
q5_s = oq(1:plidx_end,5)*180/pi;
% q4_s = q4_s + 90;
q4_s = q4_s - q4_s(n_ind);
% q5_s = q5_s + 90;
q5_s = q5_s - q5_s(n_ind);
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

