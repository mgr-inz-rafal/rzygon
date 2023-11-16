@chcp 1250
mkdir build
mads.exe -o:build\main.xex -p -t:build\main.lab -l:build\main.lst main.asm
if %errorlevel% NEQ 0 PAUSE
