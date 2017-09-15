function rbmScores(pathAdaptResult, pathVerify, pathUbmResult, ...
    pathModelVerify)
%
% Create trials and labels 
modelsPaths = rdir(pathAdaptResult, '*.mat', 1);
verifyPaths = rdir(pathVerify, '*.HTK', 1);
n = length(modelsPaths);
m = length(verifyPaths);
trials = zeros(n*m, 2);
labels = zeros(n*m, 1);
for i = 1:n
    for j = 1:m
        idx = (i-1)*m + j;
        trials(idx,:) = [i, j];
        
        [~, modelName, ~] = fileparts(modelsPaths{i});
        splitResult = strsplit(verifyPaths{j}, '/');
        verifyName = splitResult{end-1};
        if strcmp(modelName, verifyName)
            labels(idx) = 1;
        else
            labels(idx) = 0;
        end
    end
end

% Load UBM
tmp = load(pathUbmResult);
ubm = tmp.ubm;

% Read verification files;
verifications = cell(m, 1);
parfor i = 1:m,
    verifications{i} = htkread(verifyPaths{i});
end

% Read model files
models = cell(n, 1);
parfor i = 1:n,
    tmp = load(modelsPaths{i});
    models{i} = tmp.model;
end

% Compute scores
scores = cell(n,1);
parfor i = 1:n, % *n
    temp_scores = zeros(m, 1);
    for j = 1:m
        idx = (i-1)*m + j;
        rbm = models{trials(idx, 1)};
        fea = verifications{trials(idx, 2)};
        fea = zscore(fea')';
        rbm_nominator = freeEnergy(fea, rbm);
        ubm_nominator = freeEnergy(fea, ubm);
        diff_nominator = rbm_nominator - ubm_nominator;
        temp_scores(j) = mean(diff_nominator);
    end
    scores{i} = temp_scores;
end

scores = [scores{:}];
norm_scores = bsxfun(@minus, scores, min(scores));
norm_scores = norm_scores ./ repmat(max(scores) - min(scores), ...
    size(scores,1), 1);
norm_scores = norm_scores(:);

% Save scores
if ~exist(fileparts(pathModelVerify), 'dir')
    mkdir(fileparts(pathModelVerify))
end

fid = fopen(pathModelVerify, 'wt');
fprintf(fid, '%f %f\r\n', [norm_scores, labels]');
fclose(fid);

end
