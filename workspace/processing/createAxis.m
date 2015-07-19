function [y_km, z] = createAxis(ycells, zcells)
    % Helper function, defines the y and z axis in the correct units, from
    % total cells in the matrix to km and m, respectively
    % July 15, 2015
    
    DISTANCE_Y = 200000; % default values for the distance of the plot
    DISTANCE_Z = double(402);
    DEFAULT_Z = 134; % usual number
    DEFAULT_Y = 400; 
    y_size = DISTANCE_Y/DEFAULT_Y;
    z_size = DISTANCE_Z/DEFAULT_Z; 
    
    offset_z = zcells/DEFAULT_Z;
    offset_y = ycells/DEFAULT_Y;
    %Defines y axis in kilometers
    y(1,ycells)=zeros;   
    for i=1:y_size 
        y(1,i)=(-(y_size/2)+(y_size)*i);                              
    end
    y_km=y./1000;                                                             

    %Define z axis in meters
    z(zcells,1)=zeros;    
    for i=1:z_size
        z(i,1)=((z_size/2)-(z_size)*i);                               
    end
end
