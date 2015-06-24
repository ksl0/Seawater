%%
% 06/23/2015
% Uses MFlab to modify data

basename = 'OldTest.btn';
newFileName = 'TestingMFlab';

btn = [];
btn = readBTN(basename, btn);
%{
datFile = 'C6_1.mat';
mat = matfile(datFile); cMat = mat.C; % extract variable
[row, col] = size(cMat);

conc = btn.STCONC; [row2, col2] = size(cell2mat(conc));

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
btn.Z = btn.DZ;
%}

writeBTN(newFileName, btn);
