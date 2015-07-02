% June 06 2013
% A file that overwrites an exisiting LPF file to it's format
function lpfTransformer(nrows, ncols)
    % usage: for disc1, a cell of 268 rows x 800 columns
    %         do lpfTransformer(268, 800);
    BASE_DIR = '/Users/katie/Desktop/ModelingSeawater/workspace/';
    inputFileDir = 'disc1/';
    scriptsDir = 'scripts/';

    Ss = 1e-4; %default value for specific storage
    X_initial = 200; Z_initial= 134; %default for slice 
    ZSTRETCH = nrows/Z_initial;
    XSTRETCH = ncols/X_initial;
    % the X and Z discretization
 
    OUTPUT_NAME = 'modified_lpf.lpf';
    INPUT_FILE = 'Test.lpf';
    MATLAB_ARRAY = 'case5_1.mat';
    load(MATLAB_ARRAY); %load MATLAB array with hydraulic conductivity, 'c'
    nCCopy = 79; % number of header lines to skip

    %headers to write to file
    HEADER_HK = 'INTERNAL 1.0 (FREE)   -1  ; HK(NCOL,NROW)';
    HEADER_VKA = 'INTERNAL 1.0 (FREE)   -1  ; VKA(NCOL,NROW)';
    HEADER_SS = 'INTERNAL 1.0 (FREE)   -1  ; Ss(NCOL,NROW)';

    SS_ARR = Ss*ones(XSTRETCH*X_initial, 1);  %create array to write to file
     
    disp(size(SS_ARR));
    
    cd(strcat(BASE_DIR, inputFileDir)); %go the file directory
    % open new file to write into, also get MATLAB array
    fout = fopen(OUTPUT_NAME, 'w');
    fid = fopen(INPUT_FILE, 'r');
 
    
    cd(strcat(BASE_DIR, scriptsDir)); %get back to scripts directory
    arr = mapArray(c);  %convert the array (of values 0-3) to conductivity values

    % transform array to correct dimensions based on discretization
    newArr = discretizeArray(arr, XSTRETCH, ZSTRETCH);
    
    [row, ~] = size(newArr); 
    save('TestLPF.mat', 'newArr'); % save array, perhaps comment this line

    %% Write new header material
    tline = fgets(fid); %write the first one
    fprintf(fout, '%s', tline); % write the first line to output file
    tline = fgets(fid); %skip second header line

    % Copies over top part of input file to output file
    i = 0;
    while  i <= nCCopy
        fprintf(fout, '%s', tline); % write line to output file
        tline = fgets(fid); % read the next line
        i  = i+ 1; % increment header
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

    disp('finished overwriting program'); %indicate to user file done
end
