% YessR = YesR.signals.values;
% YessL = YesL.signals.values;
% Yr = YR.signals.values';
% Yl = YL.signals.values';

%% q plot
qs = qes.signals.values(:,1:3:end)*180/pi;

offL = 3;
offR = 19;
qsL = qes.signals.values(offL:end,1:3:15)*180/pi;
% qsR = qes.signals.values(offR:end,22:3:36)*180/pi;
qsR = qes.signals.values(offR:end,16:3:30)*180/pi;

% for i=1:size(PPL.signals.values,3)
%     PL(:,i) = diag(PPL.signals.values(1:3:end,1:3:end,i));
%     PR(:,i) = diag(PPR.signals.values(1:3:end,1:3:end,i));
% end


% load('q2atest')
load('qp2ac1_jfr2');

% 
sL = min(size(qL,1), size(qsL,1));
% 
sR = min(size(qR,1), size(qsR,1));

qerrL = [sqrt(sum((qL(1:sL,1) - qsL(1:sL,1)).^2,2)) sqrt(sum((qL(1:sL,2) - qsL(1:sL,2)).^2,2)) sqrt(sum((qL(1:sL,3) - qsL(1:sL,3)).^2,2)) sqrt(sum((qL(1:sL,4) - qsL(1:sL,4)).^2,2)) sqrt(sum((qL(1:sL,5) - qsL(1:sL,1)).^2,5))];

qmL = [mean(qerrL(:,1)) mean(qerrL(:,2)) mean(qerrL(:,3)) mean(qerrL(:,4)) mean(qerrL(:,5))];
    
qcL = [corr2(qL(1:sL,1),qsL(1:sL,1))
    corr2(qL(1:sL,2),qsL(1:sL,2))
    corr2(qL(1:sL,3),qsL(1:sL,3))
    corr2(qL(1:sL,4),qsL(1:sL,4))
    corr2(qL(1:sL,5),qsL(1:sL,5))];

qerrR = [sqrt(sum((qR(1:sR,1) - qsR(1:sR,1)).^2,2)) sqrt(sum((qR(1:sR,2) - qsR(1:sR,2)).^2,2)) sqrt(sum((qR(1:sR,3) - qsR(1:sR,3)).^2,2)) sqrt(sum((qR(1:sR,4) - qsR(1:sR,4)).^2,2)) sqrt(sum((qR(1:sR,5) - qsR(1:sR,1)).^2,5))];

qmR = [mean(qerrR(:,1)) mean(qerrR(:,2)) mean(qerrR(:,3)) mean(qerrR(:,4)) mean(qerrR(:,5))];
   
qcR = [corr2(qR(1:sR,1),qsR(1:sR,1))
    corr2(qR(1:sR,2),qsR(1:sR,2))
    corr2(qR(1:sR,3),qsR(1:sR,3))
    corr2(qR(1:sR,4),qsR(1:sR,4))
    corr2(qR(1:sR,5),qsR(1:sR,5))];


% cd res_ISMAR; save qres_5dresvic.mat qes;save mcres_5dresnvic.mat mL mR cL cR;
% cd ..

qsL(1:sL,3) = qsL(1:sL,3) + qL(20,3); 
t0 = [1:5174 5523:5700 6121:6328 6552:6756 7018:sL];
qL(1:sL,2) = interp1(t0, qL(t0,2), 1:sL);
t0 = [1:5187 5497:5709 6143:6282 6610:6730 7038:7177 7256:7377 7471:sR];
qR(1:sR,2) = interp1(t0, qR(t0,2), 1:sR);


fs = 20;
lwO = 1.2;
lwK = 1.2;

tL = 0.01:0.01:sL*0.01;

h = figure;
set(h,'Name','Upper Limb Joints Left');
subplot(2,1,1);
plot(tL,qL(1:sL,1),'--c','LineWidth', lwO);
hold on
plot(tL,qsL(1:sL,1),'k','LineWidth', lwK);
title('Left Shoulder Abduction Angle','FontSize',fs)
xlabel('Time [s]','FontSize',fs)
ylabel('Angle [deg]','FontSize',fs)
legend('Optical', 'Estimated');
set(gca, 'FontSize', fs);
set(gcf, 'color', 'white');

