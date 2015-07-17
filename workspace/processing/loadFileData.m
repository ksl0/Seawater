% This script reads in the 
% prerequisites: load the MFlab file paths
% example usage-
%   dir = '~/Desktop/ModelingSeawater/workspace/disc134_800/profile5.30.mat';
%   [m,c, f, h] = loadFileData(dir);

function [mass, conc, flow, head, concSimplified] = loadFileData(input_file_directory)
    cd(input_file_directory);
    
    MASS_FILE = 'TestA.mass'; %default filenames for SEAWAT output data
    CONC_FILE = 'TestA.ucn';
    HEAD_FILE = 'Test.bhd';
    BUD_FILE = 'Test.bud';

    mass =importdata(MASS_FILE);                                          
    conc =readMT3D(CONC_FILE,'','','','',''); %get concentration data
    concSimplified = rot90(squeeze(conc.values),3); %remove 1 dimension
    flow =readBud6(BUD_FILE);                                               
    head =readDat2(HEAD_FILE);
end
