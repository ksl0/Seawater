function dspWriter(nrow, nlay, al, outputFolder)
    % A file that creates a new DSP file to fit a grid
    % * nrow: number of cells in the x direction (width)
    % * nlay: number of layers in the z direction (depth of aquifer)
    % * al: longitudinal dispersivity for every cell in the grid
    % modified  July 22,  2015 
    % author: Katie Li, katiesli16@gmail.com
    % ex: nrow = 800, nlay = 134, al=200 (reflecting the scale of the simulation)

    cd(outputFolder);
    HEADER_TEXT= '       103        1.                             0'; %unknown how header text formed
    scripts_dir = '/Users/katie/Desktop/ModelingSeawater/workspace/scripts';

    % ratio of horizontal transverse dispersivity to longitudinal dispersivity 
    TRPT = 1;
    TRPT_STRING = sprintf('%d*1.000000000000E-00%d', nlay, TRPT);
    % ratio of vertical transverse dispersivity to longitudinal dispersivity 
    TRPV = 2;
    TRPV_STRING = sprintf('%d*1.000000000000E-00%d', nlay, TRPV);
    % effective molecular diffision coefficient
    DMCOEF = 11;
    DMCOEF_STRING = sprintf('%d*1.000000000000E-0%d', nlay, DMCOEF);
    OUTPUT_NAME = 'Test.dsp';

    fid= fopen(OUTPUT_NAME, 'w');
    layer_al = ones(nrow,1).*al; %create array filled with values of 
                                   % longitudinal dispersivity
    
    %C1 array: longitudintal dispersivity
    % Please see p. 118 of http://hydro.geo.ua.edu/mt3d/mt3dmanual.pdf
    % for more documentation
    for i = 1:nlay
        fprintf(fid, '%s \n', HEADER_TEXT); % write standard header
        fprintf(fid,'%d \n', layer_al); % write field conductivity data, 
    end

    % C2: write horizontal transverse dispersivity 
    fprintf(fid, '%s\n', HEADER_TEXT); 
    fprintf(fid, '%s\n', TRPT_STRING); 
    % C3: write horizontal transverse dispersivity 
    fprintf(fid, '%s\n', HEADER_TEXT); 
    fprintf(fid, '%s\n', TRPV_STRING); 
    % C4: write effective molecular diffusion coefficient
    fprintf(fid, '%s\n', HEADER_TEXT); 
    fprintf(fid, '%s\n', DMCOEF_STRING);
      	
    fclose(fid); % close file 
    disp('finished writing dispersion file for MT3DMS'); %indicate to user file done
    cd(scripts_dir);
end
