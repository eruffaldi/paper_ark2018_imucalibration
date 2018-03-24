sample = size(qesd,1);


h = figure;
set(h,'Name','Shoulder Joints');
subplot(3,1,1);
plot(1:sample,q3_s(511:511+sample-1),1:sample, qesd(:,1),'r')
title('Shoulder Abduction Angle')
xlabel('Sample')
ylabel('Deg')
subplot(3,1,2);
plot(1:sample,q4_s(511:511+sample-1),1:sample, qesd(:,2),'r')
title('Shoulder Rotation Angle')
xlabel('Sample')
ylabel('Deg')
subplot(3,1,3);
plot(1:sample,q5_s(511:511+sample-1),1:sample, qesd(:,3),'r')
title('Shoulder Flexion Angle')
xlabel('Sample')
ylabel('Deg')



h = figure;
set(h,'Name','Elbow Joints');
xlabel('Sample')
ylabel('Deg')
subplot(2,1,1);
plot(1:sample,q6_s(511:511+sample-1),1:sample, qesd(:,4),'r')
title('Elbow Flexion Angle')
xlabel('Sample')
ylabel('Deg')
subplot(2,1,2);
plot(1:sample,q7_s(511:511+sample-1),1:sample, qesd(:,5),'r')
title('Elbow Rotation Angle')
xlabel('Sample')
ylabel('Deg')



% h = figure;
% set(h,'Name','Shoulder Joints');
% subplot(3,1,1);
% plot(1:ind+1,q1_s(1854:1854+ind),1:ind+1, qesd(:,1),'r')
% title('Shoulder Abduction Angle')
% xlabel('Sample')
% ylabel('Deg')
% subplot(3,1,2);
% plot(1:ind+1,q2_s(1854:1854+ind),1:ind+1, qesd(:,2),'r')
% title('Shoulder Rotation Angle')
% xlabel('Sample')
% ylabel('Deg')
% subplot(3,1,3);
% plot(1:ind+1,q3_s(1854:1854+ind),1:ind+1, qesd(:,3),'r')
% title('Shoulder Flexion Angle')
% xlabel('Sample')
% ylabel('Deg')



% h = figure;
% set(h,'Name','Elbow Joints');
% xlabel('Sample')
% ylabel('Deg')
% subplot(2,1,1);
% plot(1:ind+1,q4_s(1854:1854+ind),1:ind+1, qesd(:,4),'r')
% title('Elbow Flexion Angle')
% xlabel('Sample')
% ylabel('Deg')
% subplot(2,1,2);
% plot(1:ind+1,q5_s(1854:1854+ind),1:ind+1, qesd(:,5),'r')
% title('Elbow Rotation Angle')
% xlabel('Sample')
% ylabel('Deg')


% h = figure;
% set(h,'Name','Shoulder Joints Error');
% subplot(3,1,1);
% plot(q1_s(1854:1854+ind) - qesd(:,1))
% title('Shoulder Abduction Error')
% subplot(3,1,2);
% plot(q2_s(1854:1854+ind) - qesd(:,2))
% title('Shoulder Rotation Error')
% subplot(3,1,3);
% plot(q3_s(1854:1854+ind) - qesd(:,3))
% title('Shoulder Flexion Error')


% h = figure;
% set(h,'Name','Elbow Joints');
% subplot(2,1,1);
% plot(q4_s(1854:1854+ind) - qesd(:,4))
% title('Elbow Flexion Error')
% subplot(2,1,2);
% plot(q5_s(1854:1854+ind) - qesd(:,5))
m = [mean(abs(q3_s(511:511+sample-1) - qesd(:,1)))
mean(abs(q4_s(511:511+sample-1) - qesd(:,2)))
mean(abs(q5_s(511:511+sample-1) - qesd(:,3)))
mean(abs(q6_s(511:511+sample-1) - qesd(:,4)))
mean(abs(q7_s(511:511+sample-1) - qesd(:,5)))]'

% mean(q5_s(1854:1854+ind) - qesd(:,5))];
% var(q1_s(1854:1854+ind) - qesd(:,1))
% var(q2_s(1854:1854+ind) - qesd(:,2))
% var(q3_s(1854:1854+ind) - qesd(:,3))
% var(q4_s(1854:1854+ind) - qesd(:,4))
% var(q5_s(1854:1854+ind) - qesd(:,5))
