clear, clc

close all

addpath(pwd)

%% set parameters
mod = 'k2';
armid = 'k3';

switch armid
    case 'vic'
        arms = [0.307 0.271 0.322 0.263];
        load('posopt_1303_new');
        
    case 'hand'
        arms = [0.36 0.30 0.36 0.30];
        kR = [0.66   -0.66];
        s1P1L = [0 kR(1)*arms(1) 0]';
        s2P2L = [0 kR(2)*arms(2) 0]';
        s1P1R = [0 kR(1)*arms(3) 0]';
        s2P2R = [0 kR(2)*arms(4) 0]';
        
    case 'k3'
        load('naiv_anatC_res_jfr');
        arms = qes.signals.values(end,31:34);
        kR = [0.66   -0.66];
        s1P1L = [0 kR(1)*arms(1) 0]';
        s2P2L = [0 kR(2)*arms(2) 0]';
        s1P1R = [0 kR(1)*arms(3) 0]';
        s2P2R = [0 kR(2)*arms(4) 0]';
end
alpha = 0.5; %=1
beta = 2;
k = 1;
n = 15;

covQ = 1*1e-2;
covEps = 1*1e-1;
% cmpar = [1 1e-1 1 1 1e-1 1 1 1 1 10 10 1];
cmpar = [1.5 1.5 1e-1 1.5 1.5 1e-1 2.5 2.5 2.5 0.5*10 0.5*10 0.5*1];

% 1.5000    1.5000    0.1000    1.5000    1.5000    0.1000    2.5000    2.5000    2.5000    5.0000    5.0000    0.5000
%     0.9000    0.9000    0.1000    0.9000    0.9000    0.1000    2.5000    2.5000    2.5000    5.0000    5.0000    0.5000
%% run simulation and save
switch mod
    case 'k1'
        cd Kalman_5D_2A
        init
        try
            sim('Kalm_5D_2.mdl')
            stat_new
        catch me
            qerrL = nan;
            qmL = nan;
            qcL = nan;
            qerrR = nan;
            qmR = nan;
            qcR = nan;
            perrL = nan;
            pmL = nan;
            perrR = nan;
            pmR = nan;
        end
        cd ..
        
    case 'k2'
        cd Kalman_5D_2A_SensCJoint
        init
        try
            sim('Kalm_5D_Reb.mdl')
            stat_new
        catch me           
            qerrL = nan;
            qmL = nan;
            qcL = nan;
            qerrR = nan;
            qmR = nan;
            qcR = nan;
            perrL = nan;
            pmL = nan;
            perrR = nan;
            pmR = nan;
        end            
        cd ..
end

try
    load resds.mat
    
    thds = dataset();
    
    thds.mod = {mod};
    thds.armid = {armid};
    thds.covQ = covQ;
    thds.covEps = covEps;
    thds.arms = {arms};
    thds.cmpar = {cmpar};
    thds.alpha = alpha;
    thds.beta = beta;
    thds.k  = k;
    thds.n = n;
    thds.qerrL = {qerrL};
    thds.qmL = {qmL};
    thds.qcL = {qcL'};
    thds.qerrR = {qerrR};
    thds.qmR = {qmR};
    thds.qcR = {qcR'};
    thds.perrL = {perrL};
    thds.pmL = pmL;
    thds.perrR = {perrR};
    thds.pmR = pmR;
    
    ods = [ods; thds];
    
    
catch me
    ods = dataset();
    
    ods.mod = {mod};
    ods.armid = {armid};
    ods.covQ = covQ;
    ods.covEps = covEps;
    ods.arms = {arms};
    ods.cmpar = {cmpar};
    ods.alpha = alpha;
    ods.beta = beta;
    ods.k  = k;
    ods.n = n;
    ods.qerrL = {qerrL};
    ods.qmL = {qmL};
    ods.qcL = {qcL'};
    ods.qerrR = {qerrR};
    ods.qmR = {qmR};
    ods.qcR = {qcR'};
    ods.perrL = {perrL};
    ods.pmL = pmL;
    ods.perrR = {perrR};
    ods.pmR = pmR;
    
end

% save resds.mat ods