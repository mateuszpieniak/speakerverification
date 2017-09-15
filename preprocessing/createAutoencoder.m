%
%% Clear workspace
close all;
clear all;

%% Paramteres
sharedParameters

%% Read data
paths = rdir(pathAudioUbm, '*.WAV', 1);
fs = 16000;
Nw = (fs / 1000) * 25;
Ns = (fs / 1000) * 10;

data = cell(length(paths), 1);

for i = 1:length(paths)
    [speech, fs] = audioread(paths{i});
    frames = vec2frames(speech, Nw, Ns, 'rows', @hamming, false);
    frames = arrayfun(@(n) 10*log10(abs(fft(frames(n,:)))), 1:size(frames,1), 'UniformOutput', false);
    frames = cat(1, frames {:});
    frames = zscore(frames);
    data{i} = frames;
end

data = cat(1, data {:});

%% Parameters
mode = 'LinearNRelu';
nHidden = 13;
miniBatchSize = 100;
learningRate = 0.001;
learningRateFactor = 0;
cdSteps = 1;
cdStepsIncremental = 0;
epochs = 1;
epochsFactorUpdate = 0; 
momentum = 0.5;
momentumFactor = 0;
lambda = 0.0;
lambdaFactor = 0;

nVisible = size(data,2);
weights = normrnd(0, 0.01, nHidden, nVisible);
visibleBiases = zeros(nVisible, 1);
hiddenBiases = zeros(nHidden, 1);

%% Update
learningRate = learningRate / 2;
momentum = momentum / 2;

%% Bins
divisors(size(data,1));
bins = 3;
data = reshape(data, [bins, size(data,1)/bins, size(data,2)]);

%% Run in a loop
for j = 1:10
    for i = 1:bins
    tic
    [weights, visibleBiases, hiddenBiases] = mexTrainRBM(squeeze(data(i,:,:)), ...
        weights, visibleBiases, hiddenBiases, mode, nHidden, miniBatchSize, ...
        learningRate, learningRateFactor, cdSteps, cdStepsIncremental, epochs, ... 
        epochsFactorUpdate, momentum, momentumFactor, lambda, lambdaFactor);
    toc
    end    
end

%% Save autoencoder
autoencoder = cell(3,1);
autoencoder{1} = reshape(weights, nHidden, nVisible);
autoencoder{2} = reshape(visibleBiases, nVisible, 1);
autoencoder{3} = reshape(hiddenBiases, nHidden, 1);

path = fileparts(pathAutoencoder);
if ~exist(path, 'dir')
    mkdir(path); 
end

save(pathAutoencoder, 'autoencoder');

