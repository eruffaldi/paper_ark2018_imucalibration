ind = 8285;
% ind = 12447;
% ind = 10970;
sample = size(qesd,1);

h = figure;
set(h,'Name','Scapular Joints');
subplot(3,1,1);
plot(1:sample,q1_s(511:511+sample-1),1:sample, qesd(:,1),'r')
title('Scapular Anteposition Angle')
xlabel('Sample')
ylabel('Deg')
subplot(3,1,2);
plot(1:sample,q2_s(517:517+sample-1),1:sample, qesd(:,2),'r')
title('Scapular Depression Angle')
xlabel('Sample')
ylabel('Deg')


h = figure;
set(h,'Name','Shoulder Joints');
subplot(3,1,1);
plot(1:sample,q3_s(517:517+sample-1),1:sample, qesd(:,3),'r')
title('Shoulder Abduction Angle')
xlabel('Sample')
ylabel('Deg')
subplot(3,1,2);
plot(1:sample,q4_s(517:517+sample-1),1:sample, qesd(:,4),'r')
title('Shoulder Rotation Angle')
xlabel('Sample')
ylabel('Deg')
subplot(3,1,3);
plot(1:sample,q5_s(517:517+sample-1),1:sample, qesd(:,5),'r')
title('Shoulder Flexion Angle')
xlabel('Sample')
ylabel('Deg')



h = figure;
set(h,'Name','Elbow Joints');
xlabel('Sample')
ylabel('Deg')
subplot(2,1,1);
plot(1:sample,q6_s(517:517+sample-1),1:sample, qesd(:,6),'r')
title('Elbow Flexion Angle')
xlabel('Sample')
ylabel('Deg')
subplot(2,1,2);
plot(1:sample,q7_s(517:517+sample-1),1:sample, qesd(:,7),'r')
title('Elbow Rotation Angle')
xlabel('Sample')
ylabel('Deg')


m = [mean(abs(q1_s(517:517+sample-1) - qesd(:,1)))
    mean(abs(q2_s(517:517+sample-1) - qesd(:,2)))
    mean(abs(q3_s(517:517+sample-1) - qesd(:,3)))
    mean(abs(q4_s(517:517+sample-1) - qesd(:,4)))
    mean(abs(q5_s(517:517+sample-1) - qesd(:,5)))
    mean(abs(q6_s(517:517+sample-1) - qesd(:,6)))
    mean(abs(q7_s(517:517+sample-1) - qesd(:,7)))]'