FILENAME = 'Test.bhd';
OUTNAME = 'Test2.bhd';
z_cells = 134;
x_cells = 400;
newLay = 134;
newWidth = x_cells;

input_dir = '/Users/katie/Desktop/ModelingSeawater/workspace/scripts/';
discretizeInitialHeadValues(FILENAME, OUTNAME, z_cells, x_cells, newLay, newWidth);