function [y_km, z] = createAxis(y_cells, z_cells)
    % Helper function, defines the y and z axis in the correct units, from
    % total cells in the matrix to km and m, respectively
    % July 15, 2015
    
    DISTANCE_Y = 200000; % default values for the distance of the plot
    DISTANCE_Z = 402;
    DEFAULT_Z = 134; % usual number
    DEFAULT_Y = 400; 
    y_size = DISTANCE_Y/DEFAULT_Y;
    z_size = DISTANCE_Z/DEFAULT_Z;
    
    offset_z = z_cells/DEFAULT_Z;
    offset_y = y_cells/DEFAULT_Y;
    
    %Defines y axis in kilometers
    y(1,y_cells)=zeros;   
    for i=1:y_cells 
        y(1,i)=(-(y_size/2)+(y_size)*i);                              
    end
    y_km=y./offset_y;  
   

    %Define z axis in meters
    z(z_cells,1)=zeros;    
    for i=1:z_cells
        z(i,1)=((z_size/2)-(z_size)*i);                                
    end
    z = z./offset_z;
    
    % check statements to make sure y_km, z are in the correct scale
    assert((DISTANCE_Y - max(y_km))/DISTANCE_Y < 0.01); 
    assert((DISTANCE_Z + min(z))/DISTANCE_Z < 0.01);
end
