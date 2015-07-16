ECHO Start of running SEAWAT FILES 
ECHO Purpose: determine optimum discretization


REM Set which discretizations to run
set DISC= (disc134_800 disc134_1600 disc268_800 disc268_1600 disc536_800)
set PROFILES= (profile5.30.mat profile5.21.mat)
(for %%n in %DISC% do (
  (for %%h in %PROFILES% do (
    CD C:\Users\Admin\Desktop\KatieLi\Seawater\workspace\%%n\%%h
    C:\PROGRA~2\SWT_V4~1\exe\SWT_V4~1.EXE Test.nam
  )
  )
)
)
