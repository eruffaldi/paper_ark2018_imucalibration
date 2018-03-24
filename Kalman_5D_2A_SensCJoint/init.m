if exist('armid','var')==0
    
    armid = 'hand';%'vic', 'k3'

    switch armid
        case 'vic'
            arms = [0.346 0.271 0.359 0.263];
        case 'hand'
            arms = [0.36 0.30 0.36 0.30];
        case 'k3'
            load('naiv_anatC_res');
    end
    alpha = 0.5; %=1
    beta = 2;
    k = 1;
    n = 15;

    covQ = 1;
    covEps = 1;
    cmpar = [1 1e-1 1 1 1e-1 1 1 1 1 10 10 1];
    
end

Ts = 0.01;
nj = 5;
Alp = 1;

covQ1 = covQ*[(0.5*Ts*Ts)^2 Ts^2 1];


A = zeros(15);
for I=1:nj
   AI = [1 Ts 0.5*Ts*Ts; 0 1 Ts; 0 0 Alp];
   A((I-1)*3+1:(I-1)*3+3,(I-1)*3+1:(I-1)*3+3) = AI;
end

P0 = blkdiag(diag(repmat(covEps,15,1)));


Q = blkdiag(diag(covQ1), diag(covQ1), diag(covQ1), diag(covQ1), diag(covQ1));

load('pose_1303_new');
load('Sens_1303_5D_new');
load('Y_1303_5Dnew');

intervN = Senspose.n1(1):Senspose.n1(2);
interv = Senspose.n(1,1):size(Yor,2);

YR.signals.values = Yor([1:9 19:27],interv)';
YL.signals.values = Yor([10:18 28:36],interv)';

% YR.signals.values = Yor([1:9 19:27],interv)';
% YL.signals.values = Yor([10:18 28:36],interv)';


% accL = 1e-1*cov(Sens1aL.acc(intervN,:));
% omegaL = 1e-1*cov(Sens1aL.gyro(intervN,:));
% magL = cov(Sens1aL.magT(intervN,:));
% 
% acc1L = cov(Sens1aL.acc(intervN,:));
% omega1L = 1e-1*cov(Sens1aL.gyro(intervN,:));
% mag1L = cov(Sens1aL.magT(intervN,:));
% 
% acc2L = 1e-2*cov(Sens2aL.acc(intervN,:));
% omega2L = 10*cov(Sens2aL.gyro(intervN,:));
% mag2L = 1e-1*cov(Sens2aL.magT(intervN,:));

acc1L = cmpar(1)*cov(Sens1aL.acc(intervN,:));
omega1L = cmpar(2)*cov(Sens1aL.gyro(intervN,:));
mag1L = cmpar(3)*cov(Sens1aL.magT(intervN,:));

acc2L = cmpar(4)*cov(Sens2aL.acc(intervN,:));
omega2L = cmpar(5)*cov(Sens2aL.gyro(intervN,:));
mag2L = cmpar(6)*cov(Sens2aL.magT(intervN,:));


% OK
% acc1L = cov(Sens1aL.acc(intervN,:));
% omega1L = 1e-1*cov(Sens1aL.gyro(intervN,:));
% mag1L = cov(Sens1aL.magT(intervN,:));
% 
% acc2L = cov(Sens2aL.acc(intervN,:));
% omega2L = 10*cov(Sens2aL.gyro(intervN,:));
% mag2L = 1e-1*cov(Sens2aL.magT(intervN,:));


% acc1L = 1e-1*cov(Sens1aL.acc(intervN,:));
% omega1L = cov(Sens1aL.gyro(intervN,:));
% mag1L = cov(Sens1aL.magT(intervN,:));
% 
% acc2L = 1e-1*cov(Sens2aL.acc(intervN,:));
% omega2L = cov(Sens2aL.gyro(intervN,:));
% mag2L = cov(Sens2aL.magT(intervN,:));


load('mag0');
% load('armsL');
load('xopt_1303_new');


%load('naiv_anatC_res');
%  load('vic_anatC_res');
% arms = [0.36 0.30 0.36 0.30];
%arms = [qes.signals.values(end-50, 33:34) qes.signals.values(end-50, 31:32)];

