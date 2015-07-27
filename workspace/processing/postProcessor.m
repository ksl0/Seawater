function [results, y_km,z, C, data, Hv_data] = postProcessor(main_directory, input_directory,...
                   y_cells, z_cells, caseNum, runNum)
%% A modified post processor to return important variables in the matrix
% results from the outputs of a SEAWAT model.
% ASSUMPTIONS
% only one timestep, and for a two-dimensional system
%INPUTS
% main_directory: location of output files 
% Cell sizes, numbers  are for the geostat simulation
% x_cells: number cells parallel to coastline
% y_cells: number cells in the y direction (perpendicular to coastline) 
% z_cells: number cells in the z direction (depth)
% Cell lengths
% x_size: length of each cell in x direction (meters)
% y_size: length of each cell in y direction (meters)
% z_size:   length of each cell in z direction (meters)
% col_label_1: the label in column 1
% col_label_2: the label in column 2
% EXAMPLE USAGE:
%  main_directory = '~/Desktop/Katie/ModelingSeawater/workspace/output'
%  x_cells=1;                                                                
%  y_cells=400;                                                                
%  z_cells=134;                                                                
% results = July17Postprocess(main_directory, x_cells, y_cells, z_cells);
        
DENSITY_FRESH=1000;    %Density of fresh groundwater (kg/m^3)
DENSITY_SALINE=1025;     %Density of saline groundwater (kg/m^3)

DISTANCE_X = 200000; %default values for size of simulation
DISTANCE_Y = 200000; 
DISTANCE_Z = 402;

x_size = DISTANCE_X/y_cells;
y_size = DISTANCE_Y/y_cells;
z_size = DISTANCE_Z/z_cells;

TOTAL_VARIABLES = 21; % create a results matrix to store findings from SEAWAT output
results=zeros(1,TOTAL_VARIABLES);

% determine axis length for plotting and analysis
[y_km, z] = createAxis(y_cells, z_cells);
y = y_km.*1000;%convert back to meters

% import .mass, .unc file, .bud file, head file, 
% IMPORTANT!! You must first open readMT3D by MFlab and add to path
[Mass, Conc, Flow, Head, C] =loadFileData(input_directory); %C indicated processed concentration file
data = {Mass, Conc, Flow, Head};
[rows, ~] = size(C);

%% Rotating and simplifiying dimensions of a matrix
% MFlab reads in file in different orientation that expected
% squeeze eliminates the single dimension in the x-axis, and 
% the matrix is rotated 270 degrees to have a correct orientation

S = rot90(squeeze(Flow.term{1,1}),3);  %change in storage, S (m^3/s)                              
H = rot90(squeeze(Flow.term{1,2}), 3); %Volumetric flux through model boundaries 
                                       %due to prescrbed head boundary into matrix, H (m^3/s)
FF = rot90(squeeze(Flow.term{1,3}), 3); %Volumetric flux through front face of each cell (m^3/s)
FB = rot90(squeeze(Flow.term{1,4}), 3); %Volumetric flux through back face each cell
D = rot90(squeeze(Flow.term{1,5}), 3);  %DCDT (m^3/s/t)
Hd = rot90(Head.values, 3); %

processor_dir = strcat(main_directory, 'processing/'); 
cd(processor_dir);%TODO: edit this stuff!!
interface_area = findSizeMixingZone(C, 1,z_cells); %find the number of cells in the mixing zone 
fprintf('These values should be the same: zcells: %d rows: %d \n', z_cells, rows);
interface_top = findSizeMixingZone(C, 1,1); %determine cells of mixing zone on top interface
interface_bottom = findSizeMixingZone(C,1,z_cells); %determine cells in mixing zone on bottom interface

%%CALCULATIONS
format long

Sv_in=S; Sv_in(Sv_in<0)=0;       %Sv_in is positive changes in volumetric storage in each cell (m^3/s)
Sv_out=S; Sv_out(Sv_out>0)=0;    %Sv_out is negative changes in volumetric storage in each cell (m^3/s)
Hv_in=H; Hv_in(Hv_in > 0)=0;  %Hv_in is volumetric flow into the model due to prescribed head boundaries at each cell along the model boundary (m^3/s)
Hv_out=H; Hv_out(Hv_out < 0)=0; %  Hv_out is volumetric flow out of the model due to prescribed head boundaries at each cell along the model boundary (m^3/s)

Hv_in_fresh=Hv_in(:,y_cells);                                       %Hv_in_fresh is fresh volumetric flow into the profile in each cell (m^3/s)
Hv_in_saline=Hv_in(:,1:y_cells-1);                                  %Hv_in_saline is saline volumetric flow into the profile in each cell (m^3/s)
Hm_in_fresh=Hv_in_fresh.*DENSITY_FRESH;                                %Hm_in_fresh is fresh mass flux into the profile in each cell (kg/s)
Hm_in_saline=Hv_in_saline.*DENSITY_SALINE;                             %Hm_in_saline is saline mass flux into the profile in each cell (kg/s)


Sum_Hm_in=sum(sum(sum(Hm_in_fresh)))+sum(sum(sum(Hm_in_saline)));   %Total mass flux into the profile from prescribed head boundaries (kg/s)--compare to list file

fraction_saline=C/35;                                               %Calculate fraction saline at each cell
fraction_fresh=1-C/35;                                              %Calculate fraction fresh at each cell
Hv_out_fresh=Hv_out.*fraction_fresh;                                %Hv_out_fresh is fresh volumetric flow out of profile from each cell (m^3/s)
Hv_out_saline=Hv_out.*fraction_saline;                              %Hv_out_saline is saline volumetric flow out of profile from each cell (m^3/s)
Hm_out_fresh=Hv_out_fresh.*DENSITY_FRESH;                              %Hm_out_fresh is fresh mass flux out of the profile from each cell (kg/s)
Hm_out_saline=Hv_out_saline.*DENSITY_SALINE;                           %Hm_out_saline is saline mass flux out of the profile from each cell(kg/s)

