% Testing salinity script -- the summary script - sensitivity test for
% mixing zone width
% pre: run setup.m, and also have the MFlab paths on 
% July 15, 2015

PROFILES= {'profile5.30.mat', 'profile5.21.mat'};
DISC= {'disc134_800', 'disc134_1600', 'disc268_800', 'disc268_1600', 'disc536_800'};

d = DISC{1};
pattern_disc =  '(disc|_)';
foo = regexp(d, pattern_disc, 'split');
z_cells = foo{2}; y_cells = foo{3};

results = zeros(numel(PROFILES)*numel(DISC), 4); %create a results matrix
%% Go through all of the salinities
i = 0;
for d = DISC
    for p = PROFILES
    
    disc = char(d); profile = char(p); %annoying conversion factor for cells
    % go to the correct directory
    input_dir = sprintf('%s/%s/%s', BASEDIR, disc, profile);
    CONCENTRATION_MAT = c; % actually, get this from the pattern matching, lines 8 - 11

    [a, b] = size(c); %% checking for mistaken size inputs
    disp(' %s %s', (z_cells==a), (y_cells==b)); 

    topLayer = c(1,:); bottomLayer = c(z_cells, :); % get respective layers
    %between  10% and 90% salinity, 3.5 and 31.5 ppt total dissolved solids
    interface_t = numel(topLayer(topLayer > 3.5 && topLayer < 31.5));
    interface_b = numel(bottomLayer(bottomLayer > 3.5 && bottomLayer < 31.5));
    interface_top = interface_t*y_cells; 
    interface_bottom = interface_b*y_cells;
    
    results(i, 1) = profile;
    results(i, 2) = disc;
    results(i, 3) = interface_top;
    results(i, 4) = interface_bottom;
    
    i = i +1;
    end
end

    
    
    


