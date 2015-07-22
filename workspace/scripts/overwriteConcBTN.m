function [nlays,nrows] = overwriteConcBTN(matName, baseFile,inputFolderName)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Intended to overwrite the concentration data in .btn file 
% with matrix data from matlab 
% Returns the size of the matrix for use by other files
%
% Katie Li, katiesli16@gmail.com
% July 6, 2015
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
% overwriteConcBTN('C5_30.mat', 'Test.btn','disc134_800/profile5.30.mat');

    BASE_DIR = '/Users/katie/Desktop/ModelingSeawater/workspace/';
    scriptsDir = strcat(BASE_DIR, 'scripts/');
    inFileDir = strcat(BASE_DIR, inputFolderName);
    
    cd(scriptsDir);
    
    disp('Preparing to overwrite BTN file...');
    
    arr = matfile(matName); arr = arr.C; %extract variable from matfile
    HEADER_TEXT = '103   '; %used to match on a header


    %% Start of script
    
    cd(inFileDir); %go the input file directory
    outFileName = 'temp';
    fout = fopen(outFileName, 'wt');
    %columns from left to right go sea to landward
    % solute concentrations should be in ML-3
    fid = fopen(baseFile,'r');
    
    disp(fout); disp(fid);
    %%% copy the two headers
    c = 0;
    while c < 2
        tline = fgets(fid);
        fprintf(fout, '%s', tline);
        c = c+1;
    end
    
    tline = fgets(fid); %% read first line of baseFile into tline
    k = strsplit(tline, ' '); %separate them by line
 
    nlays = str2double(cell2mat(k(2))); %conversion into comparable format
    nrows = str2double(cell2mat(k(3)));
    
    nCCopy = 3*nlays + 3; % number headers before you reach the concentration data 
    disp(nCCopy);
    
    X_initial = 400; %SET VALUE BASED ON INPUT MATRIX USUAL SIZE
    Z_initial= 134; %default for slices, in comparison to old
    ZSTRETCH = nlays/Z_initial;
    XSTRETCH = nrows/X_initial;
    % the X and Z discretization
    
    cd(scriptsDir); % go to the scripts directory
    arr = discretizeArray(arr, XSTRETCH, ZSTRETCH);
    [rows, cols] = size(arr); %save size of salinity matrix    
     
    assert(nrows == cols);   %check and print out sizes
    assert(nlays == rows);
    
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
    assert(c == 8); % Assert statement for specific format
                    % If c > 8 , it is likely that the wrong lines were
                    % overwritten
   
    fclose(fout); %close files
    fclose(fid);
    
    cd(inFileDir);% move over files to correct locations
    
    copyfile(baseFile, strcat('old', baseFile)); % create a copy of old file
    movefile(outFileName, baseFile); % overwrite file
    
    cd(scriptsDir); % go back to original file placement 
    disp('Finished running BTN file');
end
