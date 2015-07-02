% June 06 2013
% A file that overwrites an exisiting LPF file to it's format

Ss = 1e-4; %default value for specific storage
XSTRETCH = 4;  % the X and Z discretization
ZSTRETCH = 2;
ZCELLS = 200; %default number of X direction for discretization
OUTPUT_NAME = 'modified_lpf.lpf';
INPUT_FILE = 'Test.lpf';
MATLAB_ARRAY = 'case5_1.mat';
nCCopy = 42; % number of header lines to skip

%headers to write to file
HEADER_HK = 'INTERNAL 1.0 (FREE)   -1  ; HK(NCOL,NROW)';
HEADER_VKA = 'INTERNAL 1.0 (FREE)   -1  ; VKA(NCOL,NROW)';
HEADER_SS = 'INTERNAL 1.0 (FREE)   -1  ; Ss(NCOL,NROW)';

SS_ARR = Ss*ones(ZSTRETCH*ZCELLS, 1);  %create array to write to file
disp(size(SS_ARR));
% open new file to write into, also get 
fout = fopen(OUTPUT_NAME, 'w');
fid = fopen(INPUT_FILE, 'r');

%load MATLAB array containing the total hydraulic conductivities
load(MATLAB_ARRAY); %extracts a variable named 'c'

%convert the array to conductivity values
arr = mapArray(c);

% transform array to correct dimensions based on discretization
newArr = discretizeArray(arr, XSTRETCH, ZSTRETCH);
[row, columns] = size(newArr);
kArr = newArr; save('TestLPF.mat', 'newArr'); % save array, perhaps

% Write new header material
tline = fgets(fid); %write the first one
fprintf(fout, '%s', tline); % write tline to fout
tline = fgets(fid); %skip second header line

% A loop that copies over top part of file based on header counts
% terminates by count of headers to skip
i = 0;
while  i <= nCCopy
    fprintf(fout, '%s', tline); % write tline to fout
    tline = fgets(fid); % read the next line
    i  = i+ 1; % increment header
end

%% overwrite the text
for i = 1:row
    layer = newArr(i, :);
    
    fprintf(fout, '%s\n', HEADER_HK); % write header
    fprintf(fout,'%6.12E \n', layer); % write field conductivity data, HK and HVK are the same
    disp(size(layer));

    fprintf(fout, '%s\n', HEADER_VKA); % write header
    fprintf(fout,'%6.12E\n' , layer); % write field conductivity data, HK and HVK are the same
    
    fprintf(fout, '%s\n', HEADER_SS); % print the SS data
    fprintf(fout, '%6.12E \n' , SS_ARR);
end
    
fclose(fid); % close files
fclose(fout);
