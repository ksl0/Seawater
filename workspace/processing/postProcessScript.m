clear all;
%MAIN_DIR = '/Users/katie/Desktop/ModelingSeawater/workspace/';
MAIN_DIR = 'C:\Users\Admin\Desktop\KatieLi\Seawater\workspace\';
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
        
        [results, y_km, z, C, data, H_dat] = postProcessor(MAIN_DIR, input_dir, y_cells, z_cells, caseNum,runNum);
        % create salinity and bar plots
        plotSalinity(profile, disc , C, y_km, z)
        plot_title = sprintf('%s %s', profile, disc);
        barPlots(plot_title, y_km, H_dat.Hv_out_fresh, H_dat.Hv_out_saline,H_dat.Hv_in_saline)
        resultsMat(i, :) = results;
        i = i+1;
    end
end

disp('done :)');

