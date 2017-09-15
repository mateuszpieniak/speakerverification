%
%% Parameters
pathRoot = '/media/mateusz/SharedData';
pathTimitRaw = fullfile(pathRoot, 'LDC93S1');
pathTimitSplit = fullfile(pathRoot, 'TIMIT/Audio');

autoencoderFilename = 'autoencoder.mat';
ubmDir = 'ubm';
validDir = 'valid';
testDir = 'test';
adaptDir = 'adapt';
verifyDir = 'verify';

ubmSplit = 0.3;
valSplit = 0.1;
testSplit = 0.6;
adaptTrain = 0.8;

ubmConfigFile = 'ubm.mat';

speakersDir = 'speakers';
resultsDir = 'results';
verifyResultFile = 'verify.mat';

%% Changing
pathFeatures = fullfile(pathRoot, 'TIMIT/Features_AUTOENKODER2');
pathModel = fullfile(pathRoot,'TIMIT/Models_GMM_AUTOENKODER2');
featureType = 'rbm';
adaptAndVerifyDataset = 'test';

%% Create paths
pathAudioUbm = fullfile(pathTimitSplit, ubmDir);
pathAudioVal= fullfile(pathTimitSplit, validDir);
pathAudioTest = fullfile(pathTimitSplit, testDir);

pathFeatureUbm = fullfile(pathFeatures, ubmDir);
pathFeatureVal = fullfile(pathFeatures, validDir);
pathFeatureTest = fullfile(pathFeatures, testDir);

pathAdapt = fullfile(pathFeatures, adaptAndVerifyDataset, adaptDir);
pathVerify = fullfile(pathFeatures, adaptAndVerifyDataset, verifyDir);

pathModelUbm = fullfile(pathModel, ubmConfigFile);
pathModelAdapt = fullfile(pathModel, adaptAndVerifyDataset, speakersDir);
pathModelVerify = fullfile(pathModel, adaptAndVerifyDataset, ...
    resultsDir, verifyResultFile);

pathAutoencoder = fullfile(pathFeatures, autoencoderFilename);


