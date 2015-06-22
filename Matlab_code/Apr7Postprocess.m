
%%The following values will be output to the matrix called Results:
    %Column 1:  Connectivity case number (set_num)
    %Column 2:  Run number (p)
    %Column 3:  Total mass flow entering prescribed head boundaries to check against list file, kg/s (Sum_Hm_in)
    %Column 4:  Total mass flow exiting prescribed head boundareis to check against list file, kg/s (Sum_Hm_in)
    %Column 5:  Fresh recharge entering model, m^3/s (Recharge_fresh)
    %Column 6:  Fresh SGD exiting model, m^3/s (SGD_fresh)
    %Column 7:  Saline circulation entering model, m^3/s (Circulation_saline)
    %Column 8:  Saline SGD exiting model, m^3/s (SGD_saline)
    %Column 9:  Total increase in model mass flow storage to check against list file, kg/s (Storage_gain)
    %Column 10: Total decrease in model mass flow storage to check against list file, kg/s (Storage_loss)
    %Column 11: Total increase in DCDT (DCDT_inc)<---Still figuring this out
    %Column 12: Total decrease in DCDT (DCDT_dec)<---Still figuring this out
    %Column 13: Area of interface between 10% and 90% saline, m^2 (interface_area)
    %Column 14: Length of interface between 10% and 90% saline at model top, m (interface_top)
    %Column 15: Length of interface between 10% and 90% saline at model bottom, m (interface_bottom)
    %Column 16: Wedge center of mass y coordinate, m (Cy)
    %Column 17: Wedge center of mass z coordinate, m (Cz)
    %Column 18: Minimum concentration check, ppt (C)
    %Column 19: Maximum concentration check, ppt (C)
    %Column 20: Maximum Peclet number, y direction (Peclet_y)
    %Column 21: Maximum Peclet number, z direction (Peclet_z)
    

% clear all

%%INPUTS

main_directory='G:/Two_D seawat models/Final output/Case1';     %Enter location of output files
mass_file='TestA.mass';                                                     %Enter name of .mass file
conc_file='TestA.ucn';                                                      %Enter name of .ucn file
bud_file='Test.bud';                                                        %Enter name of .bud file
head_file='Test.bhd';

test='6';                                                                   %Enter test number string (after T)
type='Het';                                                                 %Enter 'Hom' or 'Het'
set_num=1;                                                                  %Enter connectivity case number
low=2;                                                                     %Enter lowest run number in series
high=50;                                                                    %Enter highest run number in series

x_cells=1;                                                                  %Enter number of cells in the x direction (parallel to coastline) of geostat simulation
y_cells=400;                                                                %Enter number of cells in the y direction (perpendicular to coastline) for geostat simulation
z_cells=134;                                                                %Enter number of cells in the z direction (depth) for geostat simulation
x_size=500;                                                                 %Enter length of each cell in x direction (meters)
y_size=500;                                                                 %Enter length of each cell in y direction (meters)
z_size=3;                                                                   %Enter length of each cell in z direction (meters)
timesteps=1;                                                                %Enter number of printout timesteps for concentration file)
        
dens_fresh=1000;                                                    %Density of fresh groundwater (kg/m^3)
dens_saline=1025;                                                   %Density of saline groundwater (kg/m^3)
conc_fresh=0;                                                       %Concentration of fresh groundwater (ppt)
conc_saline=35;                                                     %Concentration of saline groundwater (ppt)

h_land=10.0;                                                              % Head at landward boundary [m]
h_sea=0.0;                                                               % Head along seaward boundary [m]
% K=(5.0e-7)*ones(z_cells,y_cells);                                                                % Hydraulic conductivity [m/s]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%DEFINITIONS

y(1,y_cells)=zeros;                                                         
y_count=0;
for i=1:y_cells
    y_count=y_count+1;
    y(1,y_count)=-(y_size/2)+(y_size)*y_count;                              %Defines y axis in meters
end
y_km=y./1000;                                                               %Defines y axis in kilometers

z(z_cells,1)=zeros;     %KAILEIGH: note I had to change 134 to z_cells here and below
z_count=0;
for i=1:z_cells
    z_count=z_count+1;
    z(z_count,1)=(z_size/2)-(z_size)*z_count;                               %Defines z axis in meters
