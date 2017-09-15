function copyAudio(paths, outputPath)
for i = 1:length(paths)
    splitResult = strsplit(paths{i},'/');
    audioFile = splitResult{end};
    speakerName = splitResult{end-1};
    
    destDir = fullfile(outputPath, speakerName);
    if ~exist(destDir, 'dir')
        mkdir(destDir)
    end
    
    destPath = fullfile(destDir, audioFile);
    copyfile(paths{i}, destPath)
end

end

