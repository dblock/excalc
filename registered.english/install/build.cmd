@echo off

setlocal

set DOCS=..\..\docs
set INSTALLBIN=..\..\..\InstallBin
set DISKBIN=%INSTALLBIN%\disk

@echo Cleaning up ...
if exist data\ rd /s /q data
mkdir data

@echo Copying excalc.exe ...
copy ..\excalc.exe data\excalc.exe /y > nul

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