
mark = btkGetMarkers(btkReadAcquisition('Human2A4IMU Cal 04.c3d'));

mark.Imu2L = [mark.Imu2L(1:12754,:); mark.C_16(12755:15959,:);mark.Imu2L(15960:end,:)];
mark.Imu1R = [mark.C_15(1:16373,:); mark.Imu1R(16674:end,:)];

n = 601;
start = 9228;

El_mpL = (mark.El_exL + mark.El_inL)/2;
Wr_mpL = (mark.Wr_exL + mark.Wr_inL)/2;
ShL = mark.ShL; %- repmat([0 0 45],size(mark.ShL,1),1);

El_mpR = (mark.El_exR + mark.El_inR)/2;
Wr_mpR = (mark.Wr_exR + mark.Wr_inR)/2;
ShR = mark.ShR; % - repmat([0 0 45],size(mark.ShR,1),1);

Y0R = [0 0 1]';
Y0L = [0 0 1]';

% aL = (ShL(n,:)' - mark.Cl(n,:)');
% X0L = aL - (Y0L'*aL)*Y0L;
% 
% aR = (ShR(n,:)' - mark.Cl(n,:)');
% X0R = aR - (Y0R'*aR)*Y0R;
X0L = -cross(Wr_mpL(n,:)-El_mpL(n,:),ShL(n,:)-El_mpL(n,:))';
X0R = cross(Wr_mpR(n,:)-El_mpR(n,:),ShR(n,:)-El_mpR(n,:))';

X0L = X0L/norm(X0L);
X0R = X0R/norm(X0R);

Z0L = cross(X0L, Y0L);
Z0R = cross(X0R, Y0R);

n0L = [X0L Y0L Z0L];
n0R = [X0R Y0R Z0R];


%%
for i=1:size(mark.Cl,1)
    
%     aL = (ShL(i,:)' - mark.Cl(i,:)');
%     X0L = aL - (Y0L'*aL)*Y0L;
%     
%     aR = (ShR(i,:)' - mark.Cl(i,:)');
%     X0R = aR - (Y0R'*aR)*Y0R;
%     
%     X0L = X0L/norm(X0L);
%     X0R = X0R/norm(X0R);
%     
%     Z0L = cross(X0L, Y0L);
%     Z0R = cross(X0R, Y0R);
%     
%     n0L = [X0L Y0L Z0L];
%     n0R = [X0R Y0R Z0R];
    
    % 16790 possible n-pose
    %P1R(i,:) = n0R'*(mark.Imu1R(16790,:)' - ShR(i,:))*1e-3;
    P2R(i,:) = n0R'*(mark.Imu2R(i,:) - ShR(i,:))'*1e-3;
    
    %P1L(i,:) = n0L'*(mark.Imu1L(i,:)' - ShL(i,:))*1e-3;
    P2L(i,:) = n0L'*(mark.Imu2L(i,:) - ShL(i,:))'*1e-3;
     
end

%     P2(i,:) = n0'*(mark.IMU1(i,:) - Cl(i,:))'*1e-3;
%     P1(i,:) = n0'*(mark.IMU2(i,:) - Cl(i,:))'*1e-3;
%     PSh(i,:) = n0'*(Sh(i,:) - Cl(i,:))'*1e-3;
%     PEl(i,:) = n0'*(El_mp(i,:) - Cl(i,:))'*1e-3;
    

Ps2L = P2L(start:end,:);
Ps2L_s = allp(Ps2L);

Ps2R = P2R(start:end,:);
Ps2R_s = allp(Ps2R);

% Ps1 = P1(n:end,:);
% Ps1_s = allp(Ps1);
% PsEl = PEl(n:end,:);
% PsEl_s = allp(PsEl);
% PsSh = PSh(n:end,:);
% PsSh_s = allp(PsSh);
%%
% 
qsL = qes.signals.values(:,1:3:15);
qsR = qes.signals.values(:,16:3:end);

p1L = p.signals.values(:,1:3);
p2L = p.signals.values(:,4:6);
p1R = p.signals.values(:,7:9);
p2R = p.signals.values(:,10:12);

[thL, thR] = humanarm5D2A(3);

% f1 = th.Sens.Sifx{1};
f2L = thL.Sens.Sifx{2};
f2R = thR.Sens.Sifx{2};



for i=1:size(qsL,1)
    
    S2L = f2L(qsL(i,5));
    S2R = f2R(qsR(i,5));
    
    DHLs = thL.DHall(qsL(i,:));
    DHRs = thR.DHall(qsR(i,:));
    
    TS02L = DHLs{1}*DHLs{2}*DHLs{3}*DHLs{4}*[[S2L(1:3,1:3) p2L(i,:)']; [0 0 0 1]];
    TS02R = DHRs{1}*DHRs{2}*DHRs{3}*DHRs{4}*[[S2R(1:3,1:3) p2R(i,:)']; [0 0 0 1]];
%     
%     for j=1:thL.numJoint
%         PL{1,j,1} = DHLs{j};
%         PR{1,j,1} = DHRs{j};
%         if j == 1
%             DHLpre = thL.T0;
%             DHRpre = thR.T0;
%         else
%             DHLpre = PL{1,j-1,2};
%             DHRpre = PR{1,j-1,2};
%         end
%         PL{1,j,2} = DHLpre*PL{1,j,1};
%         PR{1,j,2} = DHRpre*PR{1,j,1};
%     end
    
    
%     parL = thL.Sens.par(2);
%     TS02L = PL{1,parL,2}*S2L;
     P2K5L(:,i) = TS02L(1:3,4);
    
%     parR = thR.Sens.par(1);
%     TS02R = PR{1,parR,2}*S2R;
     P2K5R(:,i) = TS02R(1:3,4);
       
end 
g = 1;

if g
    figure;
    subplot(2,1,1);
    plot(Ps2L_s);
    subplot(2,1,2);
    plot(P2K5L');
    
    figure;
    subplot(2,1,1);
    plot(Ps2R_s);
    subplot(2,1,2);
    plot(P2K5R');
end

offL = 98;
P2K5Lof = P2K5L(:,offL:end);

sL = min(size(P2K5Lof,2),size(Ps2L_s,1));

offR = 119;
P2K5Rof = P2K5R(:,offR:end);

sR = min(size(P2K5Rof,2),size(Ps2R_s,1));

P2K5Lofn(1,:) = P2K5Lof(1,:) - repmat((P2K5Lof(1,1) - Ps2L_s(1,1)),1,sL);
P2K5Lofn(2,:) = P2K5Lof(2,:) - repmat((P2K5Lof(2,1) - Ps2L_s(1,2)),1,sL);
P2K5Lofn(3,:) = P2K5Lof(3,:) - repmat((P2K5Lof(3,1) - Ps2L_s(1,3)),1,sL);
P2K5Rofn(1,:) = P2K5Rof(1,:) - repmat((P2K5Rof(1,1) - Ps2R_s(1,1)),1,sR);
P2K5Rofn(2,:) = P2K5Rof(2,:) - repmat((P2K5Rof(2,1) - Ps2R_s(1,2)),1,sR);
P2K5Rofn(3,:) = P2K5Rof(3,:) - repmat((P2K5Rof(3,1) - Ps2R_s(1,3)),1,sR);

if g
    figure;
    subplot(3,1,1)
    plot(Ps2L_s(1:sL,1));
    hold on
    plot(P2K5Lof(1,1:sL)','r');
    subplot(3,1,2)
    plot(Ps2L_s(1:sL,2));
    hold on
    plot(P2K5Lof(2,1:sL)','r');
    subplot(3,1,3)
    plot(Ps2L_s(1:sL,3));
    hold on
    plot(P2K5Lof(3,1:sL)','r');

    figure;
    subplot(3,1,1)
    plot(Ps2R_s(1:sR,1));
    hold on
    plot(P2K5Rof(1,1:sR)','r');
    subplot(3,1,2)
    plot(Ps2R_s(1:sR,2));
    hold on
    plot(P2K5Rof(2,1:sR)','r');
    subplot(3,1,3)
    plot(Ps2R_s(1:sR,3));
    hold on
    plot(P2K5Rof(3,1:sR)','r');
    
    
    figure;
    subplot(3,1,1)
    plot(Ps2L_s(1:sL,1));
    hold on
    plot(P2K5Lofn(1,1:sL)','r');
    subplot(3,1,2)
    plot(Ps2L_s(1:sL,2));
    hold on
    plot(P2K5Lofn(2,1:sL)','r');
    subplot(3,1,3)
    plot(Ps2L_s(1:sL,3));
    hold on
    plot(P2K5Lofn(3,1:sL)','r');

    figure;
    subplot(3,1,1)
    plot(Ps2R_s(1:sR,1));
    hold on
    plot(P2K5Rofn(1,1:sR)','r');
    subplot(3,1,2)
    plot(Ps2R_s(1:sR,2));
    hold on
    plot(P2K5Rofn(2,1:sR)','r');
    subplot(3,1,3)
    plot(Ps2R_s(1:sR,3));
    hold on
    plot(P2K5Rofn(3,1:sR)','r');
end

errL = Ps2L_s(1:sL,:) - P2K5Lof(:,1:sL)';
errR = Ps2R_s(1:sR,:) - P2K5Rof(:,1:sR)';

nerrL = sqrt(sum(errL.*errL,2));
nerrR = sqrt(sum(errR.*errR,2));

if g
    figure;
    subplot(2,1,1)
    plot(errL)
    subplot(2,1,2)
    plot(errR)
    
    figure;
    subplot(2,1,1)
    plot(nerrL)
    subplot(2,1,2)
    plot(nerrR)
end

mean(nerrL)
mean(nerrR)

% P2K5L = P2K5L - repmat([0 0 1.5]',1,size(P2K5L,2));
% P2K5R = P2K5R - repmat([0 0 1.5]',1,size(P2K5R,2));
% 
% figure;
% subplot(2,1,1);
% plot(Ps2L_s);
% subplot(2,1,2);
% plot(P2K5L');
% 
% figure;
% subplot(2,1,1);
% plot(Ps2R_s);
% subplot(2,1,2);
% plot(P2K5R');

% P1K7 = P1K7 - repmat([0 0 1.5]',1,size(P1K7,2));
% P2K7 = P2K7 - repmat([0 0 1.5]',1,size(P2K7,2));
% P1K5 = P1K5 - repmat([0 0 1.5]',1,size(P1K5,2));

% 
% PShK7 = PShK7 - repmat([0 0 1.5]',1,size(PShK7,2));
% PElK7 = PElK7 - repmat([0 0 1.5]',1,size(PElK7,2));
% PShK5 = PShK5 - repmat([0 0 1.5]',1,size(PShK5,2));
% PElK5 = PElK5 - repmat([0 0 1.5]',1,size(PElK5,2));
% 
% %%
% 
% fs = 20;
% lw = 1.2;
% 
% off = 151; %177
% 
% Ps2_sc = Ps2_s(off:end,:);
% sc = 13000:size(P2K7,2);
% psc = 1:13000;
% 
% s = min([size(P2K7,2) size(Ps2_s(off:end,:),1)]);
% t = 0.01:0.01:0.01*s;
% % h=figure;
% % set(h,'Name','7D')
% % subplot(3,1,1);
% % plot(1:s,P2K7(1,1:s),1:s,Ps2_s(off:off+s-1,1));
% % subplot(3,1,2);
% % plot(1:s,P2K7(2,1:s),1:s,Ps2_s(off:off+s-1,2));
% % subplot(3,1,3);
% % plot(1:s,P2K7(3,1:s),1:s,Ps2_s(off:off+s-1,3));
% % 
% % s = min([size(P2K5,2) size(Ps2_s(off:end,:),1)])
% % 
% % h1=figure;
% % set(h1,'Name','5D')
% % subplot(3,1,1);
% % plot(1:s,P2K5(1,1:s),1:s,Ps2_s(off:off+s-1,1));
% % subplot(3,1,2);
% % plot(1:s,P2K5(2,1:s),1:s,Ps2_s(off:off+s-1,2));
% % subplot(3,1,3);
% % plot(1:s,P2K5(3,1:s),1:s,Ps2_s(off:off+s-1,3));
% 
% 
% h0=figure;
% set(h0,'Name','S2')
% subplot(3,1,1);
% plot(t,Ps2_s(off:off+s-1,1),'--r','LineWidth', lw);
% hold on
% plot(t,P2K5(1,1:s),'k','LineWidth', lw)
% hold on,
% plot(t,P2K7(1,1:s),'b','LineWidth', lw);
% ylim([-0.1 0.8])
% title('Forearm Sensor Position Comparison','FontSize',fs)
% % xlabel('Samples','FontSize',fs)
% ylabel('Position x [m]','FontSize',fs)
% legend('Optical', '5DoFs','7DoFs');
% set(gca, 'FontSize', fs);
% set(gcf, 'color', 'white');
% 
% subplot(3,1,2);
% plot(t,Ps2_s(off:off+s-1,2),'--r','LineWidth', lw)
% hold on;
% plot(t,P2K5(2,1:s),'b','LineWidth', lw)
% hold on
% plot(t,P2K7(2,1:s),'k','LineWidth', lw);
% ylim([-0.6 0.3])
% % title('Forearm Sensor Position Comparison [y]','FontSize',fs)
% % xlabel('Samples','FontSize',fs)
% ylabel('Position y [m]','FontSize',fs)
% legend('Optical', '5DoFs','7DoFs');
% set(gca, 'FontSize', fs);
% set(gcf, 'color', 'white');
% 
% subplot(3,1,3);
% plot(t,Ps2_s(off:off+s-1,3),'--r','LineWidth', lw);
% hold on
% plot(t,P2K5(3,1:s),'b','LineWidth', lw);
% hold on;
% plot(t,P2K7(3,1:s),'k','LineWidth', lw);
% ylim([-0.5 0.3])
% % title('Forearm Sensor Position Comparison [z]','FontSize',fs)
% xlabel('Time [s]','FontSize',fs)
% ylabel('Position z [m]','FontSize',fs)
% legend('Optical', '5DoFs','7DoFs');
% set(gca, 'FontSize', fs);
% set(gcf, 'color', 'white');
% 
% 
% h0=figure;
% set(h0,'Name','S1')
% subplot(3,1,1);
% plot(t,Ps1_s(off:off+s-1,1),'--r','LineWidth', lw);
% hold on
% plot(t,P1K5(1,1:s),'k','LineWidth', lw)
% hold on,
% plot(t,P1K7(1,1:s),'b','LineWidth', lw);
% ylim([0.1 0.5])
% title('Upperarm Sensor Position Comparison','FontSize',fs)
% % xlabel('Samples','FontSize',fs)
% ylabel('Position x [m]','FontSize',fs)
% legend('Optical', '5DoFs','7DoFs');
% set(gca, 'FontSize', fs);
% set(gcf, 'color', 'white');
% 
% subplot(3,1,2);
% plot(t,Ps1_s(off:off+s-1,2),'--r','LineWidth', lw)
% hold on;
% plot(t,P1K5(2,1:s),'b','LineWidth', lw)
% hold on
% plot(t,P1K7(2,1:s),'k','LineWidth', lw);
% ylim([-0.4 0.1])
% % title('Upperarm Sensor Position Comparison [y]','FontSize',fs)
% % xlabel('Samples','FontSize',fs)
% ylabel('Position y [m]','FontSize',fs)
% legend('Optical', '5DoFs','7DoFs');
% set(gca, 'FontSize', fs);
% set(gcf, 'color', 'white');
% 
% subplot(3,1,3);
% plot(t,Ps1_s(off:off+s-1,3),'--r','LineWidth', lw);
% hold on
% plot(t,P1K5(3,1:s),'b','LineWidth', lw);
% hold on;
% plot(t,P1K7(3,1:s),'k','LineWidth', lw);
% ylim([-0.3 0.2])
% % title('Upperarm Sensor Position Comparison [z]','FontSize',fs)
% xlabel('Time [s]','FontSize',fs)
% ylabel('Position z [m]','FontSize',fs)
% legend('Optical', '5DoFs','7DoFs');
% set(gca, 'FontSize', fs);
% set(gcf, 'color', 'white');
% 
% 
% % h1=figure;
% % set(h1,'Name','S1')
% % subplot(3,1,1);
% % plot(1:s,P1K5(1,1:s),1:s,Ps1_s(off:off+s-1,1)); hold on,
% % plot(1:s,P1K7(1,1:s),'r');
% % subplot(3,1,2);
% % plot(1:s,P1K5(2,1:s),1:s,Ps1_s(off:off+s-1,2));hold on,
% % plot(1:s,P1K7(2,1:s),'r');
% % subplot(3,1,3);
% % plot(1:s,P1K5(3,1:s),1:s,Ps1_s(off:off+s-1,3));hold on,
% % plot(1:s,P1K7(3,1:s),'r');
% % 
% 
% h0=figure;
% set(h0,'Name','Sh')
% subplot(3,1,1);
% plot(t,PsSh_s(off:off+s-1,1),'--r','LineWidth', lw);
% hold on
% plot(t,PShK5(1,1:s),'k','LineWidth', lw)
% hold on,
% plot(t,PShK7(1,1:s),'b','LineWidth', lw);
% ylim([0.1 0.2])
% title('Shoulder Sensor Position Comparison','FontSize',fs)
% % xlabel('Samples','FontSize',fs)
% ylabel('Position x [m]','FontSize',fs)
% legend('Optical', '5DoFs','7DoFs');
% set(gca, 'FontSize', fs);
% set(gcf, 'color', 'white');
% 
% subplot(3,1,2);
% plot(t,Ps2_s(off:off+s-1,2),'--r','LineWidth', lw)
% hold on;
% plot(t,P2K5(2,1:s),'b','LineWidth', lw)
% hold on
% plot(t,P2K7(2,1:s),'k','LineWidth', lw);
% ylim([-0.6 0.1])
% % title('Forearm Sensor Position Comparison [y]','FontSize',fs)
% % xlabel('Samples','FontSize',fs)
% ylabel('Position y [m]','FontSize',fs)
% legend('Optical', '5DoFs','7DoFs');
% set(gca, 'FontSize', fs);
% set(gcf, 'color', 'white');
% 
% subplot(3,1,3);
% plot(t,Ps2_s(off:off+s-1,3),'--r','LineWidth', lw);
% hold on
% plot(t,P2K5(3,1:s),'b','LineWidth', lw);
% hold on;
% plot(t,P2K7(3,1:s),'k','LineWidth', lw);
% ylim([-0.5 0.2])
% % title('Forearm Sensor Position Comparison [z]','FontSize',fs)
% xlabel('Time [s]','FontSize',fs)
% ylabel('Position z [m]','FontSize',fs)
% legend('Optical', '5DoFs','7DoFs');
% set(gca, 'FontSize', fs);
% set(gcf, 'color', 'white');
% 
% 
% 
% % h2=figure;
% % set(h2,'Name','Sh')
% % subplot(3,1,1);
% % plot(1:s,PShK5(1,1:s),1:s,PsSh_s(off:off+s-1,1)); hold on,
% % plot(1:s,PShK7(1,1:s),'r');
% % subplot(3,1,2);
% % plot(1:s,PShK5(2,1:s),1:s,PsSh_s(off:off+s-1,2));hold on,
% % plot(1:s,PShK7(2,1:s),'r');
% % subplot(3,1,3);
% % plot(1:s,PShK5(3,1:s),1:s,PsSh_s(off:off+s-1,3));hold on,
% % plot(1:s,PShK7(3,1:s),'r');
% 
% % h3=figure;
% % set(h3,'Name','El')
% % subplot(3,1,1);
% % plot(1:s,PElK5(1,1:s),1:s,PsEl_s(off:off+s-1,1)); hold on,
% % plot(1:s,PElK7(1,1:s),'r');
% % subplot(3,1,2);
% % plot(1:s,PElK5(2,1:s),1:s,PsEl_s(off:off+s-1,2));hold on,
% % plot(1:s,PElK7(2,1:s),'r');
% % subplot(3,1,3);
% % plot(1:s,PElK5(3,1:s),1:s,PsEl_s(off:off+s-1,3));hold on,
% % plot(1:s,PElK7(3,1:s),'r');
% 
% h0=figure;
% set(h0,'Name','El')
% subplot(3,1,1);
% plot(t,PsEl_s(off:off+s-1,1),'--r','LineWidth', lw);
% hold on
% plot(t,PElK5(1,1:s),'k','LineWidth', lw)
% hold on,
% plot(t,PElK7(1,1:s),'b','LineWidth', lw);
% ylim([0 0.6])
% title('Elbow Position Comparison','FontSize',fs)
% % xlabel('Samples','FontSize',fs)
% ylabel('Position x [m]','FontSize',fs)
% legend('Optical', '5DoFs','7DoFs');
% set(gca, 'FontSize', fs);
% set(gcf, 'color', 'white');
% 
% subplot(3,1,2);
% plot(t,PsEl_s(off:off+s-1,2),'--r','LineWidth', lw)
% hold on;
% plot(t,PElK5(2,1:s),'b','LineWidth', lw)
% hold on
% plot(t,PElK7(2,1:s),'k','LineWidth', lw);
% ylim([-0.4 0.1])
% % title('Elbow Position Comparison [y]','FontSize',fs)
% % xlabel('Samples','FontSize',fs)
% ylabel('Position y [m]','FontSize',fs)
% legend('Optical', '5DoFs','7DoFs');
% set(gca, 'FontSize', fs);
% set(gcf, 'color', 'white');
% 
% subplot(3,1,3);
% plot(t,PsEl_s(off:off+s-1,3),'--r','LineWidth', lw);
% hold on
% plot(t,PElK5(3,1:s),'b','LineWidth', lw);
% hold on;
% plot(t,PElK7(3,1:s),'k','LineWidth', lw);
% ylim([-0.4 0.1])
% % title('Elbow Position Comparison [z]','FontSize',fs)
% xlabel('Time [s]','FontSize',fs)
% ylabel('Position z [m]','FontSize',fs)
% legend('Optical', '5DoFs','7DoFs');
% set(gca, 'FontSize', fs);
% set(gcf, 'color', 'white');
% 
% 
% 
% %%
% clc
% errS25 = mean(sqrt(sum((P2K5' - Ps2_s(off:off+s-1,:)).^2,2)))
% errS27 = mean(sqrt(sum((P2K7' - Ps2_s(off:off+s-1,:)).^2,2)))
% 
% errS15 = mean(sqrt(sum((P1K5' - Ps1_s(off:off+s-1,:)).^2,2)))
% errS17 = mean(sqrt(sum((P1K7' - Ps1_s(off:off+s-1,:)).^2,2)))
% 
% errEl5 = mean(sqrt(sum((PElK5' - PsEl_s(off:off+s-1,:)).^2,2)))
% errEl7 = mean(sqrt(sum((PElK7' - PsEl_s(off:off+s-1,:)).^2,2)))
% 
% errSh5 = mean(sqrt(sum((PShK5' - PsSh_s(off:off+s-1,:)).^2,2)))
% errSh7 = mean(sqrt(sum((PShK7' - PsSh_s(off:off+s-1,:)).^2,2)))
% 
% err5 = (errS25 + errS15 + errEl5 + errSh5)*0.25
% err7 = (errS27 + errS17 + errEl7 + errSh7)*0.25
% 
% cS25 = corr2(P2K5', Ps2_s(off:off+s-1,:))
% cS27 = corr2(P2K7', Ps2_s(off:off+s-1,:))
% 
% cS15 = corr2(P1K5', Ps1_s(off:off+s-1,:))
% cS17 = corr2(P1K7', Ps1_s(off:off+s-1,:))
% 
% cSh5 = corr2(PShK5', PsSh_s(off:off+s-1,:))
% cSh7 = corr2(PShK7', PsSh_s(off:off+s-1,:))
% 
% cEl5 = corr2(PElK5', PsEl_s(off:off+s-1,:))
% cEl7 = corr2(PElK7', PsEl_s(off:off+s-1,:))
% 
% 
% c5 = mean([cS25 cS15 cSh5 cEl5])
% c7 = mean([cS27 cS17 cSh7 cEl7])
% 
% % err5s = mean(sqrt(sum((P2K5(:,sc)' - Ps2_sc(sc,:)).^2,2)));
% % err7s = mean(sqrt(sum((P2K7(:,sc)' - Ps2_sc(sc,:)).^2,2)));
% % 
% % c5s = corr2(P2K5(:,sc)', Ps2_s(sc,:));
% % c7s = corr2(P2K7(:,sc)', Ps2_s(sc,:));
% 
% % err5p = mean(sqrt(sum((P2K5(:,psc)' - Ps2_sc(psc,:)).^2,2)))
% % err7p = mean(sqrt(sum((P2K7(:,psc)' - Ps2_sc(psc,:)).^2,2)))
% % 
% % c5p = corr2(P2K5(:,psc)', Ps2_s(psc,:))
% % c7p = corr2(P2K7(:,psc)', Ps2_s(psc,:))