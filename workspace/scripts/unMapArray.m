function modArray =  unMapArray(arr)
  % June 2, 2015
  % imagesc(unMapArray(Profile)) -- example usage
  % reverse maps the values from the array, the mirror function to mapArray
  function  x = mapRawValue(rawValue) 
    if rawValue ==1e-13;   %clay
        x= 0;
    elseif rawValue == 1e-8
        x = 1;
    elseif rawValue == 1e-5
        x = 2;
    elseif rawValue == 1e-3
        x = 3;
    else 
        x = -999;
    end
  end 
 
  %map each element in the array, 'arr', with the function mapRawValue
  temp =  arrayfun(@(x) mapRawValue(x), arr, 'UniformOutput', false);
  modArray = cell2mat(temp); %convert to correct output format
end 