% es = sprintf('err = %.2f', mean(errL(5883:8207,1)));
% cs = sprintf('R_{oK} = %.2f',corr2(qL(1883:8207,1),qsL(1883:8207,1)));
% annotation(h,'textarrow',[0.376388888888889 0.416666666666667],...
%     [0.895660810184591 0.873428710327106],'TextEdgeColor','none',...
%     'String',{es,cs},...
%     'HeadStyle','none',...
%     'FontSize', fs);
% 
% annotation(h,'rectangle',...
%     [0.411805555555556 0.783057851239669 0.140583333333334 0.14758372493134],...
%     'LineStyle','--',...
%     'LineWidth',1,...
%     'FaceColor','flat');

subplot(2,1,2);
plot(tL,qL(1:sL,2),'--c','LineWidth', lwO);
hold on;
plot(tL,qsL(1:sL,2),'k','LineWidth', lwK);
title('Left Shoulder Rotation Angle','FontSize',fs);
xlabel('Time [s]','FontSize',fs)
ylabel('Angle [deg]','FontSize',fs)
legend('Optical', 'Estimated');
set(gca, 'FontSize', fs);
set(gcf, 'color', 'white');

% es = sprintf('err = %.2f', mean(errL(5883:8207,1)));
% cs = sprintf('R_{oK} = %.2f',corr2(qL(1883:8207,1),qsL(1883:8207,1)));
% annotation(h,'textarrow',[0.376388888888889 0.416666666666667],...
%     [0.895660810184591 0.873428710327106],'TextEdgeColor','none',...
%     'String',{es,cs},...
%     'HeadStyle','none',...
%     'FontSize', fs);
% 
% annotation(h,'rectangle',...
%     [0.411805555555556 0.783057851239669 0.140583333333334 0.14758372493134],...
%     'LineStyle','--',...
%     'LineWidth',1,...
%     'FaceColor','flat');

% saveas(h,'res_ISMAR/fig15DL_resvic','fig');

h = figure;
subplot(2,1,1);
plot(tL,qL(1:sL,3),'--c','LineWidth', lwO);
hold on;
plot(tL,qsL(1:sL,3),'k','LineWidth', lwK);
title('Left Shoulder Flexion Angle','FontSize',fs);
xlabel('Time [s]','FontSize',fs)
ylabel('Angle [deg]','FontSize',fs)
legend('Optical', 'Estimated');
set(gca, 'FontSize', fs);
set(gcf, 'color', 'white');

% es = sprintf('err = %.2f', mean(errL(5883:8207,1)));
% cs = sprintf('R_{oK} = %.2f',corr2(qL(1883:8207,1),qsL(1883:8207,1)));
% annotation(h,'textarrow',[0.376388888888889 0.416666666666667],...
%     [0.895660810184591 0.873428710327106],'TextEdgeColor','none',...
%     'String',{es,cs},...
%     'HeadStyle','none',...
%     'FontSize', fs);
% 
% annotation(h,'rectangle',...
%     [0.411805555555556 0.783057851239669 0.140583333333334 0.14758372493134],...
%     'LineStyle','--',...
%     'LineWidth',1,...
%     'FaceColor','flat');

subplot(2,1,2);
plot(tL,qL(1:sL,4),'--c','LineWidth', lwO);
hold on;
plot(tL,qsL(1:sL,4),'k','LineWidth', lwK);
title('Left Elbow Flexion Angle','FontSize',fs);
xlabel('Time [s]','FontSize',fs)
ylabel('Angle [deg]','FontSize',fs)
legend('Optical', 'Estimated');
set(gca, 'FontSize', fs);
set(gcf, 'color', 'white');
% saveas(h,'res_ISMAR/fig25DL_resnvic','fig');

figure
plot(tL,qL(1:sL,5),'--c','LineWidth', lwO);
hold on;
plot(tL,qsL(1:sL,5),'k','LineWidth', lwK);
title('Left Elbow Flexion Angle','FontSize',fs);
xlabel('Time [s]','FontSize',fs)
ylabel('Angle [deg]','FontSize',fs)
legend('Optical', 'Estimated');
set(gca, 'FontSize', fs);
set(gcf, 'color', 'white');

