function rbmAdapt(pathAdapt, adaptDirResult, pathUbm, mode, nHidden, ...
        miniBatchSize, learningRate, learningRateFactor, cdSteps, ...
        cdStepsIncremental, epochs, epochsFactorUpdate, momentum, ...
        momentumFactor, lambda, lambdaFactor)
%
% Read UBM
tmp = load(pathUbm);
ubmWeights = tmp.ubm{1};
ubmBiasesVisible = tmp.ubm{2};
ubmBiasesHidden = tmp.ubm{3};

% Read speakers features
paths = rdir(pathAdapt, '*.HTK', 1);
speakerPaths = unique(cellfun(@(path) fileparts(path), paths, ...
    'UniformOutput', 0));
rolledSpeakerPaths = cellfun(@(path) rdir(path, '*.HTK', 1), ...
    speakerPaths, 'UniformOutput', 0);

disp(length(rolledSpeakerPaths))
% Train model for each speaker
for i = 1:length(rolledSpeakerPaths),
    display(i)
    % Create matrix of data
    filenames = rolledSpeakerPaths{i};
    nfiles = size(filenames, 1);
    data = cell(nfiles, 1);
    for j = 1:nfiles,
        data{j} = htkread(filenames{j});
    end
    data = [data{:}]';
    data = zscore(data);

    % Train model
    [weights, visibleBiases, hiddenBiases] = mexTrainRBM(data, ...
    ubmWeights, ubmBiasesVisible, ubmBiasesHidden, mode, nHidden, miniBatchSize, ...
    learningRate, learningRateFactor, cdSteps, cdStepsIncremental, epochs, ... 
    epochsFactorUpdate, momentum, momentumFactor, lambda, lambdaFactor);
    
    % Save model
    [~,name,~] = fileparts(speakerPaths{i});
    speakerPath = fullfile(adaptDirResult, strcat(name,'.mat'));
    
    model = cell(3,1);
    model{1} = weights;
    model{2} = visibleBiases;
    model{3} = hiddenBiases;
    
    path = fileparts(speakerPath);
    if ~exist(path, 'dir')
        mkdir(path);
    end
    
    save(speakerPath, 'model');
end

end