@echo off



rem ----- 環境変数 -----
rem ※変数はクォートで囲まないでください。
rem   必要に応じて実行時にクォートで囲むように実装しています。
set ORGDRIVE=N:
set ORGDIR=N:\tmp
set TGTDRIVE=C:
set TGTDIRBASE=C:\tmp TMP テンプ
set TGTBKDIR=tmp

rem 保存世代数
set GENNUM=10

rem cycle番号判定
for /f %%c in (%~dp0\bkDirMirrorCycleNo.txt) do set TMPCYCLENUM=%%c
if %TMPCYCLENUM% geq %GENNUM%  (set TMPCYCLENUM=0)

rem バックアップ取得先フォルダ
set TGTDIR=%TGTDIRBASE%\%TMPCYCLENUM%
rem ----- 環境変数 -----



rem #####ディレクトリサイクルミラーリング#####
rem [robocopy /mir]で取得する。

rem <リストア方法>
rem   1. バックアップディレクトリを取得元に戻す。

%TGTDRIVE%
cd "%TGTDIRBASE%"
if not %ERRORLEVEL%==0 (exit /b 1)
for /f "delims=" %%c in ('cd') do set TMPCURDIR=%%c
if not "%TGTDIRBASE%"=="%TMPCURDIR%" (exit /b 1)

if not exist "%TMPCYCLENUM%" (
    mkdir "%TMPCYCLENUM%"
    if not %ERRORLEVEL%==0 (exit /b 1)
)

%TGTDRIVE%
cd "%TGTDIR%"
if not %ERRORLEVEL%==0 (exit /b 1)
for /f "delims=" %%c in ('cd') do set TMPCURDIR=%%c
if not "%TGTDIR%"=="%TMPCURDIR%" (exit /b 1)

robocopy /mir /r:3 /log:%~dp0\bkDirMirror.log "%ORGDIR%" "%TGTBKDIR%" > nul 2>&1
rem robocopyは戻り値が複雑・・・戻り値チェックは諦めるか？

set /a TMPCYCLENUM=%TMPCYCLENUM%+1
rem set /p x=%TMPCYCLENUM%<nul > %~dp0\bkDirMirrorCycleNo.txt
echo %TMPCYCLENUM% > %~dp0\bkDirMirrorCycleNo.txt
