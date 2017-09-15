%
%% Clear workspace
close all;
clear all;

%% Paramteres
sharedParameters

%% Training the UBM
tic
nMix = 64;
nIters = 20;
dsFactor = 1;
nWorkers = 2;
gmm_em(pathFeatureUbm, nMix, nIters, dsFactor, nWorkers, pathModelUbm);
toc

%% Adapt speakers from UBM
tic
tau = 0.0;
config = 'mwv';
gmmMapAdapt(pathAdapt, pathModelAdapt, pathModelUbm, tau, config)
toc

%% Verification scores
tic
gmmScores(pathModelAdapt, pathVerify, pathModelUbm, pathModelVerify);
toc

%% AUC and  plot
[eer, dcf08, dcf10, auc_roc] = metrics_and_plots(pathModelVerify);
