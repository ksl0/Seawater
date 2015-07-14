% A single-use script to overwrite BTN and LPF file at the given
% discretization and hydraulic conductivity profiles

% USAGE: 
% The initial directory structure should resemble the following tree:
% - base directory
%   - scripts: contains functions overwriteConcBTN, lpfTransformer, etc.
%   - dicretization directory
%     - basefiles
%       - Test.btn
%       - Test.lpf

BTN_file= 'Test.btn';  
LPF_file = 'Test.lpf';  
BASE_DIR = '/Users/katie/Desktop/ModelingSeawater/workspace/';
SCRIPTS_DIR = strcat(BASE_DIR, 'scripts/');

%Discretization, discz_x, where z represents vertical cell number and x
%   represents the number of cells in the x direction
disc = {'disc134_800', 'disc268_800', 'disc268_1600'}; 

C0 = 5; run0 = 30; run1 = 21; %case and run numbers
TOTAL_PROFILES = {[C0, run0];[C0,run1]}; %holder for all profiles
[layers, ~] = size(TOTAL_PROFILES);

tic;         
% create input files for every discretization, and hydraulic cond. profile
cd(SCRIPTS_DIR); %ensure in correct place
for f = disc 
   for l= 1:layers 
       fld = char(f); 
       pCase = TOTAL_PROFILES{l}(1); %set profile case and run numbers
       pRun = TOTAL_PROFILES{l}(2); 
       
       % input matlab files from Kaileigh's simulations
       LPF_INPUT = sprintf('Profile%d.%d.mat', pCase, pRun);  %concentration data file
       BTN_INPUT = sprintf('C%d_%d.mat', pCase, pRun); % hydraulic conductivity data file

       %file folder -- example: disc134_800/profile5.30.mat,
       folder = sprintf('%s/%s', fld, lower(LPF_INPUT)); 
       original_files = sprintf('%s/basefiles', fld);
       
       cd(BASE_DIR); copyfile(original_files, folder) %create copy of input files
       cd(SCRIPTS_DIR);
       [r, c] = overwriteConcBTN(BTN_INPUT, BTN_file, folder);
       lpfTransformer(r, c, folder, LPF_INPUT, LPF_file); 
      fprintf('Finished writing input file for %s discretization \n',folder);
   end
end
toc;

cd(SCRIPTS_DIR);

%% TODO:
% 1. Remove the 'temp.btn' file from overwriteConcBTN - it's not necessary
% and it's too confusing
% 2. Make sure in the right file path for overwriteConcBTN and
% lpfTransformer
% 3. get some rest
%generally takes 2-3 minutes to run