function [nrows,ncols] = overwriteConcBTN(matName, baseFile, outFileName,inputFolderName)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Intended to overwrite the concentration data in .btn file 
% with matrix data from matlab 
% Returns the size of the matrix for use by other files
%
% Katie Li, katiesli16@gmail.com
% June 22, 2015
% 
% Modified July 1, 2015
% 
% Stroud Water Research Center
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set up constants, variables used in the function
% arr: array containing the values to overwrite in correct orientation
% baseFile: original BTN file used by SEAWAT
% outFileName: name of the output file 
% 

% EXAMPLE USAGE: 
%  overwriteConcBTN('C5_43.mat', 'Test.btn', 'modified_btn.btn', 'disc1');
%
    BASE_DIR = '/Users/katie/Desktop/ModelingSeawater/workspace/';
    scriptsDir = 'scripts/';
    
    cd(strcat(BASE_DIR, scriptsDir)); % go to the scripts directory
    
    disp('Preparing to overwrite BTN file...');
    
    arr = matfile(matName); arr = arr.C; %extract variable from matfile
    HEADER_TEXT = '103        1. '; %used to match on a header
    nCCopy = 539; % number headers before you reach the concentration data
    % for some reason, it seems to be correlated to the stretch in x
    % direction
    % as in disc1 - 539, but disc2 - 271
    %TODO: calculate a way to find this numer


    %% Start of script
    
    cd(strcat(BASE_DIR, inputFolderName)); %go the input file directory
    fout = fopen(outFileName, 'wt');
    %columns from left to right go sea to landward
    % solute concentrations should be in ML-3
    fid = fopen(baseFile,'r');
    
    disp(fout); disp(fid);
    %%% skips past two headers
    c = 0;
    while c < 2
        tline = fgets(fid);
        fprintf(fout, '%s', tline);
        c = c+1;
    end
    
    tline = fgets(fid); %% read first line of baseFile into tline
    k = strsplit(tline, ' '); %separate them by line
 
    nrows = str2double(cell2mat(k(2))); %conversion into comparable format
    ncols = str2double(cell2mat(k(3)));
    
    X_initial = 400; %SET VALUE BASED ON INPUT MATRIX USUAL SIZE!!
    Z_initial= 134; %default for slice 
    ZSTRETCH = nrows/Z_initial;
    XSTRETCH = ncols/X_initial;
    % the X and Z discretization
    
    cd(strcat(BASE_DIR, scriptsDir)); % go to the scripts directory
    arr = discretizeArray(arr, XSTRETCH, ZSTRETCH);
    [rows, cols] = size(arr); %save size of salinity matrix    
     
    assert(ncols == cols);   %check and print out sizes
    assert(nrows == rows);
    
    time = datestr(now, 29); %get current date
    %Write header for SEAWATBTN file
    str = sprintf('#BTN file created using MATLAB on %s', time);
    fprintf(fid,'%s\r\n',str);  

    % A loop that copies over top part of file based on header counts
    % terminates by count of headers to skip
    h = 0;
    while  h <= nCCopy
        fprintf(fout, '%s', tline); % write tline to fout
        tline = fgets(fid); % read the next line
        
        k = strfind(tline,HEADER_TEXT);
        if (isempty(k))
          %print a line from the matrix         
        else 
           h  = h+ 1; % increment header
        end
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Start to copy in new data from datFile, ignoring values from OldTest.btn
    % The strange movement and modifications in here is due to the offset
    % needed for each header, which takes up a line. 

    for i  = 1:rows 
        for j = (cols+1):-1:1  %cells in each block 
          if  (j == (cols+1))        % do not modify header
        	fprintf(fout, '%s', tline);
          else %rewrite data
            newConc = arr(i, j); % newConc is the value to be written
            fprintf(fout, '%d\n', newConc);
          end
          tline = fgets(fid); 
        end
    end


    %% copy over the rest of the original file to the output file
    c = 0;
    while ischar(tline) % while still reading the correct file
        fprintf(fout, '%s', tline);
        tline = fgets(fid); 
        c = c + 1;
    end
    assert(c == 8); % you need to have 8 lines only
    
    fclose(fout);
    fclose(fid); %close files
    
    disp('Finished running BTN file');
end

