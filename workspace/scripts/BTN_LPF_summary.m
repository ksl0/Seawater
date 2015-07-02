
% A summary script to overwrite BTN and LPF files

% USAGE: 
% The directory structure should resemble the following tree:
% - base directory
%   - scripts 
%   - input directory

BTN_INPUT = 'C5_43.mat'; %concentration data file
LPF_INPUT = 'case5_1.mat'; % hydraulic conductivity data file
BTN_file= 'Test.btn';  
LPF_file = 'Test.lpf';  

disc = {'disc1', 'disc2', 'disc3'}; % folders with input file by ArgusONE
tic;                                                                   
for f = disc % for each discretization, run programs below
   folder = char(f);
   [r, c] = overwriteConcBTN(BTN_INPUT, BTN_file, 'modified_btn.btn', folder);
   lpfTransformer(r, c, folder, LPF_INPUT, LPF_file); 
   fprintf('Finished running for %s discretization \n', folder);
end


fprintf('Total running time is');
toc;