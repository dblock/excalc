@echo off

setlocal

set DOCS=..\..\docs
set INSTALLBIN=..\..\..\InstallBin
set REGISTER=..\..\..\Register
set DISKBIN=%INSTALLBIN%\disk

@echo Cleaning up ...
if exist data\ rd /s /q data
mkdir data

@echo Copying excalc.exe ...
copy ..\excalc.exe data\excalc.exe /y > nul

@echo Building Register
%INSTALLBIN%\polycomp %REGISTER%\regmsg.txt
attrib -r -s -h %REGISTER%\register.exe
%REGISTER%\register -bindcfg %REGISTER%\register.cfg
copy %REGISTER%\register.exe data
copy %REGISTER%\register.hlp data
copy %REGISTER%\regmsg.bmd data

@echo Copying docs ...
xcopy %DOCS% data\docs /s/i /y > nul

if exist data.z del data.z
%INSTALLBIN%\icomp -i data\*.* data.z
move data.z disk

%INSTALLBIN%\compile setup\setup.rul
copy setup\setup.ins disk

%INSTALLBIN%\packlist setup\setup.lst
move setup.pkg disk
if exist data\ rd /s /q data

copy %DISKBIN%\*.* disk > nul

endlocal