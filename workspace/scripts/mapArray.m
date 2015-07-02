function modArray =  mapArray(arr)
  % June 30th, 2015
  % A specific function that maps the values 0,1,2,3 to
  % their corresponding  dispersivities, and returns corresponding arrays
  %   * assumption: the values range only from 0 to 3
  % Katie Li, katiesli16@gmail.com

  function  x = mapRawValue(rawValue) 
    NKEYS= 4; %the range of values within the field
    OFFSET = 1; %arrays in matlab index from 1, and we start with values at 0
    %create the 'dictionary' for the dispersivities
    A  = zeros(1, NKEYS);
    A(1) = 1e-13;   %clay
    A(2) = 1e-8;    %silt 
    A(3) = 1e-5;    %fine_sand 
    A(4) = 1e-3;    %mc_sand 
    % will tell user if size is not right
    if (rawValue + OFFSET) > NKEYS || (rawValue + OFFSET) < 1
        fprintf('Please check your raw values, %s is too big \n', rawValue);
        return; %exit function 
    end 
    x = A(rawValue + OFFSET); % retrieve correct value from the array
  end 
 
  %map each element in the array, 'arr', with the function mapRawValue
  temp =  arrayfun(@mapRawValue, arr, 'UniformOutput', false);
  modArray = cell2mat(temp); %convert to correct output format
end 
