%
%% Clear workspace
close all;
clear all;

%% Parameters
sharedParameters

%% Create main dir
paths = {
    pathFeatureUbm, ...
    fullfile(pathFeatureVal, adaptDir), ...
    fullfile(pathFeatureVal, verifyDir), ...
    fullfile(pathFeatureTest, adaptDir), ...
    fullfile(pathFeatureTest, verifyDir)
    };

for i=1:length(paths)
    if ~exist(paths{i}, 'dir')
        mkdir(paths{i})
    end
end

%% Generate features
paths = rdir(pathTimitSplit, '*.WAV', 1);
for i = 1:length(paths)
    [speech, fs] = audioread(paths{i});
    features = createFeature(speech, fs, featureType, pathAutoencoder);
    
    splitResult = strsplit(paths{i},'/');
    audioFile = splitResult{end};
    speakerName = splitResult{end-1};
    decision = splitResult{end-2};
    validOrTest = splitResult{end-3};
    
    pathOutput = '';
    if strcmp(decision, ubmDir)
        pathOutput = fullfile(pathFeatureUbm, speakerName);
    elseif strcmp(validOrTest, validDir)
        pathOutput = fullfile(pathFeatureVal, decision, speakerName);
    elseif strcmp(validOrTest, testDir)
        pathOutput = fullfile(pathFeatureTest, decision, speakerName);
    end
    
    if ~exist(pathOutput, 'dir')
        mkdir(pathOutput)
    end
    
    htkFile = strrep(audioFile, '.WAV', '.HTK');
    pathOutput = fullfile(pathOutput, htkFile);
    writehtk_lite(pathOutput, features', fs, 6+8192)
end







