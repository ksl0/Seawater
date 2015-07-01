% June 06 2013
% A file that overwrites an exisiting LPF file to it's format

%default value for specific storage
% Ss = 1e-4
% XSTRETCH = 2  % the X and Z discretization
% ZSTRETCH = 2 
% OUTPUT_NAME = 'modified_lpf.lpf'
% INPUT_FILE = 'Test.lpf'
% MATLAB_ARRAY = 'Sim1.47.mat'

%load MATLAB array containing the total hydraulic conductivities

%convert the array to conductivity values
% arr = mapArray(a);

% transform and shift array to correct dimensions based on discretization
% newArr = discretizeArr(arr, XSTRETCH, ZSTRETCH)
% [row columns] = size(newArr);
% save('TestLPF.mat',newArr) % save array for later usage and inspection

% open new file to write into
% Write new header material

%fprintf(out,'%s\r\n','#lpf file created using MATLAB');                
% time = datestr(now, 29);
%fprintf(out,'%s\r\n', time); 

% for i = 1:rows
 % layer = newArr(i, :);
 % fprinf(out, layer);
% end 

% fclose(out);
