ECHO Start of running SEAWAT model for dispersivity

REM Set which discretizations to run
set DISC= (disp5 disp10 disp50 disp100 disp200 disp250 disp400 disp500)
(for %%n in %DISC% do (
    CD C:\Users\Admin\Desktop\KatieLi\Seawater\workspace\dispersivity\%%n
    start C:\PROGRA~2\SWT_V4~1\exe\SWT_V4~1.EXE Test.nam
  )
)
)
