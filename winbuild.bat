@echo ON

SET "MSVC_PATH=C:\Qt\5.11.0\msvc2015\bin"
SET "QT_PATH=C:\Qt\Tools\QtCreator\bin"

SET PATH=%MSVC_PATH%;%QT_PATH%;%PATH%
ECHO %PATH%

call vcvarsall.bat

del /F /Q BUILD
mkdir build
cd build
call "%MSVC_PATH%/qmake.exe" -r INCLUDEPATH+=" C:\Users\pierre\Documents\build-libcurl-windows\third-party\libcurl\include " CONFIG-=debug_and_release CONFIG+=WarningsAsErrorsOn CONFIG+=installer -spec win32-msvc ../qgroundcontrol.pro
jom
cd ..
