import flopy
m = flopy.modflow.Modflow()
lpf = flopy.modflow.ModflowLpf.load('Test.lpf', m)
