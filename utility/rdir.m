function fileList = rdir(dirName, fileExtension, appendFullPath)

dirData = dir([dirName '/' fileExtension]);
dirWithSubFolders = dir(dirName);
dirIndex = [dirWithSubFolders.isdir];
fileList = {dirData.name}';
if ~isempty(fileList)
    if appendFullPath
        fileList = cellfun(@(x) fullfile(dirName,x),fileList, ...
            'UniformOutput',false);
    end
end
subDirs = {dirWithSubFolders(dirIndex).name};
validIndex = ~ismember(subDirs,{'.','..'});

for iDir = find(validIndex)
    nextDir = fullfile(dirName,subDirs{iDir});
    fileList = [fileList;
        rdir(nextDir, fileExtension, appendFullPath)];
end

end