function result =  discretizeArray(arr, XSTRETCH, ZSTRETCH)
  % Default values for no stretch
  stretchFactor= ones(ZSTRETCH, XSTRETCH);
  result = kron(arr, stretchFactor); %maps values to a larger array
end

