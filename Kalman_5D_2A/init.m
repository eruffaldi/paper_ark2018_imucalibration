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
M0 = zeros(15,1);

for I=1:nj
   AI = [1 Ts 0.5*Ts*Ts; 0 1 Ts; 0 0 Alp];
   A((I-1)*3+1:(I-1)*3+3,(I-1)*3+1:(I-1)*3+3) = AI;
end

P0 = diag(repmat(covEps,15,1));

Q = blkdiag(diag(covQ1), diag(covQ1), diag(covQ1), diag(covQ1), diag(covQ1));

load('pose_1303_new');
load('Sens_1303_5D_new');
load('Y_1303_5Dnew');

intervN = Senspose.n1(1):Senspose.n1(2);
% interv = Senspose.n(1,1):size(Yor,2);
interv = Senspose.n(1):Senspose.sh_rot(2);

YR.signals.values = Yor([1:9 19:27],interv)';
YL.signals.values = Yor([10:18 28:36],interv)';

acc1L = cmpar(1)*cov(Sens1aL.acc(intervN,:));
omega1L = cmpar(2)*cov(Sens1aL.gyro(intervN,:));
mag1L = cmpar(3)*cov(Sens1aL.magT(intervN,:));

acc2L = cmpar(4)*cov(Sens2aL.acc(intervN,:));
omega2L = cmpar(5)*cov(Sens2aL.gyro(intervN,:));
mag2L = cmpar(6)*cov(Sens2aL.magT(intervN,:));


load('mag0');
% load('armsL');
load('xopt_1303_new');
load('posopt_1303_new');

% load('naiv_anatC_res');
%load('vic_anatC_res');
%arms = qes.signals.values(end-50,31:34);
% arms = [0.36 0.30 0.36 0.30];


% 
 hparamsL = [[arms(3) arms(4), zeros(1,7)]; [m0(3,1:3) xL(1:3) s1P1L']; [m0(4,1:3) xL(4:6) s2P2L']];
 hparamsR = [[arms(1) arms(2), zeros(1,7)]; [m0(1,1:3) xR(1:3) s1P1R']; [m0(2,1:3) xR(4:6) s2P2R']];




RL = [omega1L zeros(3,15); zeros(3,3) acc1L zeros(3,12);zeros(3,6) mag1L zeros(3,9);...
    zeros(3,9) omega2L zeros(3,6); zeros(3,12) acc2L zeros(3,3);zeros(3,15) mag2L];


acc1R = cmpar(7)*cov(Sens1aR.acc(intervN,:));
omega1R = cmpar(8)*cov(Sens1aR.gyro(intervN,:));
mag1R = cmpar(9)*cov(Sens1aR.magT(intervN,:));

acc2R = cmpar(10)*cov(Sens2aR.acc(intervN,:));
omega2R = cmpar(11)*cov(Sens2aR.gyro(intervN,:));
mag2R = cmpar(12)*cov(Sens2aR.magT(intervN,:));


RR = [omega1R zeros(3,15); zeros(3,3) acc1R zeros(3,12);zeros(3,6) mag1R zeros(3,9);...
    zeros(3,9) omega2R zeros(3,6); zeros(3,12) acc2R zeros(3,3);zeros(3,15) mag2R];

sample = size(YR.signals.values,1);


YR.time = [];
YL.time = [];

YR.signals.dimensions = 18;
YL.signals.dimensions = 18;

sim_t = round(sample*0.01);

[WM,W,c] = ut_weights(alpha, beta, k, n);