% M0L = [zeros(15,1); [s1P1L' s2P2L']'];
% M0R = [zeros(15,1); [s1P1R' s2P2R']'];

M0L = zeros(15,1); 
M0R = zeros(15,1); 

hparamsL = [[arms(3:4), zeros(1,7)]; [m0(3,1:3) xL(1:3) s1P1L']; [m0(4,1:3) xL(4:6) s2P2L']];
hparamsR = [[arms(1:2), zeros(1,7)]; [m0(1,1:3) xR(1:3) s1P1R']; [m0(2,1:3) xR(4:6) s2P2R']];

% ISMAR Settings
% RL = blkdiag(omega1L, acc1L, mag1L, omega2L, acc2L, mag2L, 1e-5*acc1L, 1e-5*acc2L);
RL = blkdiag(omega1L, acc1L, mag1L, omega2L, acc2L, mag2L);

% RL = blkdiag(omegaL, accL, magL, omegaL, accL, magL);
% 
% accR = 1e-1*cov(Sens1aR.acc(intervN,:));
% omegaR = 1e-1*cov(Sens1aR.gyro(intervN,:));
% magR = cov(Sens1aR.magT(intervN,:));

% OK
% acc1R = cov(Sens1aR.acc(intervN,:));
% omega1R = cov(Sens1aR.gyro(intervN,:));
% mag1R = cov(Sens1aR.magT(intervN,:));
% 
% acc2R = 10*cov(Sens2aR.acc(intervN,:));
% omega2R = 10*cov(Sens2aR.gyro(intervN,:));
% mag2R = cov(Sens2aR.magT(intervN,:));


%OK
% acc1R = cov(Sens1aR.acc(intervN,:));
% omega1R = 10*cov(Sens1aR.gyro(intervN,:));
% mag1R = 10*cov(Sens1aR.magT(intervN,:));
% 
% acc2R = 10*cov(Sens2aR.acc(intervN,:));
% omega2R = 10*cov(Sens2aR.gyro(intervN,:));
% mag2R = 10*cov(Sens2aR.magT(intervN,:));

acc1R = cmpar(7)*cov(Sens1aR.acc(intervN,:));
omega1R = cmpar(8)*cov(Sens1aR.gyro(intervN,:));
mag1R = cmpar(9)*cov(Sens1aR.magT(intervN,:));

acc2R = cmpar(10)*cov(Sens2aR.acc(intervN,:));
omega2R = cmpar(11)*cov(Sens2aR.gyro(intervN,:));
mag2R = cmpar(12)*cov(Sens2aR.magT(intervN,:));


% acc1R = 1e-1*cov(Sens1aR.acc(intervN,:));
% omega1R = cov(Sens1aR.gyro(intervN,:));
% mag1R = cov(Sens1aR.magT(intervN,:));
% 
% acc2R = cov(Sens2aR.acc(intervN,:));
% omega2R = cov(Sens2aR.gyro(intervN,:));
% mag2R = 1e-1*cov(Sens2aR.magT(intervN,:));


% acc1R = 1e-1*cov(Sens1aR.acc(intervN,:));
% omega1R = cov(Sens1aR.gyro(intervN,:));
% mag1R = cov(Sens1aR.magT(intervN,:));
% 
% acc2R = cov(Sens2aR.acc(intervN,:));
% omega2R = cov(Sens2aR.gyro(intervN,:));
% mag2R = 1e-1*cov(Sens2aR.magT(intervN,:));

% RR = blkdiag(omega1R, acc1R, mag1R, omega2R, acc2R, mag2R, 1e-5*acc1R, 1e-5*acc2R);

% RR = blkdiag(omega1R, acc1R, mag1R, omega2R, acc2R, mag2R, 1e-5*acc1R, 1e-5*acc2R); ISMAR Settings
RR = blkdiag(omega1R, acc1R, mag1R, omega2R, acc2R, mag2R);

% RR = blkdiag(omegaR, accR, magR, omegaR, accR, magR);


sample = size(YR.signals.values,1);


YR.time = [];
YL.time = [];

YR.signals.dimensions = 18;
YL.signals.dimensions = 18;

sim_t = round(sample*0.01);


[WM,W,l] = ut_weights(alpha, beta, k, n);

CovQan = 1;
Epsan = 0.025;

Aan = eye(6);
% Ran = 1e7*blkdiag(accL,accL,accL,accL);

Ran = 1e3*eye(6);

% Man0 = [0.0115 0.2147 3-0.0737 0.0792 -0.1318 -0.0458 ...
%         0.0385 0.1930 -0.0687 -0.0828  -0.1835 -0.0143]';

% arms = [0.27 0.35 0.27 0.35];
%Man0L = [0.01 0.66*arms(3) 0.01 0.01 -0.66*arms(4) 0.01];
%Man0R = [0.01 0.66*arms(1) 0.01 0.01 -0.66*arms(2) 0.01];
Man0L = [s1P1L' s2P2L'];
Man0R = [s1P1R' s2P2R'];

Man0 = [Man0L Man0R];

Pan0 = Epsan*eye(6);

Qan0 = 1e-6*eye(6);



% Eps = 1e-4;
% 
% As = eye(6);
% 
% RsL = 1e-3*blkdiag(accL,accL);
% RsR = 1e-3*blkdiag(accR,accR);


% Ps0L = Eps*eye(6);
% Ps0R = Eps*eye(6);
% 
% QsL = 1e-4*eye(6);
% QsR = 1e-4*eye(6);
