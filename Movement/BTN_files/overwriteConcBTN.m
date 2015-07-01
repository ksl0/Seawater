function overwriteConcBTN(datFile, baseFile, outFileName)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Intended to overwrite the concentration data in .btn file 
% with matrix data from matlab 
%
% Katie Li
% June 22, 2015
% 
% Stroud Water Research Center
% University of Delaware
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set up constants, variables used in the function
% datFile: a Matlab matrix containing concentration data in the right
% orientation
% baseFile: origin BTN file used by SEAWAT
% outFileName: name of the output file 

    if nargin < 3   % current default values for inputs
        datFile = 'C6_1.mat';
        baseFile = 'OldTest.btn';
        outFileName = 'Test.btn'; 
    end 
    
    HEADER_TEXT = ' 103'; %used to match on a header
    nCCopy = 405; % number headers before you reach the concentration data
    %TODO: calculate a way to find this numer


    %% Start of script
    fout = fopen(outFileName, 'wt');
    mat = matfile(datFile); 
    cMat = mat.C; % extract variable
    %columns from left to right go sea to landward
    % solute concentrations should be in ML-3
    [rows, cols] = size(cMat); %save size of salinity matrix
    fid = fopen(baseFile,'r');

    tic; 
    %%% skips past two headers
    c = 0;
    while c < 2
        tline = fgets(fid);
        fprintf(fout, '%s', tline);
        c = c+1;
    end
    tline = fgets(fid); %% read first line of baseFile into tline
    k = strsplit(tline, ' '); %separate them by line
    nBlocks = str2double(cell2mat(k(2))); %conversion into comparable format
    nCells = str2double(cell2mat(k(3)));

    if (nCells ~= cols || nBlocks ~= rows) %wrong input values/dimensions
        disp('Wrong size inputs'); % matricies do not align to correct sizes
        return;
    end


    time = datestr(now, 29) %get current date
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
        for j = (cols+1):-1:1  %401 cells in each block 
          if  (j == (nCells+1))        % do not modify header
        	fprintf(fout, '%s', tline);
          else %rewrite data
            newConc = cMat(i, j); % newConc is the value to be written
            fprintf(fout, '%d\n', newConc); 
          end
          tline = fgets(fid); 
    	end
    end


    %% copy over the rest of the original file to the output file
    while ischar(tline) % while still reading the correct file
        fprintf(fout, '%s', tline);
        tline = fgets(fid); 
    end

    fclose(fout);

    toc; % a timer to view the runtime of the program
