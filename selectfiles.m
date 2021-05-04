function fileList=selectfiles(folder,beginchar)
% Function use the select all nifti files in a folder
% folder : folder where we want to search of nifti files
% Optional ---
% beginchar : select only the nifties begining by this chars

if isstring(beginchar) || isstring(folder)
    error('Imputs must be strings')
end

if beginchar(end)=='/'
    beginchar=beginchar(1:end-1);
end

fileList=[];
listing=dir(folder);

if nargin == 1
    beginchar=[];
    flag=[];
end

for cfile=3:size(listing,1)
    filename=[listing(cfile).folder,'\',listing(cfile).name];
    if listing(cfile).isdir==0
        if isempty(beginchar) || startsWith(listing(cfile).name,beginchar)
            fileList{end+1}=filename;
        end
    end
end


end