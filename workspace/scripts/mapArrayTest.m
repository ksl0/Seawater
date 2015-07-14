% test script for the matrix modifier
% 06 June 2013

% default values
clay = 0; clayV = 1e-13;
silt = 1; siltV = 1e-8;
fine_sand = 2; fine_sandV = 1e-5;
mc_sand =  3; mc_sandV = 1e-3;

% test arrays
sed = [clay, silt, fine_sand, mc_sand];
rArray = randi(4,100,1) -1; %random array from 0-3

% test that they end up in the correct place
sed2 = mapArray(sed);
rArrayT = mapArray(rArray);

% make sure that values get mapped to correct place
assert(sed2(1) == clayV)
assert(sed2(2) == siltV)
assert(sed2(3) == fine_sandV)
assert(sed2(4) == mc_sandV)


%% tests the round-trip functionality of mapArray and UnMapArray

% create a matrix to test
r1 = floor(rand(100, 100)*4); % values from 0 to 3
r2 = unMapArray(mapArray(r1));
assert(isequal(r1,r2));