% es = sprintf('err = %.2f', mean(errL(5883:8207,1)));
% cs = sprintf('R_{oK} = %.2f',corr2(qL(1883:8207,1),qsL(1883:8207,1)));
% annotation(h,'textarrow',[0.376388888888889 0.416666666666667],...
%     [0.895660810184591 0.873428710327106],'TextEdgeColor','none',...
%     'String',{es,cs},...
%     'HeadStyle','none',...
%     'FontSize', fs);
% 
% annotation(h,'rectangle',...
%     [0.411805555555556 0.783057851239669 0.140583333333334 0.14758372493134],...
%     'LineStyle','--',...
%     'LineWidth',1,...
%     'FaceColor','flat');

% h = figure;
% set(h,'Name','Elbow Joints Left');
% subplot(2,1,1);
% plot(1:sL,qL(1:sL,4),1:sL,qsL(1:sL,4),'r');
% title('El Flex Left');
% subplot(2,1,2);
% plot(1:sL,qL(1:sL,5),1:sL,qsL(1:sL,5),'r');
% title('El Rot Left');

tR = 0.01:0.01:sR*0.01;

h = figure;
set(h,'Name','Upper LImb Joints Right');
subplot(2,1,1);
plot(tR,qR(1:sR,1),'--c','LineWidth', lwO);
hold on;
plot(tR,qsR(1:sR,1),'k','LineWidth', lwK);
title('Right Shoulder Abduction Angle','FontSize',fs);
xlabel('Time [s]','FontSize',fs)
ylabel('Angle [deg]','FontSize',fs)
legend('Optical', 'Estimated');
set(gca, 'FontSize', fs);
set(gcf, 'color', 'white');

% es = sprintf('err = %.2f', mean(errL(5883:8207,1)));
% cs = sprintf('R_{oK} = %.2f',corr2(qL(1883:8207,1),qsL(1883:8207,1)));
% annotation(h,'textarrow',[0.376388888888889 0.416666666666667],...
%     [0.895660810184591 0.873428710327106],'TextEdgeColor','none',...
%     'String',{es,cs},...
%     'HeadStyle','none',...
%     'FontSize', fs);
%     
% 
% annotation(h,'rectangle',...
%     [0.411805555555556 0.783057851239669 0.140583333333334 0.14758372493134],...
%     'LineStyle','--',...
%     'LineWidth',1,...
%     'FaceColor','flat');

subplot(2,1,2);
plot(tR,qR(1:sR,2),'--c','LineWidth', lwO);
hold on;
plot(tR,qsR(1:sR,2),'k','LineWidth', lwK);
title('Right Shoulder Rotation Angle','FontSize',fs);
xlabel('Time [s]','FontSize',fs)
ylabel('Angle [deg]','FontSize',fs)
legend('Optical', 'Estimated');
set(gca, 'FontSize', fs);
set(gcf, 'color', 'white');
% saveas(h,'res_ISMAR/fig15DRs_resvic','fig');

% es = sprintf('err = %.2f', mean(errL(5883:8207,1)));
% cs = sprintf('R_{oK} = %.2f',corr2(qL(1883:8207,1),qsL(1883:8207,1)));
% annotation(h,'textarrow',[0.376388888888889 0.416666666666667],...
%     [0.895660810184591 0.873428710327106],'TextEdgeColor','none',...
%     'String',{es,cs},...
%     'HeadStyle','none',...
%     'FontSize', fs);
% 
% annotation(h,'rectangle',...
%     [0.411805555555556 0.783057851239669 0.140583333333334 0.14758372493134],...
%     'LineStyle','--',...
%     'LineWidth',1,...
%     'FaceColor','flat');

h = figure;
subplot(2,1,1);
plot(tR,qR(1:sR,3),'--c','LineWidth', lwO);
hold on;
plot(tR,qsR(1:sR,3),'k','LineWidth', lwK);
title('Right Shoulder Flexion Angle','FontSize',fs);
xlabel('Time [s]','FontSize',fs)
ylabel('Angle [deg]','FontSize',fs)
legend('Optical', 'Estimated');
set(gca, 'FontSize', fs);
set(gcf, 'color', 'white');

