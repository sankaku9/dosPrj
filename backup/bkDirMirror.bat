@echo off



rem ----- ���ϐ� -----
rem ���ϐ��̓N�H�[�g�ň͂܂Ȃ��ł��������B
rem   �K�v�ɉ����Ď��s���ɃN�H�[�g�ň͂ނ悤�Ɏ������Ă��܂��B
set ORGDRIVE=N:
set ORGDIR=N:\tmp
set TGTDRIVE=C:
set TGTDIRBASE=C:\tmp TMP �e���v
set TGTBKDIR=tmp

rem �ۑ����㐔
set GENNUM=10

rem cycle�ԍ�����
for /f %%c in (%~dp0\bkDirMirrorCycleNo.txt) do set TMPCYCLENUM=%%c
if %TMPCYCLENUM% geq %GENNUM%  (set TMPCYCLENUM=0)

rem �o�b�N�A�b�v�擾��t�H���_
set TGTDIR=%TGTDIRBASE%\%TMPCYCLENUM%
rem ----- ���ϐ� -----



rem #####�f�B���N�g���T�C�N���~���[�����O#####
rem [robocopy /mir]�Ŏ擾����B

rem <���X�g�A���@>
rem   1. �o�b�N�A�b�v�f�B���N�g�����擾���ɖ߂��B

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
rem robocopy�͖߂�l�����G�E�E�E�߂�l�`�F�b�N�͒��߂邩�H

set /a TMPCYCLENUM=%TMPCYCLENUM%+1
rem set /p x=%TMPCYCLENUM%<nul > %~dp0\bkDirMirrorCycleNo.txt
echo %TMPCYCLENUM% > %~dp0\bkDirMirrorCycleNo.txt
