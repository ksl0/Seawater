% A short script that uses nameFileWriter and dspWriter
% to set up the input values for a dispersivity test
% Katie Li, katiesli16@gmail.com
% Modified July 27th, 2015

% Assumptions
% There are already the correct files within the base input folder 
BASE_DIR = '/Users/katie/Desktop/ModelingSeawater/workspace/';
PROFILE = 'profile5.30'; %case 5 run 30

NLAY= 268;
NROW= 800;
%al = [5 10 100 200 250 400 500];
al = 5;

for i = 1:numel(al)
  dispersivityValue = al(i);
  dispFolder= sprintf('%s%sdisp%d', BASE_DIR, 'dispersivity/', dispersivityValue);
  nameFileWriter(PROFILE, dispFolder); %add the name file into the folders
  dspWriter(NROW, NLAY, al(i), dispFolder); % write specific name file for the folder
end
