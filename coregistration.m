function coregistration(Reference,Source,OtherFiles)

% coregistration(Reference,Source)
% Reference : Reference image
% Source : Source image or folder
% If folder, then first nifti will be source, and others will be "others"
% OtherFiles : Name of the other folders :
% name{1}=name1.nii ;
% name{2}=name2.nii, ...
% ------
% Quentin Raynaud


Other=[];

if ~endsWith(Reference,'.nii')
    error('No .nii as reference image')
end

if nargin==2

flag=0;

if ~endsWith(Source,'.nii')
    listing = dir(Source);
    %find the one that en with 01 <- to be implemented
    %if cannot, take the first .nii
    if size(listing,1)>2
        
        
        if nargin==2
            %"other" will be all file but first one in source dir
            if size(listing,1)>3
                for ii=4:size(listing,1)
                    if listing(ii).isdir==0%add to the dicom conversion if not a dir
                        if isempty(Other) && ~flag
                            flag=1;
                            Source=[listing(ii).folder,'\',listing(ii).name,',1'];
                        else
                            Other{end+1}=[listing(ii).folder,'\',listing(ii).name,',1'];
                        end
                    end
                end
            end
        end
    else
        error('No .nii found in the source folder')
    end
end

elseif nargin==3
    if isstring(OtherFiles)==1
        Other{1}=[OtherFiles,',1'];
    else
        for ii=1:max(size(OtherFiles))
            Other{ii}=[OtherFiles{ii},',1'];
        end
    end
else
    error('No source or reference')
end

matlabbatch{1}.spm.spatial.coreg.estwrite.ref = {[Reference,',1']};
matlabbatch{1}.spm.spatial.coreg.estwrite.source = {Source};
matlabbatch{1}.spm.spatial.coreg.estwrite.other = Other';
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 4;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';
spm_jobman('run',matlabbatch);

end