function gmmMapAdapt(adaptPath, adaptDirResult, ubmPath, tau, config)

paths = rdir(adaptPath, '*.HTK', 1);
speakerPaths = unique(cellfun(@(path) fileparts(path), paths, ...
    'UniformOutput', 0));
rolledSpeakerPaths = cellfun(@(path) rdir(path, '*.HTK', 1), ...
    speakerPaths, 'UniformOutput', 0);

for i = 1:length(rolledSpeakerPaths),
    [~,name,~] = fileparts(speakerPaths{i});
    speakerPath = fullfile(adaptDirResult, strcat(name,'.mat'));
    mapAdapt(rolledSpeakerPaths{i}, ubmPath, tau, config, speakerPath);
end

end

