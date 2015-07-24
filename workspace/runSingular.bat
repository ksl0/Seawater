ECHO Start of running SEAWAT FILES 
ECHO Purpose: determine optimum discretization


REM Set which discretizations to run
set DISC= (disc134_800)
set PROFILES= (profile5.21.mat profile5.30.mat)
(for %%n in %DISC% do (
  (for %%h in %PROFILES% do (
    CD C:\Users\Admin\Desktop\KatieLi\Seawater\workspace\%%n\%%h
    start C:\PROGRA~2\SWT_V4~1\exe\SWT_V4~1.EXE Test.nam
  )
  )
)
)
