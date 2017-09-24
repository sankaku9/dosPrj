@echo off



rem ----- 環境変数 -----
rem ※変数はクォートで囲まないでください。
rem   必要に応じて実行時にクォートで囲むように実装しています。
set ORGDRIVE=N:
set ORGDIR=N:\tmp\gitbareTest
set TGTDRIVE=C:
set TGTDIRBASE=C:\tmp TMP テンプ

rem バックアップ取得先フォルダ名を[yyyyMMddHHmmss_bkup]とする。
set tmpDirName=%date:/=%%time: =0%
set tmpDirName=%tmpDirName::=%
set tmpDirName=%tmpDirName:~0,14%_bkup
set TGTDIR=%TGTDIRBASE%\%tmpDirName%

rem 保存世代数
set GENNUM=10
rem バックアップディレクトリ正規表現(dos)
rem 誤削除防止の為、複雑な条件を推奨。
set BKDIRREG=^[2-9][0-9][0-9][0-9][01][0-9][0-3][0-9][0-2][0-9][0-5][0-9][0-5][0-9]_bkup$
rem 誤連続起動時の削除防止。DATEGUARD日数以上前のバックアップが存在しない場合は削除処理に入らない。
rem 例：日次実行想定であれば[GENNUM]-1を設定する。
set DATEGUARD=9
rem ----- 環境変数 -----



rem #####gitリポジトリバックアップ#####
rem [git clone --mirror]で取得する。

rem <リストア方法>
rem   1. originalリポジトリを完全削除後に同一パスに新規originリポジトリ作成。
rem   2. 等処理で取得したバックアップリポジトリフォルダにcd。
rem   3. コマンド[git push origin]を実行。

%TGTDRIVE%
cd "%TGTDIRBASE%"
if not %ERRORLEVEL%==0 (exit /b 1)
for /f "delims=" %%c in ('cd') do set TMPCURDIR=%%c
if not "%TGTDIRBASE%"=="%TMPCURDIR%" (exit /b 1)

mkdir "%tmpDirName%"
if not %ERRORLEVEL%==0 (exit /b 1)

%TGTDRIVE%
cd "%TGTDIR%"
if not %ERRORLEVEL%==0 (exit /b 1)
for /f "delims=" %%c in ('cd') do set TMPCURDIR=%%c
if not "%TGTDIR%"=="%TMPCURDIR%" (exit /b 1)

git clone --mirror "%ORGDIR%" > nul 2>&1
if not %ERRORLEVEL%==0 (exit /b 1)



rem #####世代管理#####
rem   1. [TGTDIRBASE]に指定したフォルダ配下の
rem   2. 名前が正規表現[BKUPDIRREGEX]に該当するフォルダを
rem   3. 最新[GENNUM]数残して削除する。
rem   4. 但し、[DATEGUARD]日数以上前のバックアップが存在しない場合は削除処理に入らない。

%TGTDRIVE%
cd "%TGTDIRBASE%"
if not %ERRORLEVEL%==0 (exit /b 1)
for /f "delims=" %%c in ('cd') do set TMPCURDIR=%%c
if not "%TGTDIRBASE%"=="%TMPCURDIR%" (exit /b 1)

forfiles /d %DATEGUARD% > nul 2>&1
if not %ERRORLEVEL%==0 (exit /b 0)

for /f "delims= skip=%GENNUM%" %%d in ('dir /ad /b /o-d^|findstr /r %BKDIRREG%') do rd /s /q "%%d"
if not %ERRORLEVEL%==0 (exit /b 1)



