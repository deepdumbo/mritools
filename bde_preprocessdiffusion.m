basedir = '/mnt/diskArray/projects/MRI/NLR_204_AM'
t1dir = '/mnt/diskArray/projects/anatomy/NLR_204_AM'
rawdir = fullfile(basedir,'raw');
d64 = dir(fullfile(rawdir,'*DWI64_*.nii.gz'));
d32 = dir(fullfile(rawdir,'*DWI32_*.nii.gz'));
b0 = dir(fullfile(rawdir,'*DWI6_*.nii.gz'));
dMRI64Files{1}=fullfile(rawdir,d64.name);
for ii = 1:length(b0)
    dMRI64Files{1+ii}=fullfile(rawdir,b0(ii).name);
end
% Bvals and Bvecs files
for ii = 1:length(dMRI64Files)
    bvals64{ii} = [prefix(prefix(dMRI64Files{ii})) '.bvals'];
    bvecs64{ii} = [prefix(prefix(dMRI64Files{ii})) '.bvecs'];
end
% Phase encode matrix
%pe_mat = [0 1 0; 0 1 0; 0 -1 0];
pe_mat = [0 1 0;0 -1 0];
% Directory to save everything
outdir64 = fullfile(basedir,'dmri64');
% Pre process
fsl_preprocess(dMRI64Files, bvecs64, bvals64, pe_mat, outdir64);
% Now run dtiInit
params = dtiInitParams;
dtEddy = fullfile(outdir64,'eddy','data.nii.gz');
params.bvalsFile = fullfile(outdir64,'eddy','bvals');
params.bvecsFile = fullfile(outdir64,'eddy','bvecs');
params.eddyCorrect=-1;
%params.outDir = fullfile(basedir,'dti64');
params.rotateBvecsWithCanXform=1;
params.phaseEncodeDir=2;
params.clobber=1;
t1 = fullfile(t1dir,'t1_acpc.nii.gz');
dt6FileName = dtiInit(dtEddy,t1,params);

%% Run AFQ
%afq = AFQ_Create('sub_dirs',fileparts(dt6FileName{1}),'sub_group',0,'computeCSD',1);
afq = AFQ_Create('sub_dirs',fileparts(dt6FileName{1}),'sub_group',0,'run_mode','test');
afq = AFQ_run([],[],afq);