% es = sprintf('err = %.2f', mean(errL(5883:8207,1)));
% cs = sprintf('R_{oK} = %.2f',corr2(qL(1883:8207,1),qsL(1883:8207,1)));
% annotation(h,'textarrow',[0.376388888888889 0.416666666666667],...
%     [0.895660810184591 0.873428710327106],'TextEdgeColor','none',...
%     'String',{es,cs},...
%     'HeadStyle','none',...
%     'FontSize', fs);
% 
% annotation(h,'rectangle',...
%     [0.411805555555556 0.783057851239669 0.140583333333334 0.14758372493134],...
%     'LineStyle','--',...
%     'LineWidth',1,...
%     'FaceColor','flat');

subplot(2,1,2);
plot(tR,qR(1:sR,4),'--c','LineWidth', lwO);
hold on;
plot(tR,qsR(1:sR,4),'k','LineWidth', lwK);
title('Right Elbow Flexion Angle','FontSize',fs);
xlabel('Time [s]','FontSize',fs)
ylabel('Angle [deg]','FontSize',fs)
legend('Optical', 'Estimated');
set(gca, 'FontSize', fs);
set(gcf, 'color', 'white');
% saveas(h,'res_ISMAR/fig25DR_resvic','fig');

figure
plot(tR,qR(1:sR,5),'--c','LineWidth', lwO);
hold on;
plot(tR,qsR(1:sR,5),'k','LineWidth', lwK);
title('Left Elbow Flexion Angle','FontSize',fs);
xlabel('Time [s]','FontSize',fs)
ylabel('Angle [deg]','FontSize',fs)
legend('Optical', 'Estimated');
set(gca, 'FontSize', fs);
set(gcf, 'color', 'white');

% es = sprintf('err = %.2f', mean(errL(5883:8207,1)));
% cs = sprintf('R_{oK} = %.2f',corr2(qL(1883:8207,1),qsL(1883:8207,1)));
% annotation(h,'textarrow',[0.376388888888889 0.416666666666667],...
%     [0.895660810184591 0.873428710327106],'TextEdgeColor','none',...
%     'String',{es,cs},...
%     'HeadStyle','none',...
%     'FontSize', fs);
% 
% annotation(h,'rectangle',...
%     [0.411805555555556 0.783057851239669 0.140583333333334 0.14758372493134],...
%     'LineStyle','--',...
%     'LineWidth',1,...
%     'FaceColor','flat');

% h = figure;
% set(h,'Name','Elbow Joints Right');
% subplot(2,1,1);
% plot(1:sR,qR(1:sR,4),1:sR,qsR(1:sR,4),'r');
% title('El Flex Right');
% subplot(2,1,2);
% plot(1:sR,qR(1:sR,5),1:sR,qsR(1:sR,5),'r');
% title('El Rot Right');

% errL = [sqrt(sum((qL(1:sL,1) - qsL(1:sL,1)).^2,2)) sqrt(sum((qL(1:sL,2) - qsL(1:sL,2)).^2,2)) sqrt(sum((qL(1:sL,3) - qsL(1:sL,3)).^2,2)) sqrt(sum((qL(1:sL,4) - qsL(1:sL,4)).^2,2)) sqrt(sum((qL(1:sL,5) - qsL(1:sL,1)).^2,5))];
% 
% mL = [mean(errL(:,1)) mean(errL(:,2)) mean(errL(:,3)) mean(errL(:,4)) mean(errL(:,5))];
%     
% cL = [corr2(qL(1:sL,1),qsL(1:sL,1))
%     corr2(qL(1:sL,2),qsL(1:sL,2))
%     corr2(qL(1:sL,3),qsL(1:sL,3))
%     corr2(qL(1:sL,4),qsL(1:sL,4))
%     corr2(qL(1:sL,5),qsL(1:sL,5))];
% 
% errR = [sqrt(sum((qR(1:sR,1) - qsR(1:sR,1)).^2,2)) sqrt(sum((qR(1:sR,2) - qsR(1:sR,2)).^2,2)) sqrt(sum((qR(1:sR,3) - qsR(1:sR,3)).^2,2)) sqrt(sum((qR(1:sR,4) - qsR(1:sR,4)).^2,2)) sqrt(sum((qR(1:sR,5) - qsR(1:sR,1)).^2,5))];
% 
% mR = [mean(errR(:,1)) mean(errR(:,2)) mean(errR(:,3)) mean(errR(:,4)) mean(errR(:,5))];
%    
% cR = [corr2(qR(1:sR,1),qsR(1:sR,1))
%     corr2(qR(1:sR,2),qsR(1:sR,2))
%     corr2(qR(1:sR,3),qsR(1:sR,3))
%     corr2(qR(1:sR,4),qsR(1:sR,4))
%     corr2(qR(1:sR,5),qsR(1:sR,5))];

