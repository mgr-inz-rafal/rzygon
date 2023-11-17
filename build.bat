@chcp 1250
mkdir build
mads.exe -o:build\main.xex -p -t:build\main.lab -l:build\main.lst main.asm
copy build\main.lab build\rzygon.lab
copy build\main.lst build\rzygon.lst
if %errorlevel% NEQ 0 PAUSE
