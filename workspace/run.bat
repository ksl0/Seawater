ECHO Start of running SEAWAT FILES 
ECHO Purpose: determine optimum discretization


REM Set which discretizations to run
set disc = disc134_800 disc134_1600 disc268_800 disc268_1600 disc536_1600
set profiles = profile5.30.mat profile5.21.mat
(for %%n in (%disc%) do (
  echo %%n
  (for %%hk in (%profiles%) do (
    echo %%hk
    CD  C:\User\Admin\Desktop\KatieLi\Seawater\workspace\%%n\basefiles\%%hk
    REM C:\Users\Student\DOCUME~1\SWT_V4~1\SWT_V4~1\exe\swt_v4.exe Test.nam
  )
  )
)
)
