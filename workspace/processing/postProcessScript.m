clear all;
clc;
main_dir = '/Users/katie/Desktop/ModelingSeawater/workspace/';
input_dir= '/Users/katie/Desktop/ModelingSeawater/workspace/disc268_1600/profile5.21.mat';
x_cells = 1;
y_cells = 1600;
z_cells = 268;
disc = 268*1600;
profile = 21;
results = postProcessor(main_dir, input_dir, x_cells, y_cells, z_cells, disc, profile);
disp('done :)');