end

%%REPEATED ANALYSES

for p=low:high                                                              %Each loop analyzes output and creates figures for one run
                                                                            
    cd(main_directory);                 
% profile_folder='Dtesttypeset.run';
% profile_folder=strrep(profile_folder,'test',test);
    profile_folder='typeset.run';
    profile_folder=strrep(profile_folder,'type',type);
    set=int2str(set_num);
    profile_folder=strrep(profile_folder,'set',set);
    run=int2str(p);
    profile_folder=strrep(profile_folder,'run',run)

% 
    cd(profile_folder);                                                     %Move into the folder for a particular profile (ex=T1Het4.5)

    %%IMPORT DATA
    
    Mass=importdata(mass_file);                                             %Import .mass file
    Concentration=readMT3D(conc_file,'','','','','');                       %Import .ucn file and load concentration data into structure array, Concentration (must first open readMT3D by MFlab and add to path)
    Flow=readBud6(bud_file);                                                %Import .bud file and load budget data into structure array, Flow (must first open readMT3D by MFlab and add to path)
    Head=readDat2(head_file);
    
    x=1;
    Results(high-low+1,21)=zeros;
    for k=1:x_cells                                                         %Loops through each profile in a 3D block (3D processing portion of code is still incomplete
        x=x+1;
        x_str=num2str(x);
        
        %%ORGANIZE DATA

        S(z_cells,y_cells)=zeros;                                           %Load change in storage in each cell into matrix, S (m^3/s)                                       
        layer_count=0;
        for i=1:z_cells
            layer_count=layer_count+1;
            row_count=0;
            for j=1:y_cells
                row_count=row_count+1;
                S(layer_count,row_count)=Flow.term{1,1}(y_cells+1-row_count,1,layer_count);  
            end
        end

        H(z_cells,y_cells)=zeros;                                           %Load volumetric flux through model boundaries due to prescrbed head boundary into matrix, H (m^3/s)
        layer_count=0;
        for i=1:z_cells
            layer_count=layer_count+1;
            row_count=0;
            for j=1:y_cells
                row_count=row_count+1;
                H(layer_count,row_count)=Flow.term{1,2}(y_cells+1-row_count,1,layer_count);  
            end
        end
        
            cd(main_directory);
            boundary_file='Boundary_flow_matrices/Hset_run.mat'
            boundary_file=strrep(boundary_file, 'set', set); 
            boundary_file=strrep(boundary_file,'run',run);
            %save(boundary_file,'H');
            cd(profile_folder); 
        
        FF(z_cells,y_cells)=zeros;                                          %Load volumetric flux through front face of each cell (m^3/s)
        layer_count=0;
        for i=1:z_cells
            layer_count=layer_count+1;
            row_count=0;
            for j=1:y_cells
                row_count=row_count+1;
                FF(layer_count,row_count)=Flow.term{1,3}(y_cells+1-row_count,1,layer_count);  
            end
        end
        
            cd(main_directory);
            frontflow_file='Front_flow_matrices/FFset_run.mat'
            frontflow_file=strrep(frontflow_file, 'set', set); 
            frontflow_file=strrep(frontflow_file,'run',run);
            %save(frontflow_file,'FF');
            cd(profile_folder);
        
        FB(z_cells,y_cells)=zeros;                                          %Load volumetric flux through bottom face of each cell (m^3/s)
        layer_count=0;
        for i=1:z_cells
            layer_count=layer_count+1;
            row_count=0;
            for j=1:y_cells
                row_count=row_count+1;
                FB(layer_count,row_count)=Flow.term{1,4}(y_cells+1-row_count,1,layer_count);  
            end
        end
        
            cd(main_directory);
            bflow_file='Bottom_flow_matrices/FBset_run.mat'
            bflow_file=strrep(bflow_file, 'set', set); 
            bflow_file=strrep(bflow_file,'run',run);
            %save(bflow_file,'FB');
            cd(profile_folder);
        
        D(z_cells,y_cells)=zeros;                                           %Load DCDT (m^3/s/t)
        layer_count=0;
        for i=1:z_cells
            layer_count=layer_count+1;
            row_count=0;
            for j=1:y_cells
                row_count=row_count+1;
                D(layer_count,row_count)=Flow.term{1,5}(y_cells+1-row_count,1,layer_count);  
            end
        end

        
        C(z_cells,y_cells)=zeros;                                           %Load salt concentration (ppt) in each cell into matrix, C
        layer_count=0;
        interface_area=0;
        centroid_y=0;
        centroid_z=0
        for i=1:z_cells
            layer_count=layer_count+1;
            row_count=0;
            for j=1:y_cells
                row_count=row_count+1;
                C(layer_count,row_count)=Concentration(timesteps).values(y_cells+1-row_count,1,layer_count);    
                if C(layer_count,row_count)<31.5 & C(layer_count,row_count)>3.5     %Count every cell with concentration between 10% and 90% saline (does not interpolate)
                    interface_area=interface_area+1;
                    centroid_y=centroid_y+row_count*y_size-(y_size/2);
                    centroid_z=centroid_z+layer_count*z_size-(z_size/2);
                end
            end
        end
        interface_top=0;
        row_count=0;
            for j=1:y_cells
                row_count=row_count+1; 
                if C(1,row_count)<31.5 & C(layer_count,row_count)>3.5     %Count every cell with concentration between 10% and 90% saline (does not interpolate)
                    interface_top=interface_top+1;
                end
            end
            interface_bottom=0;
            row_count=0
            for j=1:y_cells
                row_count=row_count+1; 
                if C(z_cells,row_count)<31.5 & C(layer_count,row_count)>3.5     %Count every cell with concentration between 10% and 90% saline (does not interpolate)
                    interface_bottom=interface_bottom+1;
                end
            end
            
%             cd(main_directory);
%             concentration_file='Concentration_matrices/Cset_run.mat'
%             concentration_file=strrep(concentration_file, 'set', set); 
%             concentration_file=strrep(concentration_file,'run',run);
%             save(concentration_file,'C');
%             cd(profile_folder); 

        Hd(z_cells,y_cells)=zeros;                                           
        layer_count=0;
        for i=1:z_cells
            layer_count=layer_count+1;
            row_count=0;
            for j=1:y_cells
                row_count=row_count+1;
                Hd(layer_count,row_count)=Head.values(y_cells+1-row_count,1,layer_count);  
            end
        end


        %%CALCULATIONS

        format long

        Sv_in=S; Sv_in(Sv_in<0)=0;                                          %Sv_in is positive changes in volumetric storage in each cell (m^3/s)
        Sv_out=S; Sv_out(Sv_out>0)=0;                                       %Sv_out is negative changes in volumetric storage in each cell (m^3/s)
        Hv_in=H; Hv_in(Hv_in<0)=0;                                          %Hv_in is volumetric flow into the model due to prescribed head boundaries at each cell along the model boundary (m^3/s)
        Hv_out=H; Hv_out(Hv_out>0)=0;                                       %Hv_out is volumetric flow out of the model due to prescribed head boundaries at each cell along the model boundary (m^3/s)
        Dv_in=D; Dv_in(Dv_in<0)=0;
        Dv_out=D; Dv_out(Dv_out>0)=0;

        Hv_in_fresh=Hv_in(:,y_cells);                                       %Hv_in_fresh is fresh volumetric flow into the profile in each cell (m^3/s)
        Hv_in_saline=Hv_in(:,1:y_cells-1);                                  %Hv_in_saline is saline volumetric flow into the profile in each cell (m^3/s)
        Hm_in_fresh=Hv_in_fresh.*dens_fresh;                                %Hm_in_fresh is fresh mass flux into the profile in each cell (kg/s)
        Hm_in_saline=Hv_in_saline.*dens_saline;                             %Hm_in_saline is saline mass flux into the profile in each cell (kg/s)
        
        Sum_Hm_in=sum(sum(sum(Hm_in_fresh)))+sum(sum(sum(Hm_in_saline)));   %Total mass flux into the profile from prescribed head boundaries (kg/s)--compare to list file

        fraction_saline=C/35;                                               %Calculate fraction saline at each cell
        fraction_fresh=1-C/35;                                              %Calculate fraction fresh at each cell
        Hv_out_fresh=Hv_out.*fraction_fresh;                                %Hv_out_fresh is fresh volumetric flow out of profile from each cell (m^3/s)
        Hv_out_saline=Hv_out.*fraction_saline;                              %Hv_out_saline is saline volumetric flow out of profile from each cell (m^3/s)
        Hm_out_fresh=Hv_out_fresh.*dens_fresh;                              %Hm_out_fresh is fresh mass flux out of the profile from each cell (kg/s)
        Hm_out_saline=Hv_out_saline.*dens_saline;                           %Hm_out_saline is saline mass flux out of the profile from each cell(kg/s)
        
        Sum_Hm_out=abs(sum(sum(sum(Hm_out_fresh)))+sum(sum(sum(Hm_out_saline))));     %Total mass flux out of the profile from prescribed head boundaries (kg/s)--compare to list file

        SGD_fresh=abs(sum(sum(sum(Hv_out_fresh))));                         %Total fresh SGD from profile (m^3/s)
        SGD_saline=abs(sum(sum(sum(Hv_out_saline))));                       %Total saline SGD from profile (m^3/s)
        Recharge_fresh=sum(sum(sum(Hv_in_fresh)));                          %Total fresh recharge into profile (m^3/s)
        Circulation_saline=sum(sum(sum(Hv_in_saline)));                     %Total saltwater circulation into profile (m^3/s)

%         percent_error=100*(Sum_Hm_in+Sum_Hm_out)/((Sum_Hm_in-Sum_Hm_out)/2)     %Calculates mass balance error (%) and outputs to command window--add S and DCDT here!
        
                               

        Sv_in_fresh=Sv_in.*fraction_fresh;                                  %Sv_out_fresh is fresh volumetric change in storage for each cell (m^3/s)
        Sv_in_saline=Sv_in.*fraction_saline;                                %Sv_out_saline is saline volumetric change in storage for each cell (m^3/s)
        Sm_in_fresh=Sv_in_fresh.*dens_fresh;                                %Sm_out_fresh is fresh mass flux change in storage for each cell (kg/s)
        Sm_in_saline=Sv_in_saline.*dens_saline;                             %Sm_out_saline is fresh mass flux change in storage for each cell(kg/s)
        Storage_gain=abs(sum(sum(sum(Sm_in_fresh)))+sum(sum(sum(Sm_in_saline))));
        
        Sv_out_fresh=Sv_out.*fraction_fresh;                                %Sv_out_fresh is fresh volumetric flow (-) change in storage for each cell (m^3/s)
        Sv_out_saline=Sv_out.*fraction_saline;                              %Sv_out_saline is saline volumetric flow (-) change in storage for each cell (m^3/s)
        Sm_out_fresh=Sv_out_fresh.*dens_fresh;                              %Sm_out_fresh is fresh mass flux (-) change in storage for each cell (kg/s)
        Sm_out_saline=Sv_out_saline.*dens_saline;                           %Sm_out_saline is fresh mass flux (-) change in storage for each cell(kg/s)
        Storage_loss=abs(sum(sum(sum(Sm_out_fresh)))+sum(sum(sum(Sm_out_saline))));
        
        %Need to figure out how to handle DCDT--requires multiplying by the
        %length of the last transport step--I need to figure out where to
        %import this from
        
        DCDT_inc=99999;
        DCDT_dec=99999;

        centroid_y=centroid_y/interface_area
        centroid_z=-centroid_z/interface_area
        interface_areaT=interface_area*y_size*z_size;                       %Calculation of interface_area (m^2), the area of the model domain where concentration is between 10% and 90% saline
        interface_topT=interface_top*y_size
        interface_bottomT=interface_bottom*y_size
        velocities_y=FF./(x_size*z_size);                                   %y velocities in m/s
        velocities_z=FB./(x_size*y_size);                                   %z velocieties in m/s
        
        Peclet_y=velocities_y.*(y_size/200);                                %Calculate Peclet numbers 
        Peclet_z=velocities_z.*(z_size/2);
        
        M_0=sum(sum(sum(C)));
        M_y=0;
        m_count=0;
        for i=1:z_cells
            m_count=m_count+1;
            M_y=M_y+sum(sum(C(m_count,:).*y));
        end
        Cy=M_y/M_0;                                                         %Center of mass, y direction (m)
        
        M_z=0;
        m_count=0;
        for i=1:y_cells
            m_count=m_count+1;
            M_z=M_z+sum(sum(C(:,m_count).*z));
        end
        Cz=M_z/M_0;                                                         %Center of mass, z direction (m)
        
        % Volume mass balance error
        F_INS=sum(sum(Hv_in));           % [m^3/s]
        F_OUTS=sum(sum(Hv_out));         % [m^3/s]
        Fluid_MBerror=(F_INS+F_OUTS)/F_INS*100

        % Salt mass balance error
        S_INS=sum(sum(Hv_in.*C));
        S_OUTS=sum(sum(Hv_out.*C));

        Solute_MBerror=(S_INS+S_OUTS)/S_INS*100
        
        %SGD calculations
        saline_limit=max(abs(Hv_out_saline(1,:)))*.0005;                    %Filter out noise by removing q values < 0.05% of the maximum q
        fresh_limit=max(abs(Hv_out_fresh(1,:)))*.0005;
        
        q_saline=abs(Hv_out_saline(1,:));
        q_saline(q_saline<saline_limit)=0;
        q_fresh=abs(Hv_out_fresh(1,:));
        q_fresh(q_fresh<fresh_limit)=0;
        
        q_saline_ones=q_saline;                                             %Create matrix of ones indicating presence (1) or lack (NaN) of SGD
        q_saline_ones(q_saline_ones>0)=1;
        q_saline_ones(q_saline_ones<=0)=NaN;
        q_fresh_ones=q_fresh;
        q_fresh_ones(q_fresh_ones>0)=1;
        q_fresh_ones(q_fresh_ones<=0)=NaN;

      
        y_saline=y(isfinite(y.*q_saline_ones));
        q_saline=q_saline(isfinite(q_saline.*q_saline_ones));
       
        y_fresh=y(isfinite(y.*q_fresh_ones));
        q_fresh=q_fresh(isfinite(q_fresh.*q_fresh_ones));
        
        mean_y_saline=mean(y_saline)
        mean_y_fresh=mean(y_fresh)
        median_y_saline=median(y_saline)
        median_y_fresh=median(y_fresh)
        max_y_saline=min(y_saline)
        max_y_fresh=min(y_fresh)
        min_y_saline=max(y_saline)
        min_y_fresh=max(y_fresh)
        var_y_saline=var(y_saline)
        var_y_fresh=var(y_fresh)
        skew_y_saline=skewness(y_saline)                                    %When skew is positive, data is spread more to the right (landward)
        skew_y_fresh=skewness(y_fresh)                                      %When skew is negative, data is spread more to the left (seaward)
        N_saline=size(y_saline);
        N_fresh=size(y_fresh);
        s_y_saline=sum((y_saline-mean_y_saline).^3)/(N_saline(1,2)-1)/(var_y_saline^1.5)
        

        

        
        
        center_saline=sum(q_saline.*y_saline)/sum(q_saline)                        %Calculate center of mass for fresh, salty, and total discharge (m)
        center_fresh=sum(q_fresh.*y_fresh)/sum(q_fresh)
       
        
        wvar_saline=sum(q_saline.*((y_saline-center_saline).^2))/sum(q_saline)  %Weighted variance
        wvar_fresh=sum(q_fresh.*((y_fresh-center_fresh).^2))/sum(q_fresh)
        
        wskew_saline=sum(q_saline.*((y_saline-center_saline).^3))/sum(q_saline)/(wvar_saline^1.5)
        wskew_fresh=sum(q_fresh.*((y_fresh-center_fresh).^3))/sum(q_saline)/(wvar_fresh^1.5)
%         center_total=(sum(q_saline.*y)*dens_saline+sum(q_fresh.*y)*dens_fresh)/(sum(q_saline)*dens_saline+sum(q_fresh)*dens_fresh);
%         
%   
%         
%         V_saline_count=q_saline; V_saline_count(V_saline_count>=max_saline)=1; V_saline_count(V_saline_count<max_saline)=0;
%         V_fresh_count=q_fresh; V_fresh_count(V_fresh_count>=max_fresh)=1; V_fresh_count(V_fresh_count<max_fresh)=0;
%         V_total_count=V_saline_count+V_fresh_count; V_total_count(V_total_count>0)=1;
        DisL_saline=N_saline(1,2)*y_size
        DisL_fresh=N_fresh(1,2)*y_size
%         DisL_T=sum(V_total_count)*y_size;
        
%         V_saline=abs(Hv_out_saline(1,:).*((3600*24)/(y_size*x_size)));      %Find velocity of saline SGD and convert units to m/d
%         V_fresh=abs(Hv_out_fresh(1,:).*((3600*24)/(y_size*x_size)));        %Find velocity of fresh SGD and convert units to m/d
%         center_saline=sum(V_saline.*y)/sum(V_saline);                        %Calculate center of mass for fresh, salty, and total discharge (m)
%         center_fresh=sum(V_fresh.*y)/sum(V_fresh);
%         center_total=(sum(V_saline.*y)*dens_saline+sum(V_fresh.*y)*dens_fresh)/(sum(V_saline)*dens_saline+sum(V_fresh)*dens_fresh);
%         
%         max_saline=max(V_saline)*.0005;
%         max_fresh=max(V_fresh)*.0005;
%         
%         V_saline_count=V_saline; V_saline_count(V_saline_count>=max_saline)=1; V_saline_count(V_saline_count<max_saline)=0;
%         V_fresh_count=V_fresh; V_fresh_count(V_fresh_count>=max_fresh)=1; V_fresh_count(V_fresh_count<max_fresh)=0;
%         V_total_count=V_saline_count+V_fresh_count; V_total_count(V_total_count>0)=1;
%         DisL_saline=sum(V_saline_count)*y_size;
%         DisL_fresh=sum(V_fresh_count)*y_size;
%         DisL_T=sum(V_total_count)*y_size;
        
        Results(p-low+1,1)=set_num;
        Results(p-low+1,2)=p;
        Results(p-low+1,3)=Sum_Hm_in;
        Results(p-low+1,4)=Sum_Hm_out;
        Results(p-low+1,5)=Recharge_fresh;
        Results(p-low+1,6)=SGD_fresh;
        Results(p-low+1,7)=Circulation_saline;
        Results(p-low+1,8)=SGD_saline;
        Results(p-low+1,9)=Storage_gain;
        Results(p-low+1,10)=Storage_loss;
        Results(p-low+1,11)=DCDT_inc; %<----------------Not correct!!
        Results(p-low+1,12)=DCDT_dec; %<----------------Not correct!!
        Results(p-low+1,13)=interface_areaT;
        Results(p-low+1,14)=interface_topT;
        Results(p-low+1,15)=interface_bottomT;
        Results(p-low+1,16)=Cy;
        Results(p-low+1,17)=Cz;
        Results(p-low+1,18)=min(min(C));
        Results(p-low+1,19)=max(max(C));
        Results(p-low+1,20)=max(max(Peclet_y));
        Results(p-low+1,21)=max(max(Peclet_z));
        Results(p-low+1,22)=center_saline;
        Results(p-low+1,23)=center_fresh;
        Results(p-low+1,24)=min_y_saline;
        Results(p-low+1,25)=min_y_fresh;
        Results(p-low+1,26)=max_y_saline;
        Results(p-low+1,27)=max_y_fresh;
        Results(p-low+1,28)=wvar_saline;
        Results(p-low+1,29)=wvar_fresh;
        Results(p-low+1,30)=wskew_saline;
        Results(p-low+1,31)=wskew_fresh;
        Results(p-low+1,32)=centroid_y;
        Results(p-low+1,33)=centroid_z;
        Results(p-low+1,34)=DisL_saline;
        Results(p-low+1,35)=DisL_fresh;
        Results(p-low+1,36)=Fluid_MBerror;
        Results(p-low+1,37)=Solute_MBerror;
        
%%PLOTS

% scrsz = get(groot,'ScreenSize');
% % 
% plotsFig=figure('Name','PlotsFig','Position',[50 100 0.50*scrsz(3) 0.2*scrsz(4)]);


hFig = figure(2);
%         hFig=figure('position',[500, 500, 750, 200]);                           %Adjust size of plot
         hold on
%         hFig=figure('position',[500, 500, 750, 200]);
           subplot(4,1,1);
        pcolor(y_km,z,C);                                                   %Plot concentration data
        %pcolor(y_km,z,h_Hs); 
        shading flat
%          axis off
        hold on
        
        conc_title='profile';
        conc_title=strrep(conc_title, 'profile', profile_folder);  
        title('a.) Heterogeneous K field')
%         xlabel('Landward distance, km (coast at 0 km)')
        ylabel('Depth [m]')
%         text(180,-50, conc_title,'Color','w');
        coastx=[150 150 150];
        coasty=[-402 -200 0]
        plot(coastx, coasty, '--','Color','w')
        plot((centroid_y/1000),centroid_z,'.','MarkerSize',20,'Color','k')
        text(160,-100, 'Salinity','Color','w');
%         ia=int2str(interface_area);
%         interface_str='Interface area = ia m^2';
%         interface_str=strrep(interface_str,'ia',ia);
%         text(5,-350, interface_str,'Color','w');                            %Add text box with interface area (10-90% saline)
%          colorbar('southoutside')
        hold off
        
        cd(main_directory);
        cd('Figures');
        fig_name1='Salinity_profile_x.tif';
        fig_name1=strrep(fig_name1, 'profile', profile_folder);
        fig_name1=strrep(fig_name1, 'x', x_str);
%         
%         size=[200 200];
%         res=300;
%         set(gcf,'paperunits','inches','paperposition',[0 0 size/res]);
        saveas(hFig,fig_name1);
%         hgexport(plotsFig,fig_name1)
%         r = 150; % pixels per inch
%         set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 1080 480]/r);
%         print(gcf,'-dpng',sprintf('-r%d',r), 'Salinity.png');
%         rect=[250,250,1080,480];
%         set(plotsFig, 'OuterPosition',rect);
%         print('Salinity','-tiff')
% 
%     set(hFig, 'PaperUnits', 'inches', 'PaperPosition', [0 0 0.50*scrsz(3) 0.2*scrsz(4)]);
% %     print(hFig, '-dpng', ['-r' num2str(dpi)], 'Salinity');
% set(plotsFig,'PaperPositionMode','auto')
% print(plotsFig,'-dtiff','Salinity')

        %%Plot flow velocities

