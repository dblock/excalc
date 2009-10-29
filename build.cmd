@echo off

echo Building Registered version ...
pushd registered.english\install
call build.cmd
popd

echo Building Shareware version ...
pushd shareware.english\install
call build.cmd
popd

