function [numCells, percent_cells] = findSizeMixingZone(concentrationMatrix, bottomLayer, topLayer)
%Returns the raw number,  percentage of cells that are within
% the 10% and 90% salinity, or 3.5 and 31.5
%   Input values:
%    - concentrationMat;
% concLayer = concentrationMatrix(1,:);
% example usage: [n p] = findMixingZone(concLayer);

    concLayer = concentrationMatrix(bottomLayer:topLayer,:); 
    totalCells = numel(concLayer); %count total number of elements in layer
    
    % filter the values in concLayer by where the values of concLayer is
    % within 10% to 90% salinity, representing the transition zone
    midrangeCells = concLayer(concLayer > 3.5 & concLayer < 31.5);
    numCells = numel(midrangeCells);
    percent_cells = numCells/totalCells; 

   %checking the size on command line -- debugging scripts
   %[r, c] = size(concentrationMatrix);
  % fprintf('Concentration matrix has %d rows and %d columns \n', r, c);
end 
