function gmmScores(adaptResultPath, verifyPath, ubmResultPath, ...
    pathModelVerify)
modelsPaths = rdir(adaptResultPath, '*.mat', 1);
verifyPaths = rdir(verifyPath, '*.HTK', 1);
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

scores = score_gmm_trials(modelsPaths, verifyPaths, trials, ubmResultPath);

if ~exist(fileparts(pathModelVerify), 'dir')
    mkdir(fileparts(pathModelVerify))
end

fid = fopen(pathModelVerify, 'wt');
fprintf(fid, '%f %f\r\n', [scores, labels]');
fclose(fid);
end
