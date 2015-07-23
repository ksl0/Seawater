% A single-use script to overwrite BTN, BAS and LPF file at the given
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
BASE_DIR = '/Users/katie/Desktop/ModelingSeawater/workspace';
SCRIPTS_DIR = strcat(BASE_DIR, '/scripts');

%Discretization, discz_x, where z represents vertical cell number and x
%   represents the number of cells in the x direction
DISC = {'disc134_800', 'disc134_1600', 'disc268_800', ...
         'disc268_1600', 'disc536_800'}; 
pattern_disc =  '(disc|_)';

C0 = 5; run0 = 30; run1 = 21; %case and run numbers
TOTAL_PROFILES = {[C0, run0];[C0,run1]}; %holder for all profiles
[profiles, ~] = size(TOTAL_PROFILES);

tic;         
% create input files for every discretization, and hydraulic cond. profile
cd(SCRIPTS_DIR); %ensure in correct place
for d = DISC 
   for l= 1:profiles 
       disc = char(d);
       pCase = TOTAL_PROFILES{l}(1); %set profile case and run numbers
       pRun = TOTAL_PROFILES{l}(2); 
       
       % get the discretization rows and layers
       foo = regexp(disc, pattern_disc, 'split');
       nLayers = str2double(foo{2});
       nrows = str2double(foo{3});
       
       
       % input matlab files from Kaileigh's simulations
       LPF_INPUT = sprintf('Profile%d.%d.mat', pCase, pRun); %concentration 
       BTN_INPUT = sprintf('C%d_%d.mat', pCase, pRun); % hydraulic conductivity 
       HEAD_INPUT = sprintf('heterogeneous%d_%d.bhd', pCase,pRun);

       %file folder -- example: disc134_800/profile5.30.mat,
       folder = sprintf('%s/%s', disc, lower(LPF_INPUT)); 
       original_files = sprintf('%s/basefiles', disc);
       
       input_dir = sprintf('%s/%s', BASE_DIR, folder);
       cd(BASE_DIR); %copyfile(original_files, input_dir) %create copy of input files
       cd(SCRIPTS_DIR);
      
       %overwrite the Head files
       overwriteHeadsBAS(HEAD_INPUT,input_dir, nrows, nLayers);
       
       [r, c] = overwriteConcBTN(BTN_INPUT, BTN_file, folder);
       lpfTransformer(r, c, folder, LPF_INPUT, LPF_file); 
       fprintf('Finished writing input file for %s discretization \n',folder);
       disp('');
   end
end
toc;

cd(SCRIPTS_DIR);