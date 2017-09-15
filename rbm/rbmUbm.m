function rbmUbm(pathUbmInput, mode, nHidden, miniBatchSize, ...
    learningRate, learningRateFactor, cdSteps, cdStepsIncremental, epochs, ...
    epochsFactorUpdate, momentum, momentumFactor, lambda, ...
    lambdaFactor, pathUbmOutput)
%

% Read data
paths = rdir(pathUbmInput, '*.HTK', 1);
nFiles = size(paths, 1);
data = cell(nFiles, 1);
for i = 1:nFiles,
    data{i} = htkread(paths{i});
end

data = [data{:}]';
data = zscore(data);

% Prepare parameters
nVisible = size(data,2);
weights = normrnd(0, 0.01, nHidden, nVisible);
visibleBiases = zeros(nVisible, 1);
hiddenBiases = zeros(nHidden, 1);

% Bins 
divisors(size(data,1));
bins = 43;
data = reshape(data, [bins, size(data,1)/bins, size(data,2)]);

%% Run in a loop
for i = 1:bins
    display(i)
[weights, visibleBiases, hiddenBiases] = mexTrainRBM(squeeze(data(i,:,:)), ...
    weights, visibleBiases, hiddenBiases, mode, nHidden, miniBatchSize, ...
    learningRate, learningRateFactor, cdSteps, cdStepsIncremental, epochs, ... 
    epochsFactorUpdate, momentum, momentumFactor, lambda, lambdaFactor);
end

% Save results
ubm = cell(3,1);
ubm{1} = reshape(weights, nHidden, nVisible);
ubm{2} = reshape(visibleBiases, nVisible, 1);
ubm{3} = reshape(hiddenBiases, nHidden, 1);

path = fileparts(pathUbmOutput);
if ~exist(path, 'dir')
    mkdir(path);
end

save(pathUbmOutput, 'ubm');
end
