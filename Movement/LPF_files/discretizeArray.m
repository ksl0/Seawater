function result =  discretizeArray(arr, XSTRETCH, ZSTRETCH)
  % A short helper function that allows one to expand the matrix
  % Parameters: 
  %   arr - array to be changed 
  %   XSTRETCH - expansion in the 'x' directino 
  %   ZSTRETCH - expansion in the 'z' directino 
  %
  % For example, an original array can be a 134 by 200 matrix. 
  % To expand the original array to size 134 x 400, use
  %     discretizeArray(arr, 1, 2)
  % which will return a 134 x 400 array.  

  stretchFactor= ones(ZSTRETCH, XSTRETCH); % Default values for no stretch
  result = kron(arr, stretchFactor); %maps values to a larger array
end

