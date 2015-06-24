%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Intended to overwrite the .btn file with matrix data from matlab 
%
% Katie Li
% June 22, 2015
% 
% Stroud Water Research Center
% University of Delaware
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set up constants
datFile = 'C6_1.mat';
baseFile = 'OldTest.btn';
outFileName = 'Test.btn';
HEADER_TEXT = ' 103'; %used to match on a header
nCCopy = 405; % unknown how to find this number
              % used to skip lines to copy

%% Start of script
fout = fopen(outFileName, 'wt');
mat = matfile(datFile); 
cMat = mat.C; % extract variable
%columns from left to right go sea to landward
% solute concentrations should be in ML-3
[rows, cols] = size(cMat); %salinity matrix
fid = fopen(baseFile,'r');

tic;
%%% skips past two headers
c = 0;
while c < 2
    tline = fgets(fid);
    fprintf(fout, '%s', tline);
    c = c+1;
end

tline = fgets(fid);
k = strsplit(tline, ' ');
nBlocks = str2double(cell2mat(k(2)));
nCells = str2double(cell2mat(k(3)));

if (nCells ~= cols || nBlocks ~= rows) %wrong input values/dimensions
    disp('Wrong size inputs');
    return;
end

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
%% Start to copy in data to the old file
% max cMat: cMat(134,400)


for i  = 1:rows 
    for j = (cols+1):-1:1  %401 in each block b/c 
        if  (j == (nCells+1))        % do not modify header
            fprintf(fout, '%s', tline);
        else %rewrite data
            newConc = cMat(i, j);
            fprintf(fout, '%d\n', newConc);
        end
        tline = fgets(fid);
    end
end



while ischar(tline)
    fprintf(fout, '%s', tline);
    tline = fgets(fid); % get header
end

fclose(fout);
toc;








