@echo off
call vcvars64.bat

cl -nologo -MT -TC -O2 -c "./main.c"
lib -nologo main.obj /out:"./kit.lib"
del main.obj

cl -MT -TC -c -Z7 -nologo "./main.c"
lib -nologo main.obj -out:"./kit_debug.lib"
del main.obj