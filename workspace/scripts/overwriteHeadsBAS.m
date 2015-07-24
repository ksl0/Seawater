% This function creates revises the .bas file to describe the
% initial heads file more accurately, with the correct grid size
% You need to have MFlab paths set to run this function

function overwriteHeadsBAS(headFile,inputDir, rows, layers)
%ASSUMPTIONS
%  headFile has a 134 layers and 400 rows, represents the heads at steady state conditions 
%EXAMPLE USAGE
%headFile = 'heterogeneous5_30.bhd';
%input_dir = '/Users/katie/Desktop/ModelingSeawater/workspace/disc134_800/profile5.30.mat/';
%rows = 800;
%layers = 134;
%overwriteHeadsBAS(headFile, input_dir, rows, layers);


%% Setup constants for filename, header text
HEADER_TEXT = 'INTERNAL 1 (FREE)';
HEADER_SUBSTRING = 'INTERNAL';
BAS_FILE = 'Test.bas';
TEMP_FILE = 'TestX.bas';
SCRIPTS_DIR = '/Users/katie/Desktop/ModelingSeawater/workspace/scripts';

%% Get data from bhd file
H = readDat2(headFile);  %read in binary initial heads file 
nrow = H.NROW; 
nlay = numel(H.lays);
H_data = squeeze(H.values);

%% map the old array to the correct dimensions
STRETCH_X = rows/nrow;  %find the increase in horizontal, vertical cell number
STRETCH_Z = layers/nlay;
fprintf('%d %d; %d %d \n', rows, nrow, layers, nlay);

H_arr = discretizeArray(H_data,STRETCH_Z,STRETCH_X);%stretch array to correct size
% check to make sure H_arr is the correct size with assert statements
[xx, ll] = size(H_arr); assert(xx == rows); assert(ll == layers); 
disp(size(H_arr));
%% start to write to other file
cd(inputDir);
fid = fopen(BAS_FILE, 'r');
fout = fopen(TEMP_FILE, 'w');
%% A loop that copies over top part of file based on header counts
    % terminates by count of headers to skip

h = 0;
tline = fgets(fid); % read the next line
while  h <= layers
    fprintf(fout, '%s', tline); % write tline to fout
    tline = fgets(fid); % read the next line
    
    k = strfind(tline,HEADER_SUBSTRING);
    if (isempty(k))
      %print a line from the matrix         
    else 
       h  = h+ 1; % increment header
    end
end

%% write head data for each layer 
for i  = 1:layers
  fprintf(fout, '%s\n', HEADER_TEXT);
  newHEAD= H_arr(:,i); % newHEAD is the array of head values 
                         % from the completed simulation
  fprintf(fout, '%d\n', newHEAD);
end
figure;
imagesc(rot90(H_arr,3));
hold off;
%% overwrite inital head file
movefile(TEMP_FILE, BAS_FILE);
cd(SCRIPTS_DIR);

fclose(fout); %close files :) 
fclose(fid);
end
