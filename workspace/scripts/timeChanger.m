clear all;
DISC = {'disc134_800', 'disc134_1600', 'disc268_800', ...
       'disc268_1600', 'disc536_800'}; 

PROFILES = {'profile5.21.mat', 'profile5.30.mat'};
BASE_DIR ='/Users/katie/Desktop/ModelingSeawater/workspace';
BTN_FILE = 'Test.btn';
DIS_FILE = 'Test.dis';

for d = DISC
    for l=PROFILES
        disc = char(d);
        profile = char(p);
        input_dir = sprintf('%s/%s/%s', BASE_DIR, disc, profile);
        cd(input_dir);
        
    end
end