%         hFig = figure(3);

        subplot(4,1,2);
       bar(y_km,(-Hv_out_fresh(1,:).*3600.*24./x_size./y_size),'Facecolor','b','Edgecolor','b')        %Creates a stacked bar plot                                              %Plot fresh and salty SGD
        y_max=max(-Hv_out_fresh(1,:).*3600.*24./x_size./y_size);
       hold on
         plot([150 150],[0 10], ':','Color','k')

        
        axis([0 200 0 y_max*1.2])
        
%         set(gca,'fontsize',14)
%         set(hFig,'xtick',[])
% set(gca,'xticklabel',[])
       
%         SGD_title='set';
%         SGD_title=strrep(SGD_title, 'profile', profile_folder);
%         title(run)
        %xlabel('Landward distance, km (coast at 0 km)')
        %ylabel('q_f out, m/d')
        text(160,y_max*.75, 'Fresh SGD');
        
        %legend('Saline','Fresh','Location','northwest')

%         hFig = figure(3);
        subplot(4,1,3);
        bar(y_km,(-Hv_out_saline(1,:).*3600.*24./x_size./y_size),'Facecolor','r','Edgecolor','r')        %Creates a stacked bar plot                                              %Plot fresh and salty SG
        hold on
         plot([150 150],[0 10], ':','Color','k')
         axis([0 200 0 y_max*1.2])
