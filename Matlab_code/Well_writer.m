main_directory='F:/Jan28';
cd(main_directory);


layers=133; %Number of layers in unit 2
for i=1:5
set=num2str(R(i,1));
run=num2str(R(i,2))
recharge=R(i,3);  %fresh recharge in m^3/s

cell_recharge=recharge/layers;
well_file='Well_files/Caseset/wset_run.wel';
well_file=strrep(well_file,'set',set);
well_file=strrep(well_file,'set',set);
well_file=strrep(well_file,'run',run);
fid1=fopen(well_file,'W');

fprintf(fid1,'%s\r\n','#Well file for homogeneous equivalent model');
fprintf(fid1,'%s\r\n','#Created in Matlab by KC');
fprintf(fid1,'%s\r\n','133 11 NOPRINT');
fprintf(fid1,'%s\r\n','133 0');

for z=2:(layers+1)
    fprintf(fid1,'%d',z);
    fprintf(fid1,'%s',' 1 1 ');
    cell_recharge_str=sprintf('%1.12E',cell_recharge);
    cell_recharge_str=strrep(cell_recharge_str,'E-','E-0');
    fprintf(fid1,'%s\n',cell_recharge_str);
end
fclose(fid1);
end