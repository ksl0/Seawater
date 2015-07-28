function nameFileWriter(profile, input_dir)
% A name file writer fo rthe structure unique to dispersivities
% example profile = 'profile6.24';
initial_dir = pwd;
cd(input_dir); % go to the input directory
fid = fopen('Test.nam','w'); %open file named Test.nam

fprintf(fid, 'LIST 13 Test.lst\n');% contains info specific to file
fprintf(fid, 'DIS 14 ..\\%s\\Test.dis\n', profile);
fprintf(fid, 'BAS6 15 ..\\%s\\Test.bas\n', profile);
fprintf(fid, 'OC 18 ..\\%s\\Test.oc\n', profile);
fprintf(fid, 'LPF 19 ..\\%s\\Test.lpf\n', profile);
fprintf(fid, 'GMG 20 ..\\%s\\Test.gmg\n', profile);
fprintf(fid, 'VDF 21 ..\\%s\\Test.vdf\n', profile);
fprintf(fid, 'BTN 22 ..\\%s\\Test.btn\n', profile);
fprintf(fid, 'ADV 23 ..\\%s\\Test.adv\n', profile);
fprintf(fid, 'DSP 24 Test.dsp\n'); %DSP file is unique to dispersivity run
fprintf(fid, 'SSM 25 ..\\%s\\Test.ssm\n', profile); %included in each of the folders 
fprintf(fid, 'GCG 26 ..\\%s\\Test.gcg\n', profile);
fprintf(fid, 'DATA 199 ..\\%s\\Test.cnf\n', profile);
fprintf(fid, 'DATA(BINARY) 201 TestA.ucn\n');
fprintf(fid, 'DATA 401 TestA.mto\n');
fprintf(fid, 'DATA 601 TestA.mass\n');
fprintf(fid, 'LMT6 28 Test.lmt\n');
fprintf(fid, 'DATA(BINARY) 12 Test.bhd REPLACE\n');
fprintf(fid, 'DATA(BINARY) 11 Test.bud REPLACE\n');

cd(initial_dir); %return to initial directory
end
