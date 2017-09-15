%
%% Clear workspace
close all;
clear all;

%% Paramteres
sharedParameters

%% Training the UBM
mode = 'LinearBinary';
nHidden = 1000;
miniBatchSize = 1000;
learningRate = 0.01;
learningRateFactor = 5;
cdSteps = 1;
cdStepsIncremental = 20;
epochs = 20;
epochsFactorUpdate = 4; 
momentum = 0.5;
momentumFactor = 2;
lambda = 0;
lambdaFactor = 0;

%% Train UBM
tic
rbmUbm(pathFeatureUbm, mode, nHidden, miniBatchSize, ...
    learningRate, learningRateFactor, cdSteps, cdStepsIncremental, epochs, ...
    epochsFactorUpdate, momentum, momentumFactor, lambda, ...
    lambdaFactor, pathModelUbm)
toc

%% Adapt speakers from UBM
mode = 'LinearBinary';
nHidden = 1000;
miniBatchSize = 1000;
learningRate = 0.01;
learningRateFactor = 5;
cdSteps = 1;
cdStepsIncremental = 20;
epochs = 20;
epochsFactorUpdate = 4; 
momentum = 0.5;
momentumFactor = 2;
lambda = 0.0;
lambdaFactor = 0;

tic
rbmAdapt(pathAdapt, pathModelAdapt, pathModelUbm, mode, nHidden, ...
    miniBatchSize, learningRate, learningRateFactor, cdSteps, ...
    cdStepsIncremental, epochs, epochsFactorUpdate, momentum, ...
    momentumFactor, lambda, lambdaFactor);
toc
%% Verification scores
tic
rbmScores(pathModelAdapt, pathVerify, pathModelUbm, pathModelVerify);
toc
%% AUC and  plot
[eer, dcf08, dcf10, auc_roc] = metrics_and_plots(pathModelVerify);