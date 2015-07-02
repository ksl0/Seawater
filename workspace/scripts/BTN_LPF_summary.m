
% A summary script to overwrite BTN and LPF files

% USAGE: 
% The directory structure should resemble the following tree:
% - base directory
%   - scripts 
%   - input directory

BTN_INPUT = 'C5_30.mat'; %concentration data file
LPF_INPUT = 'Profile5.30.mat'; % hydraulic conductivity data file
BTN_file= 'Test.btn';  
LPF_file = 'Test.lpf';  
SCRIPTS_DIR = '/Users/katie/Desktop/ModelingSeawater/workspace/scripts';

%disc = {'disc1', 'disc2', 'disc3'}; % folders with input file by ArgusONE
disc = {'disc0'}; disp('short time period, temporary')%temporary for now... 
tic;                                                                   
for f = disc % for each discretization, run programs below
   folder = char(f);
   [r, c] = overwriteConcBTN(BTN_INPUT, BTN_file, 'modified_btn.btn', folder);
   cd(SCRIPTS_DIR);
   lpfTransformer(r, c, folder, LPF_INPUT, LPF_file); 
   fprintf('Finished running for %s discretization \n', folder);
end


toc;