clear all;
clc;
MAIN_DIR = '/Users/katie/Desktop/ModelingSeawater/workspace/';

PROFILES= {'profile5.30.mat'};
DISC= {'disc134_800'};

%PROFILES= {'profile5.30.mat', 'profile5.21.mat'};
%DISC= {'disc134_800', 'disc134_1600', 'disc268_800', 'disc268_1600', 'disc536_800'};
pattern_profile =  '(profile|\.|mat)';
pattern_disc =  '(disc|_)';

resultsMat = zeros(numel(PROFILES)* numel(DISC), 23);
i =1;
for d = DISC
    for p = PROFILES
        disc = char(d); profile = char(p); %annoying conversion factor for cells
        bar = regexp(profile, pattern_profile, 'split');
        caseNum = str2double(bar{2}); runNum = str2double(bar{3}); %extract the numbers 
        foo = regexp(disc, pattern_disc, 'split');
        z_cells = str2double(foo(2)); y_cells = str2double(foo(3));

        
        input_dir = strcat(MAIN_DIR, '/', disc, '/', profile);
        
        
        [results, y_km, z, C, data] = postProcessor(MAIN_DIR, input_dir, y_cells, z_cells, caseNum,runNum);
        plotSalinity(profile, disc , C, y_km, z)
        resultsMat(i, :) = results;
        i = i+1;
    end
end

disp('done :)');