% h = figure;
% plot(tL(1:12300), qes.signals.values(1:12300,16:18),'LineWidth', lwO)
% title('Left Upperarm Sensor Position in Sensor Frame','FontSize',fs);
% xlabel('Time [s]','FontSize',fs)
% ylabel('Position [m]','FontSize',fs)
% legend('x position', 'y position','z position');
% set(gca, 'FontSize', fs);
% set(gcf, 'color', 'white');
% saveas(h,'res_ISMAR/sens_poseULresnaiv','fig');
% 
% h = figure;
% plot(tL(1:12300), qes.signals.values(1:12300,19:21),'LineWidth', lwO)
% title('Left Forearm Sensor Position in Sensor Frame','FontSize',fs);
% xlabel('Time [s]','FontSize',fs)
% ylabel('Position [m]','FontSize',fs)
% legend('x position', 'y position','z position');
% set(gca, 'FontSize', fs);
% set(gcf, 'color', 'white');
% saveas(h,'res_ISMAR/sens_poseFLresvic','fig');
% 
% 
% qes.signals.values(11500,16:21)
% qes.signals.values(11500,37:end)
% 
% h = figure;
% plot(tR(1:12130), qes.signals.values(1:12130,37:39),'LineWidth', lwO)
% title('Right Upperarm Sensor Position in Sensor Frame','FontSize',fs);
% xlabel('Time [s]','FontSize',fs)
% ylabel('Position [m]','FontSize',fs)
% legend('x position', 'y position','z position');
% set(gca, 'FontSize', fs);
% set(gcf, 'color', 'white');
% saveas(h,'res_ISMAR/sens_poseURresvic','fig');
% % colormap(gray)
% 
% h = figure;
% plot(tR(1:12130), qes.signals.values(1:12130,40:end),'LineWidth', lwO)
% title('Right Forearm Sensor Position in Sensor Frame','FontSize',fs);
% xlabel('Time [s]','FontSize',fs)
% ylabel('Position [m]','FontSize',fs)
% legend('x position', 'y position','z position');
% set(gca, 'FontSize', fs);
% set(gcf, 'color', 'white');
% saveas(h,'res_ISMAR/sens_poseFRNresvic','fig');
% colormap(gray)

%% chk positions

% load armsL
luaR = arms(3);
luaL = arms(1);
lfaR = arms(4);
lfaL = arms(2);

q_es_L = qsL*pi/180;% qes.signals.values(1:12130,1:3:13);
q_es_R = qsR*pi/180;% qes.signals.values(1:12130,16:3:28);
allL = 12100;%min(length(q_es_L),length(q_es_R));
p_wrL = zeros(3,allL);
p_wrR = zeros(3,allL);
p_wrL_v0 = zeros(3,size(p_wrL_v,1));
p_wrR_v0 = zeros(3,size(p_wrR_v,1));

