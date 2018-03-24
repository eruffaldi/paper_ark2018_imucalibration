Rth = @(th) [cos(th) 0;sin(th) 0; 0 1];

Ts = 0.01;
nj = 5;
alpha = 1;

A = zeros(34);

covQ = 1;

covQ1 = covQ*[(0.5*Ts*Ts)^2 Ts^2 1];

covEps = 1;


for I=1:2*nj
   AI = [1 Ts 0.5*Ts*Ts; 0 1 Ts; 0 0 alpha];
   A((I-1)*3+1:(I-1)*3+3,(I-1)*3+1:(I-1)*3+3) = AI;
end

A(31:34,31:34) = eye(4);



P0 = diag(repmat(covEps,34,1));
P0(31:34,31:34) = 1e-2;

Q = blkdiag(diag(covQ1), diag(covQ1), diag(covQ1), diag(covQ1), diag(covQ1), diag(covQ1), diag(covQ1), diag(covQ1), diag(covQ1), diag(covQ1), eye(4));
Q(31:34,31:34) = 1e-2;

load('pose_1303_new');
load('Sens_1303_5D_new');
load('Y_1303_5Dnew');

intervN = Senspose.n1(1):Senspose.n1(2);
interv = Senspose.cal(1):Senspose.cal(1)+7000;

Z.signals.values = [Yor([10:18 28:36],interv)' Yor([1:9 19:27],interv)' zeros(length(interv), 9)];

acc1L = cov(Sens1aL.acc(intervN,:));
omega1L = cov(Sens1aL.gyro(intervN,:));
mag1L = cov(Sens1aL.magT(intervN,:));

acc2L = cov(Sens2aL.acc(intervN,:));
omega2L = cov(Sens2aL.gyro(intervN,:));
mag2L = cov(Sens2aL.magT(intervN,:));

load('mag0');
load('armsL');
load('xopt_1303_new');
load('posopt_1303_new');

% M0 = [zeros(30,1); [arms(3:4) arms(1:2)]'];
% arm0 = [arms(3)-0.045 arms(4) arms(1)-0.045 arms(2)];
% arm0 = [0.28 0.28 0.275 0.28];
% % arm0 = [0.36 0.30 0.36 0.30];%naive
% arms = [0.36 0.30 0.36 0.30];
% kR = [0.66   -0.66];
% s1P1L = [0 kR(1)*arms(1) 0]';
% s2P2L = [0 kR(2)*arms(2) 0]';
% s1P1R = [0 kR(1)*arms(3) 0]';
% s2P2R = [0 kR(2)*arms(4) 0]';
% arm0 = arms;
arm0 = [0.346 0.271 0.359 0.263];%vicon
M0 = [zeros(30,1); arm0'];

hparamsL = [[arms(3:4), zeros(1,7)]; [m0(3,1:3) xL(1:3) s1P1L']; [m0(4,1:3) xL(4:6) s2P2L']];
hparamsR = [[arms(1:2), zeros(1,7)]; [m0(1,1:3) xR(1:3) s1P1R']; [m0(2,1:3) xR(4:6) s2P2R']];

RL = blkdiag(omega1L, acc1L, mag1L, omega2L, acc2L, mag2L);
% RL = blkdiag(omega1L, acc1L, mag1L, omega1L, acc1L, mag1L);

acc1R = cov(Sens1aR.acc(intervN,:));
omega1R = cov(Sens1aR.gyro(intervN,:));
mag1R = cov(Sens1aR.magT(intervN,:));

acc2R = 10*cov(Sens2aR.acc(intervN,:));
omega2R = 10*cov(Sens2aR.gyro(intervN,:));
mag2R =cov(Sens2aR.magT(intervN,:));

RR = blkdiag(omega1R, acc1R, mag1R, omega2R, acc2R, mag2R);
% RR = blkdiag(omega1R, acc1R, mag1R, omega1R, acc1R, mag1R);



RR = blkdiag(RL, RR, 1e-6*eye(3),1e-6*eye(3),1e-6*eye(3));

sample = size(Z.signals.values,1);

Z.time = [];

Z.signals.dimensions = 45;

sim_t = round(sample*0.01);

alpha = 0.5; %=1
beta = 2;
k = 1;
n = 34;

[WM,W,c] = ut_weights(alpha, beta, k, n);

%GOOD TUNING 1
% acc1R = cov(Sens1aR.acc(intervN,:));
% omega1R = 10*cov(Sens1aR.gyro(intervN,:));
% mag1R = 10*cov(Sens1aR.magT(intervN,:));
% 
% acc1L = cov(Sens1aL.acc(intervN,:));
% omega1L = cov(Sens1aL.gyro(intervN,:));
% mag1L = cov(Sens1aL.magT(intervN,:))
% Conv: 0.3270    0.2669    0.3270    0.2670
