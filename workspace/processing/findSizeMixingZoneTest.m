function findSizeMixingZoneTest()
    %% create matricies
    data1= [[0,0,35]; [0,35,0]; [35,0,0]];
    data2 = [[5,6];[31.3, 36];[0,3.6]];
      
    n  = findSizeMixingZone(data1, 1, 3);
    n1  = findSizeMixingZone(data2, 1, 1);
    n2  = findSizeMixingZone(data2, 2, 2);
    n3  = findSizeMixingZone(data2, 1, 3);
    
    assert((n==0), 'There should be no interface area');
    assert((n1(1)==double(2)), '0 cells should be in the transition zone');
    assert((n2(1)==double(1)), '1 cells should be in the transition zone');
    assert((n3(1)==double(4)), '1 cells should be in the transition zone');
end