%         SGD_title='Saline SGD, profile';
%         SGD_title=strrep(SGD_title, 'profile', profile_folder);
%         title(SGD_title)
        %xlabel('Landward distance, km (coast at 0 km)')
        ylabel('q out [m/d]')
        text(160,y_max*.75, 'Saline SGD');
        %legend('Saline','Fresh','Location','northwest')
        
%         hFig = figure(3);
        subplot(4,1,4);
        bar(y_km(1,1:y_cells-1),(-Hv_in_saline(1,:).*3600.*24./x_size./y_size),'Facecolor','r','Edgecolor','r')
        hold on
         plot([150 150],[-10 10], ':','Color','k')
         axis([0 200 -y_max*1.2 0])
%         SGD_title='Saltwater Circulation, profile';
%         SGD_title=strrep(SGD_title, 'profile', profile_folder);
%         title(SGD_title)
        xlabel('Landward distance [km]')
        %ylabel('q_s in, m/d')
         text(160,-y_max*.5, 'Saline SGR');
        %legend('Saline','Fresh','Location','northwest')
        
        cd(main_directory);
        cd('Figures');
        fig_name1='SGD_profile_x.tif';
        fig_name1=strrep(fig_name1, 'profile', profile_folder);
        fig_name1=strrep(fig_name1, 'x', x_str);
        saveas(hFig,fig_name1);
                                                                            %Save figures to main_directory>Figures

         close all                                                         %Close figures for next loop (use for 3D only)
    end



    
    sFig = figure(1);
    plot(Mass.data(:,1),Mass.data(:,7))                                     %SS check:  plot mass v. time
    SS_title='Steady State Check, profile';
    SS_title=strrep(SS_title, 'profile', profile_folder);                   %Add profile name to plot title
    title(SS_title)
    xlabel('Time, s')
    ylabel('Total mass, kg')
    x_spot=1e13;
    y_spot=(max(Mass.data(:,7))/2); 
