BASE_DIR = '/Users/katie/Desktop/ModelingSeawater/workspace/';
PROFILE = 'profile5.30.mat';
DISC = 'disc134_800';

outputFolder= sprintf('%s%s/%s', BASE_DIR, DISC, PROFILE);

nrow = 800;
nlay = 134;
al = 200;

dspWriter(nrow, nlay, al, outputFolder);
