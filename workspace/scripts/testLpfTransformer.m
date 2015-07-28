clear all;
SCRIPTS_DIR = '/Users/katie/Desktop/ModelingSeawater/workspace/scripts';

%set up variables so MFlab can read in the file
initial_LPF = [];  
initial_LPF.NLAY = 134;
initial_LPF.NROW = 400;
initial_LPF.NCOL = 1;
initial_LPF.isTran =  1;
initial_LPF.LAYCBD =zeros(initial_LPF.NLAY);
initial_LPF_dir= '/Users/katie/Desktop/ModelingSeawater/Matlab_code/profile5_30.lpf';
initial_LPF = readLPF(initial_LPF_dir, initial_LPF);

%% Check the horizontal discretization

% read in the LPF file from 2x row discretization
transformed_LPF = [];
transformed_LPF.NLAY = 134;
transformed_LPF.NROW = 800;
transformed_LPF.NCOL = 1;
transformed_LPF.isTran =  1;
transformed_LPF.LAYCBD =zeros(transformed_LPF.NLAY);
transformed_LPF_dir= strcat('/Users/katie/Desktop/ModelingSeawater/workspace/' ...
                         ,'disc134_800/profile5.30.mat/Test.lpf');
transformed_LPF = readLPF(transformed_LPF_dir, transformed_LPF);

cd(SCRIPTS_DIR);

% plot the original horizontal transmissivity
h = figure; subplot(4,1,1);
imagesc(unMapArray(squeeze(initial_LPF.KH)))
colormap('gray');
% plot the discretized one to see the similarities
subplot(4,1,2);
imagesc(unMapArray(squeeze(transformed_LPF.KH)))
colormap('gray');

% plot original vertical transmissivity
subplot(4,1,3);
imagesc(unMapArray(squeeze(initial_LPF.KV)))
colormap('gray');
% plot the new LPF file
subplot(4,1,4);
imagesc(unMapArray(squeeze(transformed_LPF.KV)))
colormap('gray');

% test statements to 
assert(isequal(transformed_LPF.LAYTYP, initial_LPF.LAYTYP));
assert(isequal(transformed_LPF.LAYAVG, initial_LPF.LAYAVG));
assert(isequal(transformed_LPF.CHANI, initial_LPF.CHANI));
assert(isequal(transformed_LPF.LAYVKA, initial_LPF.LAYVKA));
assert(isequal(transformed_LPF.LAYWET, initial_LPF.LAYWET));

%% Check the layers discretization
figure;
lpf2 = [];
lpf2.NLAY = 268;
lpf2.NROW = 800;
lpf2.NCOL = 1;
lpf2.isTran =  1;
lpf2.LAYCBD =zeros(lpf2.NLAY);
lpf2_dir= strcat('/Users/katie/Desktop/ModelingSeawater/workspace/' ...
                         ,'disc268_800/profile5.30.mat/Test.lpf');
lpf2 = readLPF(lpf2_dir, lpf2);



% plot original vertical transmissivity
subplot(2,1,1);
imagesc(unMapArray(squeeze(initial_LPF.KV)))
colormap('gray');
% plot the new LPF file
subplot(2,1,2);
imagesc(unMapArray(squeeze(lpf2.KV)))
colormap('gray');

