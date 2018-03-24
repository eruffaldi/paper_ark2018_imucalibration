% YessR = YesR.signals.values;
% YessL = YesL.signals.values;
% Yr = YR.signals.values';
% Yl = YL.signals.values';

%% q plot
qs = qes.signals.values(:,1:3:end)*180/pi;

offL = 3;
offR = 19;
qsL = qes.signals.values(offL:end,1:3:15)*180/pi;
qsR = qes.signals.values(offR:end,22:3:36)*180/pi;

% for i=1:size(PPL.signals.values,3)
%     PL(:,i) = diag(PPL.signals.values(1:3:end,1:3:end,i));
%     PR(:,i) = diag(PPR.signals.values(1:3:end,1:3:end,i));
% end


% load('q2atest')
% load('q2ac1')
load('q2ac1_jfr');

% 
sL = min(size(qL,1), size(qsL,1));
% 
sR = min(size(qR,1), size(qsR,1));

errL = [sqrt(sum((qL(1:sL,1) - qsL(1:sL,1)).^2,2)) sqrt(sum((qL(1:sL,2) - qsL(1:sL,2)).^2,2)) sqrt(sum((qL(1:sL,3) - qsL(1:sL,3)).^2,2)) sqrt(sum((qL(1:sL,4) - qsL(1:sL,4)).^2,2)) sqrt(sum((qL(1:sL,5) - qsL(1:sL,1)).^2,5))];

mL = [mean(errL(:,1)) mean(errL(:,2)) mean(errL(:,3)) mean(errL(:,4)) mean(errL(:,5))];
    
cL = [corr2(qL(1:sL,1),qsL(1:sL,1))
    corr2(qL(1:sL,2),qsL(1:sL,2))
    corr2(qL(1:sL,3),qsL(1:sL,3))
    corr2(qL(1:sL,4),qsL(1:sL,4))
    corr2(qL(1:sL,5),qsL(1:sL,5))];

errR = [sqrt(sum((qR(1:sR,1) - qsR(1:sR,1)).^2,2)) sqrt(sum((qR(1:sR,2) - qsR(1:sR,2)).^2,2)) sqrt(sum((qR(1:sR,3) - qsR(1:sR,3)).^2,2)) sqrt(sum((qR(1:sR,4) - qsR(1:sR,4)).^2,2)) sqrt(sum((qR(1:sR,5) - qsR(1:sR,1)).^2,5))];

mR = [mean(errR(:,1)) mean(errR(:,2)) mean(errR(:,3)) mean(errR(:,4)) mean(errR(:,5))];
   
cR = [corr2(qR(1:sR,1),qsR(1:sR,1))
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

% % saveas(h,'res_ISMAR/fig15DL_resvic','fig');

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

h = figure;
plot(tL(1:12300), qes.signals.values(1:12300,16:18),'LineWidth', lwO)
title('Left Upperarm Sensor Position in Sensor Frame','FontSize',fs);
xlabel('Time [s]','FontSize',fs)
ylabel('Position [m]','FontSize',fs)
legend('x position', 'y position','z position');
set(gca, 'FontSize', fs);
set(gcf, 'color', 'white');
% saveas(h,'res_ISMAR/sens_poseULresnaiv','fig');

h = figure;
plot(tL(1:12300), qes.signals.values(1:12300,19:21),'LineWidth', lwO)
title('Left Forearm Sensor Position in Sensor Frame','FontSize',fs);
xlabel('Time [s]','FontSize',fs)
ylabel('Position [m]','FontSize',fs)
legend('x position', 'y position','z position');
set(gca, 'FontSize', fs);
set(gcf, 'color', 'white');
% saveas(h,'res_ISMAR/sens_poseFLresvic','fig');


qes.signals.values(11500,16:21)
qes.signals.values(11500,37:end)

h = figure;
plot(tR(1:12130), qes.signals.values(1:12130,37:39),'LineWidth', lwO)
title('Right Upperarm Sensor Position in Sensor Frame','FontSize',fs);
xlabel('Time [s]','FontSize',fs)
ylabel('Position [m]','FontSize',fs)
legend('x position', 'y position','z position');
set(gca, 'FontSize', fs);
set(gcf, 'color', 'white');
% saveas(h,'res_ISMAR/sens_poseURresvic','fig');
% colormap(gray)

h = figure;
plot(tR(1:12130), qes.signals.values(1:12130,40:end),'LineWidth', lwO)
title('Right Forearm Sensor Position in Sensor Frame','FontSize',fs);
xlabel('Time [s]','FontSize',fs)
ylabel('Position [m]','FontSize',fs)
legend('x position', 'y position','z position');
set(gca, 'FontSize', fs);
set(gcf, 'color', 'white');
% saveas(h,'res_ISMAR/sens_poseFRNresvic','fig');
% colormap(gray)

%% limbs lengths figs PAPER

close all
figdir = 'C:\Users\Alessandro\Dropbox\Jacket_MPU (1)\pubblicazioni\JFR_calibration\figures';

lual = qes.signals.values(:,31);
lfal = qes.signals.values(:,32);
luar = qes.signals.values(:,33);
lfar = qes.signals.values(:,34);

ta = (0:size(lual,1)-1)*0.01;

lual_v = 0.307; lfal_v = 0.271; luar_v = 0.322; lfar_v = 0.263;

ylbs = {'x_0 [m]','y_0 [m]','z_0 [m]'};
fs = 30;
lwO = 2.5;
lwK = 2.5;

%left arm
h = figure('Position',[0 0 1920 1080],'color','none');

plot(ta,ones(length(ta),1)*lual_v,'-.','Color',[0.6 0.6 0.6],'LineWidth', lwO);
hold on
plot(ta,lual,'-.','Color',[0 0 0],'LineWidth', lwK);
plot(ta,ones(length(ta),1)*lfal_v,'Color',[0.6 0.6 0.6],'LineWidth', lwO);
plot(ta,lfal,'Color',[0 0 0],'LineWidth', lwK);
title('Left limbs lengths estimation with Vicon setting','FontSize',fs);
xlabel('Time [s]','FontSize',fs),ylabel('Length [m]','FontSize',fs)
legend('a_{3,l} optical', 'a_{3,l} estimated', 'd_{5,l} optical','d_{5,l} estimated');
ylim([0.2 0.45])
set(gca, 'FontSize', fs);
export_fig([figdir filesep 'L_ana_vic.pdf'])
 

%right arm
h = figure('Position',[0 0 1920 1080],'color','none');

plot(ta,ones(length(ta),1)*luar_v,'-.','Color',[0.6 0.6 0.6],'LineWidth', lwO);
hold on
plot(ta,luar,'-.','Color',[0 0 0],'LineWidth', lwK);
plot(ta,ones(length(ta),1)*lfar_v,'Color',[0.6 0.6 0.6],'LineWidth', lwO);
plot(ta,lfar,'Color',[0 0 0],'LineWidth', lwK);
title('Right limbs lengths estimation with Vicon setting','FontSize',fs);
xlabel('Time [s]','FontSize',fs),ylabel('Length [m]','FontSize',fs)
legend('a_{3,r} optical', 'a_{3,r} estimated', 'd_{5,r} optical','d_{5,r} estimated');
ylim([0.2 0.45])
set(gca, 'FontSize', fs);
export_fig([figdir filesep 'R_ana_vic.pdf'])

