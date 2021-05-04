function []=nifticonversion(Folder,Output,RecursionLevel)

% nifticonversion(Folder,Output)
% Folder : DICOM folder
% Output : Wanted nifti folder
% RecursionLevel : Only for recursion don't put anything here
% ------
% Quentin Raynaud

if nargin==1
    Output=replace(Folder,SegmentString(Folder,0),SegmentString('nifti',0));
    RecursionLevel=0;
elseif nargin==2
    RecursionLevel=0;
    if Folder(end)=='\'
        Folder=Folder(1:end-1);
    end
    if Output(end)=='\'
        Output=Output(1:end-1);
    end
end

listing = dir(Folder);
Dicom = [];

for cfile=3:size(listing,1)%loop on all files and folder
    filename=[listing(cfile).folder,'\',listing(cfile).name];
    if listing(cfile).isdir==0%add to the dicom conversion if not a dir
        if startsWith(listing(cfile).name,'MR')
            Dicom{end+1}=filename;
        end
    else
        Outputfolder=replace(filename,strcat('\',SegmentString(filename,RecursionLevel+1),'\'),strcat('\',SegmentString(Output,RecursionLevel),'\'));
        if ~exist(Outputfolder, 'dir')
            mkdir(Outputfolder)
        end
        nifticonversion(filename,Outputfolder,RecursionLevel+1);%recursion if it is a folder
    end
    
end

if ~isempty(Dicom)
    matlabbatch{1}.spm.util.import.dicom.data = cellstr(Dicom)';
    matlabbatch{1}.spm.util.import.dicom.root = 'flat';
    matlabbatch{1}.spm.util.import.dicom.outdir = {Output};
    matlabbatch{1}.spm.util.import.dicom.protfilter = '.*';
    matlabbatch{1}.spm.util.import.dicom.convopts.format = 'nii';
    matlabbatch{1}.spm.util.import.dicom.convopts.meta = 0;
    matlabbatch{1}.spm.util.import.dicom.convopts.icedims = 0;
    spm_jobman('run',matlabbatch);
end
end

function segments=SegmentString(remain,reclvl)

segments = strings(0);
while (remain ~= "")
   [token,remain] = strtok(remain, '\');
   segments = [segments ; token];
end

segments=segments(end-reclvl);
end