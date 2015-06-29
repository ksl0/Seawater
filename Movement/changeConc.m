%%
% 06/23/2015
% Uses MFlab to modify data

% set up the names for the input files
basename = 'OldTest.btn';
newFileName = 'Test-wmod';

btn = []; %initialize the btn variable to an empty array
btn = readBTN(basename, btn);


datFile = 'C6_1.mat';
mat = matfile(datFile); cMat = mat.C; % extract variable
[row, col] = size(cMat);


% check size of the two arrays
[row2, col2] = size(cell2mat(btn.STCONC));

if (row == col2 && col == row2)
    cMat = transpose(cMat);
    cMat = flip(cMat,1); %fliprows
    cMat2(:,1,:) = cMat;
    btn.STCONC = {cMat2};
elseif (row == row2 && col == col2)
    cMat2(:,1,:) = cMat;
    btn.STCONC = {cMat2};
else
    disp('Sizes of matrices do not match');
    return;
end;


btn.ext = 'btn';
btn.Z = btn.DZ; % attempt to guess what the btn.Z parameter refers to

writeBTN(newFileName, btn);
