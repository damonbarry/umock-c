@REM Copyright (c) Microsoft. All rights reserved.
@REM Licensed under the MIT license. See LICENSE file in the project root for full license information.

setlocal

set build-root=%~dp0..
rem // resolve to fully qualified path
for %%i in ("%build-root%") do set build-root=%%~fi

rmdir /s /q %build-root%\build
mkdir %build-root%\build
if errorlevel 1 goto :eof

set build-platform=Win32

:args-loop
if "%1" equ "" goto args-done
if "%1" equ "--platform" goto arg-build-platform
call :usage && exit /b 1

:arg-build-platform
shift
if "%1" equ "" call :usage && exit /b 1
set build-platform=%1
if %build-platform% == x64 (
	set CMAKE_DIR=shared-util_x64
) else if %build-platform% == arm (
	set CMAKE_DIR=shared-util_arm
)
goto args-continue

:args-continue
shift
goto args-loop

:args-done

cd %build-root%\build

if %build-platform% == Win32 (
	echo ***Running CMAKE for Win32***
	cmake -DENABLE_UNIT_TESTS=ON -DENABLE_INT_TESTS=ON -DUSE_CPPUNITTEST=ON %build-root%
	if errorlevel 1 goto :eof
) else if %build-platform% == ARM (
	echo ***Running CMAKE for ARM***
	cmake -G "Visual Studio 14 ARM" -DENABLE_UNIT_TESTS=ON -DENABLE_INT_TESTS=ON -DUSE_CPPUNITTEST=ON %build-root%
	if errorlevel 1 goto :eof
) else (
	echo ***Running CMAKE for Win64***
	cmake -G "Visual Studio 14 Win64" -DENABLE_UNIT_TESTS=ON -DENABLE_INT_TESTS=ON -DUSE_CPPUNITTEST=ON %build-root%
	if errorlevel 1 goto :eof
)

cmake --build . -- /m /p:Configuration=Release
if errorlevel 1 goto :eof

cmake --build . -- /m /p:Configuration=Debug
if errorlevel 1 goto :eof

ctest -C "Debug" -V
if errorlevel 1 goto :eof

cd %build-root%