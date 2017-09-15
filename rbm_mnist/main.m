%
%% Clear workspace
clear all;
close all;  

%% Read MNIST - training
pathMNIST = '/media/mateusz/SharedData/MNIST';
pathTrainX = fullfile(pathMNIST, 'train-images.idx3-ubyte');
pathTrainY = fullfile(pathMNIST, 'train-labels.idx1-ubyte');
nSamples = 10000;
[data, labels] = readMNIST(pathTrainX, pathTrainY, nSamples, 0);


%% Prepare parameters
mode = 'BinaryBinary';
nHidden = 16;
miniBatchSize = 100;
learningRate = 0.01;
learningRateFactor = 1.5;
cdSteps = 100;
cdStepsIncremental = 0;
epochs = 100;
epochsFactorUpdate = 10; 
momentum = 0.5;
momentumFactor = 2;
lambda = 0.0;
lambdaFactor = 0;

data(data >= 0.3) = 1;
data(data < 0.3) = 0;
data = reshape(data, 400, nSamples)';
% data = zscore(data);

nVisible = size(data,2);
weights = normrnd(0, 0.01, nHidden, nVisible);
visibleBiases = zeros(nVisible, 1);
hiddenBiases = zeros(nHidden, 1);

%% Run
tic
[weightsNew, visibleBiasesNew, hiddenBiasesNew] = mexTrainRBM(data, ...
    weights, visibleBiases, hiddenBiases, mode, nHidden, miniBatchSize, ...
    learningRate, learningRateFactor, cdSteps, cdStepsIncremental, epochs, ... 
    epochsFactorUpdate, momentum, momentumFactor, lambda, lambdaFactor);
toc

%% Next epochs
tic
[weightsNew, visibleBiasesNew, hiddenBiasesNew] = mexTrainRBM(data, ...
    weightsNew, visibleBiasesNew, hiddenBiasesNew, mode, nHidden, miniBatchSize, ...
    learningRate, learningRateFactor, cdSteps, cdStepsIncremental, epochs, ... 
    epochsFactorUpdate, momentum, momentumFactor, lambda, lambdaFactor);
toc
%% Plot weights before
n = 4;
m = 4;
figure(1)
for i=1:n
    for j=1:(m+1)
        idx = (i-1)*n+j;
        if idx <= nHidden
            img = reshape(weights(idx,:,:), 20, 20);
            subplot(n,m,idx), imshow(img, [])
            set(gca, 'XTick', []);
            set(gca, 'YTick', []);
        end
    end
end

%% Plot weights after
n = 4;
m = 4;
figure(1)
for i=1:n
    for j=1:(m+1)
        idx = (i-1)*n+j;
        if idx <= nHidden
            img = reshape(weightsNew(idx,:,:), 20, 20);
            subplot(n,m,idx), imshow(img, [])
            set(gca, 'XTick', []);
            set(gca, 'YTick', []);
        end
    end
end


%% Generate samples
nGenerateSamples = 16;
randomGenerateSamples = randi([0 1], nGenerateSamples, nVisible);
steps = 10000;
mode2 = 'Sample';
tic
generateSamples = mexGibbsRBM(randomGenerateSamples, ...
    weightsNew, visibleBiasesNew, hiddenBiasesNew, mode, mode2, nHidden, ...
    steps);
toc


%% Plot samples
n = 4;
m = 4;
figure(1)
for i=1:n
    for j=1:(m+1)
        idx = (i-1)*n+j;
        if idx <= nGenerateSamples
            img = reshape(generateSamples(idx,:,:), 20, 20);
            subplot(n,m,idx), imshow(img, [])
            set(gca, 'XTick', []);
            set(gca, 'YTick', []);
        end
    end
end

%% Plot errors
errors = regexp(str,'\d+.\d+', 'match');
errors = cellfun(@str2double,errors);
plot(1:epochs, errors)
xlabel('Epoka')
ylabel('Średni błąd rekonstrukcji')

