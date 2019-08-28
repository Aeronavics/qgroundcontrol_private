@echo ON

SET "MSVC_PATH=C:\Qt\5.11.0\msvc2015\bin"
SET "QT_PATH=C:\Qt\Tools\QtCreator\bin"

SET PATH=%MSVC_PATH%;%QT_PATH%;%PATH%
ECHO %PATH%

call vcvarsall.bat

del /F /Q BUILD
mkdir build
cd build
call "%MSVC_PATH%/qmake.exe" -r INCLUDEPATH+="C:\Users\pierre\Documents\curl-7.65.3_1-win64-mingw\curl-7.65.3-win64-mingw\include" LIBS+="C:\Users\pierre\Documents\curl-7.65.3_1-win64-mingw\curl-7.65.3-win64-mingw\lib\libcurl.dll.a" CONFIG-=debug_and_release CONFIG+=WarningsAsErrorsOn CONFIG+=installer -spec win32-msvc ../qgroundcontrol.pro
jom
cd ..