Sum_Hm_out=abs(sum(sum(sum(Hm_out_fresh)))+sum(sum(sum(Hm_out_saline))));     %Total mass flux out of the profile from prescribed head boundaries (kg/s)--compare to list file

SGD_fresh=abs(sum(sum(sum(Hv_out_fresh))));                         %Total fresh SGD from profile (m^3/s)
SGD_saline=abs(sum(sum(sum(Hv_out_saline))));                       %Total saline SGD from profile (m^3/s)
Recharge_fresh=sum(sum(sum(Hv_in_fresh)));                          %Total fresh recharge into profile (m^3/s)
Circulation_saline=sum(sum(sum(Hv_in_saline)));                     %Total saltwater circulation into profile (m^3/s)

Sv_in_fresh=Sv_in.*fraction_fresh;                                  %Sv_out_fresh is fresh volumetric change in storage for each cell (m^3/s)
Sv_in_saline=Sv_in.*fraction_saline;                                %Sv_out_saline is saline volumetric change in storage for each cell (m^3/s)
Sm_in_fresh=Sv_in_fresh.*DENSITY_FRESH;                                %Sm_out_fresh is fresh mass flux change in storage for each cell (kg/s)
Sm_in_saline=Sv_in_saline.*DENSITY_SALINE;                             %Sm_out_saline is fresh mass flux change in storage for each cell(kg/s)
Storage_gain=abs(sum(sum(sum(Sm_in_fresh)))+sum(sum(sum(Sm_in_saline))));

Sv_out_fresh=Sv_out.*fraction_fresh;                                %Sv_out_fresh is fresh volumetric flow (-) change in storage for each cell (m^3/s)
Sv_out_saline=Sv_out.*fraction_saline;                              %Sv_out_saline is saline volumetric flow (-) change in storage for each cell (m^3/s)
Sm_out_fresh=Sv_out_fresh.*DENSITY_FRESH;                              %Sm_out_fresh is fresh mass flux (-) change in storage for each cell (kg/s)
Sm_out_saline=Sv_out_saline.*DENSITY_SALINE;                           %Sm_out_saline is fresh mass flux (-) change in storage for each cell(kg/s)
Storage_loss=abs(sum(sum(sum(Sm_out_fresh)))+sum(sum(sum(Sm_out_saline))));

%Save the volumetric flux to an 'H' variable
Hv_data = [];
Hv_data.Hv_in_fresh = Hv_in_fresh;
Hv_data.Hv_in_saline = Hv_in_saline;
Hv_data.Hv_out_saline = Hv_out_saline;
Hv_data.Hv_out_fresh = Hv_out_fresh;

%Need to figure out how to handle DCDT--requires multiplying by the
%length of the last transport step--I need to figure out where to
%import this from

DCDT_inc=99999;
DCDT_dec=99999;

interface_areaT=interface_area*y_size*z_size;                       %Calculation of interface_area (m^2), the area of the model domain where concentration is between 10% and 90% saline
interface_topT=interface_top*y_size;
interface_bottomT=interface_bottom*y_size;
velocities_y=FF./(x_size*z_size);                                   %y velocities in m/s
velocities_z=FB./(x_size*y_size);                                   %z velocieties in m/s

Peclet_y=velocities_y.*(y_size/200);                                %Calculate Peclet numbers 
Peclet_z=velocities_z.*(z_size/2);

M_0=sum(sum(sum(C)));
M_y=0;
for i=1:z_cells
    M_y=M_y+sum(sum(C(i,:).*y));
end
Cy=M_y/M_0; %Center of mass, y direction (m)

M_z=0;
for i=1:y_cells
    M_z=M_z+sum(sum(C(:,i).*z));
end
Cz=M_z/M_0;   %Center of mass, z direction (m)
      
% Find Volume mass balance error in [m^3/s]
F_INS=sum(sum(Hv_in)); 
F_OUTS=sum(sum(Hv_out)); 
Fluid_MBerror=(F_INS+F_OUTS)/F_INS*100;
disp(Fluid_MBerror);

%% 
results(1,3)=Sum_Hm_in;
results(1,4)=Sum_Hm_out;
results(1,5)=Recharge_fresh;
results(1,6)=SGD_fresh;
results(1,7)=Circulation_saline;
results(1,8)=SGD_saline;

%% Publishable values
results(1,9)=Storage_gain; %
results(1,10)=Storage_loss; %
results(1,13)=interface_areaT;
results(1,14)=interface_topT;
results(1,15)=interface_bottomT;
results(1,16)=Cy;
results(1,17)=Cz;

%% less important variables
results(1,1)=caseNum;
results(1,2)=runNum;
results(1,18)=min(min(C));
results(1,19)=max(max(C));
results(1,20)=max(max(Peclet_y));
results(1,21)=max(max(Peclet_z));
results(1,11)=DCDT_inc; %<----------------Not correct!!
results(1,12)=DCDT_dec; %<----------------Not correct!!

results(1,22) = z_cells;
results(1,23) = y_cells;

%% Save file
cd(main_directory);
filename =sprintf('results%d%d.mat', caseNum, runNum);
disp(filename);

cd(strcat(main_directory, 'processing'));
%save(filename, results);
%TODO: refactor the '3D' out of it
end

