% 
%% Clear workspace
close all;
clear all;

%% Parameters
sharedParameters

%% Create main dirs
paths = {
    pathAudioUbm, ...
    fullfile(pathAudioVal, adaptDir), ...
    fullfile(pathAudioVal, verifyDir), ...
    fullfile(pathAudioTest, adaptDir), ...
    fullfile(pathAudioTest, verifyDir)
    };

for i=1:length(paths)
    if ~exist(paths{i}, 'dir')
        mkdir(paths{i})
    end
end

%% Generate paths
paths = rdir(pathTimitRaw, '*.WAV', 1);
speakerPaths = unique(cellfun(@(path) fileparts(path), paths, ...
    'UniformOutput', 0));

[ubmInd, valInd, testInd] = dividerand(length(speakerPaths), ...
    ubmSplit, valSplit, testSplit);

ubmPaths = speakerPaths(ubmInd);
valPaths = speakerPaths(valInd);
testPaths = speakerPaths(testInd);

rolledUbmPaths = cellfun(@(path) rdir(path, '*.WAV', 1), ubmPaths, ...
    'UniformOutput', 0);
unrolledUbmPaths = cat(1, rolledUbmPaths {:});


rolledValPaths = cellfun(@(path) rdir(path, '*.WAV', 1), valPaths, ...
    'UniformOutput', 0);
[unrolledValPathsAdapt, unrolledValPathsVerify] = ...
    unrollAndSplitPaths(adaptTrain, rolledValPaths);

rolledTestPaths = cellfun(@(path) rdir(path, '*.WAV', 1), testPaths, ...
    'UniformOutput', 0);
[unrolledTestPathsAdapt, unrolledTestPathsVerify] = ...
    unrollAndSplitPaths(adaptTrain, rolledTestPaths);

%% Copy files
copyAudio(unrolledUbmPaths, pathAudioUbm);
copyAudio(unrolledValPathsAdapt, fullfile(pathAudioVal, adaptDir));
copyAudio(unrolledValPathsVerify, fullfile(pathAudioVal, verifyDir));
copyAudio(unrolledTestPathsAdapt, fullfile(pathAudioTest, adaptDir));
copyAudio(unrolledTestPathsVerify, fullfile(pathAudioTest, verifyDir));

