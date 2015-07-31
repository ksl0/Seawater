function lpfTransformer(nrows, ncols, inputFolderName, matFile, caseNum, inputFile)
    % A file that overwrites an exisiting LPF file to it's format
    % usage: for disc1, a cell of 268 rows x 800 columns, run: 
    %    lpfTransformer(268, 800, 'disc1', 'Profile5.47.mat', 'Test.lpf');
    % Parameters
    % * nrows - vertical discretization
    % * ncols - horizontal discretization 
    % * inputFolderName - the folder, on the same base directory
    % modified  June 06 2013
    % author: Katie Li, katiesli16@gmail.com
    
    BASE_DIR = '/Users/katie/Desktop/ModelingSeawater/workspace/';
    scriptsDir = strcat(BASE_DIR, 'scripts/');
    HEADER_SUBSTRING = 'INTERNAL'; %indicates reaching a header line
    
    cd(scriptsDir); %start at the correct location

    Ss = 1e-4; %default value for specific storage
    X_initial = 400; Z_initial= 134; %default for slice 
    ZSTRETCH = nrows/Z_initial;
    XSTRETCH = ncols/X_initial;
    % the X and Z discretization
 
    OUTPUT_NAME = 'modified_lpf.lpf';
    INPUT_FILE = inputFile;
    MATLAB_ARRAY = sprintf('/Users/katie/Desktop/ModelingSeawater/Input_data/Profiles/Case%d/%s',caseNum, matFile); 
    load(MATLAB_ARRAY); arr = Profile; %load MATLAB array with hydraulic conductivity, 'Profile'

    %headers to write to file
    HEADER_HK = 'INTERNAL 1.0 (FREE)   -1  ; HK(NCOL,NROW)';
    HEADER_VKA = 'INTERNAL 1.0 (FREE)   -1  ; VKA(NCOL,NROW)';
    HEADER_SS = 'INTERNAL 1.0 (FREE)   -1  ; Ss(NCOL,NROW)';
    
    
    SS_ARR = Ss*ones(XSTRETCH*X_initial, 1);  %create array to write to file
     
    
    cd(strcat(BASE_DIR, inputFolderName)); %go the file directory
    % open new file to write into, also get MATLAB array
    fout = fopen(OUTPUT_NAME, 'w');
    fid = fopen(INPUT_FILE, 'r');
    
    cd(scriptsDir); %get back to scripts directory
    % arr = mapArray(Profile);  %convert the array (of values 0-3) to conductivity values
    
    % transform array to correct dimensions based on discretization,
    % orientation
    newArr = discretizeArray(arr, XSTRETCH, ZSTRETCH);
    newArr = flip(newArr,2); %flip the array 180 degrees
    
    colormap(gray);
    imagesc(unMapArray(newArr)); %visualize output array
    [row, ~] = size(newArr); 

    
    %% Write new header material
    k = []; %indicator value for header
    fgets(fid); %discard first line in the file, rewrite header in line below
    tline = sprintf('#Written with MATLAB lpfTransformer %s \n', datestr(now, 29)); 
    
    % Copies over top part of input file to output file
    while isempty(k) %as long as the header has not been found
        k = strfind(tline,HEADER_SUBSTRING); %check to see if the head is found
        if isempty(k)
            fprintf(fout, '%s', tline); % write the first line to output file
        end 
        tline = fgets(fid); % read the next line into variable 'tline'
    end

    %% overwrite the text
    for i = 1:row
        layer = newArr(i, :); % Vertical hydraulic conductivity (VKA) and hydraulic 
                              % conductivity (HK) along rows are the same
        fprintf(fout, '%s\n', HEADER_HK); % write HK (hydraulic conductivity) header
        fprintf(fout,'%6.12E \n', layer); % write field conductivity data, 
        %disp(size(layer));

        fprintf(fout, '%s\n', HEADER_VKA); % write VKA (vertical hydraulic conductivity) header
        fprintf(fout,'%6.12E\n' , layer); 
	
        fprintf(fout, '%s\n', HEADER_SS); % write header for specific storage
        fprintf(fout, '%6.12E \n' , SS_ARR);% write the specific storage data 
    end
	
    fclose(fid); % close files
    fclose(fout);
    
    % move over files to correct locations
    cd(strcat(BASE_DIR, inputFolderName));
    
    movefile(inputFile, strcat('old', inputFile)); %create a copy
    movefile(OUTPUT_NAME, inputFile);
  
    cd(scriptsDir); % go back to old directory
    disp('finished overwriting program'); %indicate to user file done
end