%     merr=num2str(percent_error,4);
%     mstring='Mass balance error = merr %';
%     mstring=strrep(mstring,'merr',merr);
%     text(x_spot,y_spot,mstring);                                          %Add text box with mass balance percent error--add when I figure out DCDT
    
    fig_name2='SSprofile.tif';
    fig_name2=strrep(fig_name2, 'profile',profile_folder);
    saveas(sFig,fig_name2); 
    
%     close all
    R(p,:)=[set_num p Recharge_fresh];
end

%------------------------------------------------------

% % Calculate the power balance. 
% 
% % LHS Energy flux (power) out across the boundaries. Positive is out, negative is in.
% % Double Integral rho*g*h*(q.n)dS
% 
% %slope=(dens_saline-dens_fresh)/(conc_saline-conc_fresh);                %Delta density/delta concentration
% %density=C.*slope+dens_fresh;                                            %Calculate density  of the fluid at each cell (kg/m^3)  
% density=fraction_saline*(dens_saline-dens_fresh)+dens_fresh;
% 
% hfzrho_vector=zeros(1,y_cells-1);
% %if h_sea==0;
%     q_in_fresh=sum(Hv_in(:,y_cells))/(x_size*z_size);
%     q_offshore_vector=H(1,1:y_cells-1)/(x_size*y_size);
%     for i=2:y_cells
%      hfzrho_vector(1,i-1)=h_sea+h_sea*(density(1,i)-dens_fresh)/dens_fresh;
%     end
%     LHS=dens_fresh*9.81*((q_in_fresh*h_land*(x_size*z_size))+sum(hfzrho_vector.*q_offshore_vector)*(x_size*y_size));      % Boundary fluxes. Note this is specific for the configuration of circ3 (only one flux in the last cell) and does not require the density at the outflow cells (normally it would, but not if everything is at zero)
% %end
% 
% % RHS Power dissipation inside the model. Signs shouldn't matter here.
% % Triple Integral over the domain rho*g/K*q^2
% 
% % Need all of the cell-by-cell flows. Get it from the bud file, 
% 
% %h_Hs=Flow.term{1,3};        % matrix of horizontal fluid flux through non-boundary cells
% %v_Hs=Flow.term{1,4};         % matrix of vertical fluid flux through non-boundary cells
% %b_Hs=Flow.term{1,2};        % matrix of vertical fluid flux through the boundary cells
% 
% % Convert to qs
% 
% horiz_qs=FF/(x_size*z_size);
% vert_qs=FB/(x_size*y_size);
% power_mat=density*9.81/K*(horiz_qs.^2+(vert_qs).^2);
% 
% Qfresh_in=sum(Hv_in(:,y_cells))
% % fsgd
% % ssgd
% 
% LHS
% RHS=sum(sum(power_mat*x_size*y_size*z_size))
% 
% Percent_discrepancy=(LHS-RHS)/LHS*100
% 
% Errors=[set_num p Fluid_MBerror Solute_MBerror Percent_discrepancy SGD_saline/SGD_fresh];




