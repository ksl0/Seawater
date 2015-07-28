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
    TRPT = 1e-3 ;
    % ratio of vertical transverse dispersivity to longitudinal dispersivity 
    TRPV = 1e-4;
    % effective molecular diffision coefficient
    DMCOEF = 1e-11;
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
    fprintf(fid, '%6.12E\n', TRPT*nlay); 
    % C3: write horizontal transverse dispersivity 
    fprintf(fid, '%s\n', HEADER_TEXT); 
    fprintf(fid, '%6.12E\n', TRPV*nlay); 
    % C4: write effective molecular diffusion coefficient
    fprintf(fid, '%s\n', HEADER_TEXT); 
    fprintf(fid, '%6.12E\n', DMCOEF*nlay);
      	
    fclose(fid); % close file 
    disp('finished writing dispersion file for MT3DMS'); %indicate to user file done
    cd(scripts_dir);
end
