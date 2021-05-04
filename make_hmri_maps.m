function make_hmri_maps(InputFolder,OutputFolder)

listing = struct2cell(dir(InputFolder));
Position=zeros(7,size(listing,2));

% Get the folder of each images
Position(1,:) = contains(listing(1,:),'B1mapping');
Position(2,:) = contains(listing(1,:),'gre_field');
Position(3,:) = contains(listing(1,:),'mt_al');
Position(4,:) = contains(listing(1,:),'pd_al');
Position(5,:) = contains(listing(1,:),'t1_al');
Position(6,:) = contains(listing(1,:),'BC');
Position(7,:) = contains(listing(1,:),'HC');

if any(Position(6,:))
    DoRFcorrection=true;
else
    DoRFcorrection=false;
end

matlabbatch{1}.spm.tools.hmri.create_mpm.subj.output.outdir = OutputFolder;
matlabbatch{1}.spm.tools.hmri.create_mpm.subj.b1_type.i3D_EPI.b1input = '<UNDEFINED>';
matlabbatch{1}.spm.tools.hmri.create_mpm.subj.b1_type.i3D_EPI.b0input = '<UNDEFINED>';
matlabbatch{1}.spm.tools.hmri.create_mpm.subj.b1_type.i3D_EPI.b1parameters.b1metadata = 'yes';
matlabbatch{1}.spm.tools.hmri.create_mpm.subj.raw_mpm.MT = '';
matlabbatch{1}.spm.tools.hmri.create_mpm.subj.raw_mpm.PD = '';
matlabbatch{1}.spm.tools.hmri.create_mpm.subj.raw_mpm.T1 = '';
matlabbatch{1}.spm.tools.hmri.create_mpm.subj.popup = true;

if DoRFcorrection
    matlabbatch{1}.spm.tools.hmri.create_mpm.subj.sensitivity.RF_once = '<UNDEFINED>';
else
    matlabbatch{1}.spm.tools.hmri.create_mpm.subj.sensitivity.RF_us = '-';
end

spm_jobman('run',matlabbatch);

end