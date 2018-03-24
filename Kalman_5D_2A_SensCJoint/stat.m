% YessR = YesR.signals.values;
% YessL = YesL.signals.values;
% Yr = YR.signals.values';
% Yl = YL.signals.values';


% %% Upper arm sensor
% figure;
% subplot(2,1,1);
% plot(YessR(:,1:3));
% subplot(2,1,2);
% plot(Yr(1:3,1:sample)');
% 
% 
% figure;
% subplot(2,1,1);
% plot(YessR(:,4:6));
% subplot(2,1,2);
% plot(Yr(4:6,1:sample)');
% 
% figure;
% subplot(2,1,1);
% plot(YessR(:,7:9));
% subplot(2,1,2);
% plot(Yr(7:9,1:sample)');
% 
% %% Forearm sensor
% 
% figure;
% subplot(2,1,1);
% plot(YessR(:,10:12));
% subplot(2,1,2);
% plot(Yr(10:12,1:sample)');
% 
% figure;
% subplot(2,1,1);
% plot(YessR(:,13:15));
% subplot(2,1,2);
% plot(Yr(13:15,1:sample)');
% 
% 
% figure;
% subplot(2,1,1);
% plot(YessR(:,16:18));
% subplot(2,1,2);
% plot(Yr(16:18,1:sample)');
% 
% 
% 
% %% Upper arm sensor
% figure;
% subplot(2,1,1);
% plot(YessL(:,1:3));
% subplot(2,1,2);
% plot(Yl(1:3,1:sample)');
% 
% 
% figure;
% subplot(2,1,1);
% plot(YessL(:,4:6));
% subplot(2,1,2);
% plot(Yl(4:6,1:sample)');
% 
% figure;
% subplot(2,1,1);
% plot(YessL(:,7:9));
% subplot(2,1,2);
% plot(Yl(7:9,1:sample)');
% 
% %% Forearm sensor
% 
% figure;
% subplot(2,1,1);
% plot(YessL(:,10:12));
% subplot(2,1,2);
% plot(Yl(10:12,1:sample)');
% 
% figure;
% subplot(2,1,1);
% plot(YessL(:,13:15));
% subplot(2,1,2);
% plot(Yl(13:15,1:sample)');
% 
% 
% figure;
% subplot(2,1,1);
% plot(YessL(:,16:18));
% subplot(2,1,2);
% plot(Yl(16:18,1:sample)');

%% q plot
% qs = qes.signals.values(:,[1:3:15 22:3:36])*180/pi;

offL = 3;
offR = 19;
qsL = qes.signals.values(offL:end,1:3:15)*180/pi;
qsR = qes.signals.values(offR:end,16:3:end)*180/pi;

for i=1:size(PPL.signals.values,3)
    PL(:,i) = diag(PPL.signals.values(1:3:end,1:3:end,i));
    PR(:,i) = diag(PPR.signals.values(1:3:end,1:3:end,i));
end


% load('q2atest')
load('q2ac1');

% 
sL = min(size(qL,1), size(qsL,1));
% 
sR = min(size(qR,1), size(qsR,1));

h = figure;
set(h,'Name','Shoulder Joints Left');
subplot(3,1,1);
plot(1:sL,qL(1:sL,1),1:sL,qsL(1:sL,1),'r');
title('Sh Abd Left');
subplot(3,1,2);
plot(1:sL,qL(1:sL,2),1:sL,qsL(1:sL,2),'r');
title('Sh Rot Left');
subplot(3,1,3);
plot(1:sL,qL(1:sL,3),1:sL,qsL(1:sL,3),'r');
title('Sh Flex Left');

h = figure;
set(h,'Name','Elbow Joints Left');
subplot(2,1,1);
plot(1:sL,qL(1:sL,4),1:sL,qsL(1:sL,4),'r');
title('El Flex Left');
subplot(2,1,2);
plot(1:sL,qL(1:sL,5),1:sL,qsL(1:sL,5),'r');
title('El Rot Left');

h = figure;
set(h,'Name','Shoulder Joints Right');
subplot(3,1,1);
plot(1:sR,qR(1:sR,1),1:sR,qsR(1:sR,1),'r');
title('Sh Abd Right');
subplot(3,1,2);
plot(1:sR,qR(1:sR,2),1:sR,qsR(1:sR,2),'r');
title('Sh Rot Right');
subplot(3,1,3);
plot(1:sR,qR(1:sR,3),1:sR,qsR(1:sR,3),'r');
title('Sh Flex Right');

h = figure;
set(h,'Name','Elbow Joints Right');
subplot(2,1,1);
plot(1:sR,qR(1:sR,4),1:sR,qsR(1:sR,4),'r');
title('El Flex Right');
subplot(2,1,2);
plot(1:sR,qR(1:sR,5),1:sR,qsR(1:sR,5),'r');
title('El Rot Right');

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

[a, b] = butter(8,0.1);

accffa = filtfilt(a,b,YL.signals.values(:,13:15)/2);

figure
plot(p.signals.values)
% hold on
% plot(accffa);
% 
% 
% [a, b] = butter(8,0.1);
% accfua = filtfilt(a,b,YL.signals.values(:,4:6)/2);
% 
% figure
% plot(qes.signals.values(:,16:18))
% hold on
% plot(accfua);
% 
% qes.signals.values(end-50,16:21)
% qes.signals.values(end-50,37:end)
% figure
% plot(qes.signals.values(:,37:end))