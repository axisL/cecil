set BASEDIR=%~dp0
set BUILDDIR=%BASEDIR%builds
set LIBDIR=%BUILDDIR%\lib
set LIBDIR35=%LIBDIR%\net35
set LIBDIR40=%LIBDIR%\net40
REM set MSBUILD="C:\Program Files (x86)\MSBuild\14.0\Bin\MSBuild.exe"
set MSBUILD="D:\software\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\amd64\MSBuild.exe"


::Setup Directories
mkdir %BUILDDIR%
mkdir %LIBDIR%
mkdir %LIBDIR35%
mkdir %LIBDIR40%

::Create Version TXT
cd %BASEDIR%
type NUL > %BUILDDIR%\version.txt
@echo | set /p="Repository: " >> %BUILDDIR%\version.txt
git remote get-url origin >> %BUILDDIR%\version.txt

@echo | set /p="Branch: " >> %BUILDDIR%\version.txt
git branch >> %BUILDDIR%\version.txt

@echo | set /p="Commit: " >> %BUILDDIR%\version.txt
git log -n 1 --pretty=format:%%H >> %BUILDDIR%\version.txt

::Build Cecil for .NET 3.5
%MSBUILD% "%BASEDIR%\Mono.Cecil.sln" /t:Build /p:Configuration=net_3_5_Release /p:Platform="Any CPU" /p:OutputPath=%LIBDIR35%
call:CleanupBuild %LIBDIR35%
::Build Cecil for .NET 4.0
%MSBUILD% "%BASEDIR%\Mono.Cecil.sln" /t:Build /p:Configuration=net_4_0_Release /p:Platform="Any CPU" /p:OutputPath=%LIBDIR40%
call:CleanupBuild %LIBDIR40%

7z a -tzip -r %BASEDIR%/builds.zip %BUILDDIR%/*

::--------------------------------------------------
::----------------- Functions ----------------------
::--------------------------------------------------
:CleanupBuild
cd %~1
del *.Tests.*
del nunit.*
goto:eof
