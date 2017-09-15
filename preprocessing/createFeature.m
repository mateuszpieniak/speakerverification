function [feature] = createFeature(speech, fs, featureType, pathAutoencoder)
% 

Tw = 25;                % analysis frame duration (ms)
Ts = 10;                % analysis frame shift (ms)

tempFeatureType = featureType;
if strcmp(featureType, 'both')
    tempFeatureType = 'mfcc';
end

if strcmp(tempFeatureType, 'mfcc')
    % Parameters
    alpha = 0.97;           % preemphasis coefficient
    M = 20;                 % number of filterbank channels
    C = 12;                 % number of cepstral coefficients
    L = 22;                 % cepstral sine lifter parameter
    LF = 300;               % lower frequency limit (Hz)
    HF = 3700;              % upper frequency limit (Hz)
    
    % Feature extraction (feature vectors as columns)
    [feature, ~, ~] = mfcc(speech, fs, Tw, Ts, alpha, @hamming, [LF HF], ...
        M, C+1, L);
end

if strcmp(featureType, 'both')
    A = feature;
    tempFeatureType = 'rbm';
end

if strcmp(tempFeatureType, 'rbm')
    % Read UBM
    tmp = load(pathAutoencoder);
    rbmWeights = tmp.autoencoder{1};
    rbmVisibleBiases = tmp.autoencoder{2};
    rbmHiddenBiases = tmp.autoencoder{3};
    
    mode = 'LinearNRelu';
    mode2 = 'Reconstruction';
    Nw = (fs / 1000) * 25;
    Ns = (fs / 1000) * 10;
    
    frames = vec2frames(speech, Nw, Ns, 'rows', @hamming, false);
    frames = arrayfun(@(n) 10*log10(abs(fft(frames(n,:)))), 1:size(frames,1), 'UniformOutput', false);
    frames = cat(1, frames {:});
    frames = zscore(frames);
    
    feature = mexGibbsRBM(frames, rbmWeights, rbmVisibleBiases, ...
        rbmHiddenBiases, mode, mode2, 13, 1);
    feature = feature';
end

if strcmp(featureType, 'both')
    B = feature;
    feature = [A; B];
end

end

