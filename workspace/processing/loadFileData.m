% This script reads in the 
% prerequisites: load the MFlab file paths
% example usage-
%   dir = '~/Desktop/ModelingSeawater/workspace/disc134_800/profile5.30.mat';
%   [m,c, f, h] = loadFileData(dir);

function [mass, conc, flow, head] = loadFileData(input_file_directory)
    cd(input_file_directory);
    
    MASS_FILE = 'TestA.mass'; %default filenames for SEAWAT output data
    CONC_FILE = 'TestA.ucn';
    HEAD_FILE = 'Test.bhd';
    BUD_FILE = 'Test.bud';

    mass =importdata(MASS_FILE);                                          
    conc_data =readMT3D(CONC_FILE,'','','','',''); %get concentration data
    conc = conc_data.values;
    flow =readBud6(BUD_FILE);                                               
    head =readDat2(HEAD_FILE);
end