%%INPUTS

main_directory='E:/Jan28';                                                   %Enter name of main directory
cd(main_directory);
coordinate_file='Input_data2/Coord';                                         %Enter name and location of coordinate file (Matlab matrix with x, y, z values corresponding to facies values

set_num=7;                                                                  %Enter connectivity case number
low=44;                                                                      %Enter lowest run number in series
high=44;                                                                    %Enter highest run number in series
profile_xvalue=40000;                                                       %Enter x value of profile
 
x_cells=50;                                                                 %Enter number of cells in the x direction for geostat simulation
y_cells=200;                                                                %Enter number of cells in the y direction for geostat simulation
z_cells=134;                                                                %Enter number of cells in the z direction for geostat simulation
matrix_total=x_cells*y_cells*z_cells;
length=y_cells*z_cells;

ss=1e-4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%DEFINITIONS

profile_min=profile_xvalue-1;                                               %Defines limits for selecting 2D profile from 3D matrix
profile_max=profile_xvalue+1;

load(coordinate_file);                                                      %Loads x, y, z values in Matlab matrix

%%REPEATED PROCESSES

n=0;
for p=low:high                                                              %For each run, loop will make a 2D profile and plot the facies values; write a Modflow lpf and run Modflow; calculate Ky_eff, Qy error, Kz_eff, and Qz error; and write Seawat homogeneous and heterogeneous lpfs 
    n=n+1;                                                                  %n is row number for the 'Results' matrix
    
    %%MAKE 2D PROFILE

    set=int2str(set_num);                                                   %Create string label for the set
    run=int2str(p);                                                         %Create string label for the run
    cd(main_directory);
    input_file='Input_data2/Simset.run.mat';
    input_file=strrep(input_file,'set',set);
    input_file=strrep(input_file,'run',run);
    load(input_file);                                                       %Loads facies values in Matlab matrix

    profile_name='profile set.run';                                         %Create string label for profile with set and run
    profile_name=strrep(profile_name,'set',set);
    profile_name=strrep(profile_name,'run',run)

    A=[Coord Values];                                                       %Create x, y, z and facies values in one matrix

    B=zeros(length,5);                                                      %Preallocate B, matrix that holds the x, y, z, and facies values of the 2D profile
    row=0;
    count=0;
    mc_sand=0;
    fine_sand=0;
    silt=0;
    clay=0;
    for i=1:matrix_total
        row=row+1; 
        if A(row,1)>profile_min && A(row,1)<profile_max;                    %Select rows of the 3D matrix with the proper x value for the profile
            count=count+1; 
            B(count,1:4)=A(row,1:4);                                        %Load them into B (columns 1-4)
            if A(row,4)<1                                                   %Assign the appropriate hydraulic conductivity value to B (column 5)
                B(count,5)=1e-13;
                clay=clay+1;
            elseif A(row,4)<2
                B(count,5)=1e-8;
                silt=silt+1;
            elseif A(row,4)<3
                B(count,5)=1e-5;
                fine_sand=fine_sand+1;
            else
                B(count,5)=1e-3;
                mc_sand=mc_sand+1;
            end
        end
    end

    %%WRITE HETEOGENEOUS SEAWAT LPF

    cd(main_directory);
    lpf2Dhet='Seawat_lpfs\Heterogeneous\profileset_run.lpf';           %Open blank heterogeneous Seawat lpf file for the run in Seawat_lpfs>TwoD>Heterogeneous
    lpf2Dhet=strrep(lpf2Dhet,'set',set);
    lpf2Dhet=strrep(lpf2Dhet,'run',run);
    fid2=fopen(lpf2Dhet, 'W');
    
    fprintf(fid2,'%s\r\n','#lpf file created using MATLAB');                %Write header for Seawat lpf file
    fprintf(fid2,'%s\r\n','#7/7/14'); 
    fprintf(fid2,'%d %6.12E\t%d\t%s\r\n',11, -2e+20, 0, '; ILPFCB, HDRY, NPLPF');
    for i =1:z_cells;
        fprintf(fid2,'%d ',0);
    end
    fprintf(fid2,'%s\r\n','; LAYTYP(NLAY)');
    for i =1:z_cells;
        fprintf(fid2,'%d ',0);
    end
    fprintf(fid2,'%s\r\n','; LAYAVG(NLAY)');
    for i =1:z_cells;
        fprintf(fid2,'%9.12E0 ',1);
    end
    fprintf(fid2,'%s\r\n','; CHANI(NLAY)');
    for i =1:z_cells;
        fprintf(fid2,'%d ',0);
    end
    fprintf(fid2,'%s\r\n','; LAYVKA(NLAY)');
    for i =1:z_cells;
        fprintf(fid2,'%d ',0);
    end
    fprintf(fid2,'%s\r\n','; LAYWET(NLAY)');

    hk_count=0;
    vk_count=0;
    ss_count=0;
    for k=1:z_cells
        fprintf(fid2,'%s\r\n','INTERNAL 1.0 (FREE)   -1  ; HK(NCOL,NROW)'); %Proceed through each layer (top to bottom) listing Ky and Kz values
        for j_1=1:y_cells
            hk_count=hk_count+1;
            hk=B(length+1-hk_count,5);
            hk_str=sprintf('%6.12E',hk);
            hk_str=strrep(hk_str, 'E-', 'E-0');
            fprintf(fid2, '%s\n',hk_str);
            fprintf(fid2, '%s\n',hk_str);
        end
        fprintf(fid2,'%s\r\n','INTERNAL 1.0 (FREE)   -1  ; VKA(NCOL,NROW)');
        for j_4=1:y_cells
            vk_count=vk_count+1;
            vk=B(length+1-vk_count,5);
            vk_str=sprintf('%6.12E',vk);
            vk_str=strrep(vk_str, 'E-', 'E-0');
            fprintf(fid2, '%s\n',vk_str);
            fprintf(fid2, '%s\n',vk_str);
        end
        fprintf(fid2,'%s\r\n','INTERNAL 1.0 (FREE)   -1  ; Ss(NCOL,NROW)');
        for j=1:y_cells
            ss_count=ss_count+1;
            ss_str=sprintf('%6.12E',ss);
            ss_str=strrep(ss_str, 'E-', 'E-0'); 
            fprintf(fid2, '%s\n',ss_str); 
            fprintf(fid2, '%s\n',ss_str);
        end
    end
    fclose(fid2);

end
