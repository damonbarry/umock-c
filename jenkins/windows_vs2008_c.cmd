@REM Copyright (c) Microsoft. All rights reserved.
@REM Licensed under the MIT license. See LICENSE file in the project root for full license information.

@setlocal EnableExtensions EnableDelayedExpansion

set build-root=%~dp0..
rem // resolve to fully qualified path
for %%i in ("%build-root%") do set build-root=%%~fi

@echo off

set CMAKE_DIR=umockc_win32

echo CMAKE Output Path: %build-root%\build\%CMAKE_DIR%

if EXIST %build-root%\build\%CMAKE_DIR% (
    rmdir /s/q %build-root%\build\%CMAKE_DIR%
    rem no error checking
)

echo %build-root%\build\%CMAKE_DIR%
mkdir %build-root%\build\%CMAKE_DIR%
rem no error checking
pushd %build-root%\build\%CMAKE_DIR%

echo ***Running CMAKE for Win32***   
cmake -DENABLE_UNIT_TESTS=ON -DENABLE_INT_TESTS=ON %build-root%
if not !ERRORLEVEL!==0 exit /b !ERRORLEVEL!

cmake --build . -- /m "/p:Configuration=Debug;Platform=Win32"
if not !ERRORLEVEL!==0 exit /b !ERRORLEVEL!
    
ctest -C "debug" -V
if not !ERRORLEVEL!==0 exit /b !ERRORLEVEL!

popd