T0L = [1 0 0 0;0 0 -1 0;0 1 0 0; 0 0 0 1];
T0R = [-1 0 0 0;0 0 1 0;0 1 0 0;0 0 0 1];
R00 = [-1 0 0; 0 0 1; 0 -1 0];
T00 = [[R00 [0 0 0]']; 0 0 0 1];

for i=1:allL
    
    TL = modDHL_ext(q_es_L(i,:),luaL,lfaL);
    TR = modDHR_ext(q_es_R(i,:),luaR,lfaR);
    yl = T00 * T0L * TL(1:4,1:4) * TL(1:4,5:8) * TL(1:4,9:12) * TL(1:4,13:16) * TL(1:4,17:20);
    yr = T00 * T0R * TR(1:4,1:4) * TR(1:4,5:8) * TR(1:4,9:12) * TR(1:4,13:16) * TR(1:4,17:20);
    p_wrL(:,i) = yl(1:3,4);
    p_wrR(:,i) = yr(1:3,4);
    
%     TL = modDHL_ext(qL(i,:)*pi/180,luaL,lfaL);
%     TR = modDHR_ext(qR(i,:)*pi/180,luaR,lfaR);
%     yl = T00 * T0L * TL(1:4,1:4) * TL(1:4,5:8) * TL(1:4,9:12) * TL(1:4,13:16) * TL(1:4,17:20);
%     yr = T00 * T0R * TR(1:4,1:4) * TR(1:4,5:8) * TR(1:4,9:12) * TR(1:4,13:16) * TR(1:4,17:20);
%     p_wrL_v0(:,i) = yl(1:3,4);
%     p_wrR_v0(:,i) = yr(1:3,4);
%     
    p_wrL_v0(:,i) = R00*p_wrL_v(i,:)';
    p_wrR_v0(:,i) = R00*p_wrR_v(i,:)';
    
    
end
delta0L = p_wrL(:,1) - p_wrL_v0(:,1); 
p_wrL  = p_wrL - repmat(delta0L,1,allL);
pErrL = p_wrL - p_wrL_v0(:,1:allL);
perrL = pw_norm(pErrL,2);
pmL = mean(perrL);

delta0R = p_wrR(:,1) - p_wrR_v0(:,1);
p_wrR  = p_wrR - repmat(delta0R,1,allL);
pErrR = p_wrR - p_wrR_v0(:,1:allL);
perrR = pw_norm(pErrR,2);
pmR = mean(perrR);

%% plot q

close all

figdir = 'C:\Users\Alessandro\Dropbox\Jacket_MPU (1)\pubblicazioni\JFR_calibration\figures';
tp = (0:allL-1)*0.01;
ylbs = {'q_1 [deg]','q_2 [deg]','q_3 [deg]','q_4 [deg]'};
fs = 30;
lwO = 2;
lwK = 2;

h = figure('Position',[0 0 1520 1080],'color','none');
for i=1:4
    subplot(4,1,i);
    plot(tp,qL(1:allL,i),'-.','Color',[0.5 0.5 0.5],'LineWidth', lwO);
    hold on;
    plot(tp,qsL(1:allL,i),'Color',[0 0 0],'LineWidth', lwK);
%     plot(tp,pErrL(i,:),'k','LineWidth', lwK);
    xlim([1,125])
    if i~=4
        set(gca,'XTickLabel','')
    end
    if i==1
        title('Left arm joint angles with K2+K3','FontSize',fs);
    end
    if i==4
        xlabel('Time [s]','FontSize',fs)
    end
    ylim([-80 150])
    ylabel(ylbs{i},'FontSize',fs)
    legend('Vicon', 'Filter','Location','EastOutside');
    set(gca, 'FontSize', fs,'YTick',-70:70:140,'YTickLabel',{'-70','0','70','140'});
end
% export_fig([figdir filesep 'qL_k2k3.pdf'])



h = figure('Position',[0 0 1520 1080],'color','none');
for i=1:4
    subplot(4,1,i);
    plot(tp,qR(1:allL,i),'-.','Color',[0.5 0.5 0.5],'LineWidth', lwO);
    hold on;
    plot(tp,qsR(1:allL,i),'Color',[0 0 0],'LineWidth', lwK);
%     plot(tp,pErrL(i,:),'k','LineWidth', lwK);
    xlim([1,125])
    if i~=4
        set(gca,'XTickLabel','')
    end
    if i==1
        title('Right arm joint angles with K2+K3','FontSize',fs);
    end
    if i==4
        xlabel('Time [s]','FontSize',fs)
    end
    ylim([-80 150])
    ylabel(ylbs{i},'FontSize',fs)
    legend('Vicon', 'Filter','Location','EastOutside');
    set(gca, 'FontSize', fs,'YTick',-70:70:140,'YTickLabel',{'-70','0','70','140'});
end
% export_fig([figdir filesep 'qR_k2k3.pdf'])



%% plot pos

close all

figdir = 'C:\Users\Alessandro\Dropbox\Jacket_MPU (1)\pubblicazioni\JFR_calibration\figures';
tp = (0:allL-1)*0.01;
ylbs = {'x_0 [m]','y_0 [m]','z_0 [m]'};
fs = 30;
lwO = 2;
lwK = 2;
h = figure('Position',[0 0 1520 1080],'color','none');
for i=1:3
    subplot(3,1,i);
    plot(tp,p_wrL_v0(i,1:allL),'-.','Color',[0.5 0.5 0.5],'LineWidth', lwO);
    hold on;
    plot(tp,p_wrL(i,:),'Color',[0 0 0],'LineWidth', lwK);
%     plot(tp,pErrL(i,:),'k','LineWidth', lwK);
    xlim([1,125])
    if i~=3
        set(gca,'XTickLabel','')
    end
    if i==1
        title('Left Wrist Position with hand settings','FontSize',fs);
    end
    if i==3
        xlabel('Time [s]','FontSize',fs)
    end
    ylim([-0.8 0.8])
    ylabel(ylbs{i},'FontSize',fs)
    legend('Vicon', 'Filter','Location','EastOutside');
    set(gca, 'FontSize', fs);
end
% export_fig([figdir filesep 'wrLpos_hand.pdf'])

h = figure('Position',[0 0 1520 1080],'color','none');
for i=1:3
    subplot(3,1,i);
    plot(tp,p_wrR_v0(i,1:allL),'-.','Color',[0.5 0.5 0.5],'LineWidth', lwO);
    hold on;
    plot(tp,p_wrR(i,:),'Color',[0 0 0],'LineWidth', lwK);
%     plot(tp,pErrL(i,:),'k','LineWidth', lwK);
    xlim([1,125])
    if i~=3
        set(gca,'XTickLabel','')
    end
    if i==1
        title('Rigth Wrist Position with hand settings','FontSize',fs);
    end
    if i==3
        xlabel('Time [s]','FontSize',fs)
    end
    ylim([-0.8 0.8])
    ylabel(ylbs{i},'FontSize',fs)
    legend('Vicon', 'Filter','Location','EastOutside');
    set(gca, 'FontSize', fs);
end
% export_fig([figdir filesep 'wrRpos_hand.pdf'])

%% plot p of sensors
close all
figdir = 'C:\Users\Alessandro\Dropbox\Jacket_MPU (1)\pubblicazioni\JFR_calibration\figures';
set(0,'defaulttextinterpreter','tex')
as = p.signals.values(1:allL,:);

fs = 30;
lwO = 2.5;
lwK = 2.5;

allL = 12100;
tp = (0:allL-1)*0.01;

mkr = {'-','--','-.',':'};
h = figure('Position',[0 0 1520 1080],'color','none');
     
ylbs={'x [m]','|y| [m]','z [m]'};
yl = [0.01 0.25 0.01];
for i=1:3
    subplot(3,1,i)
%     s{i} = p.signals.values(1:allL,(i-1)+1:3*i);
    for j=1:4
        hold on
        if i==2
            plot(tp,abs(as(:,i+3*(j-1))),mkr{j},'Color',[0 0 0],'LineWidth',lwO)
            ylim([0.18 0.25])
        else
            plot(tp,as(:,i+3*(j-1)),mkr{j},'Color',[0 0 0],'LineWidth',lwO)
            ylim([-0.01 0.01])
        end
    end
    if i==1
        title('Sensors positions with k2+k3','FontSize',fs);
    end
    if i~=3
        set(gca,'XTickLabel','')
    end
    if i==3
        xlabel('Time [s]','FontSize',fs)
    end
    xlim([1,125])
    ylabel(ylbs{i},'FontSize',fs)
    legend({'s1','s2','s3','s4'},'Location','EastOutside');
    set(gca, 'FontSize', fs);
end
% export_fig([figdir filesep 'fig5DUsL_k3.pdf'])    

