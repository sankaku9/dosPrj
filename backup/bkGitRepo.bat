@echo off



rem ----- ���ϐ� -----
rem ���ϐ��̓N�H�[�g�ň͂܂Ȃ��ł��������B
rem   �K�v�ɉ����Ď��s���ɃN�H�[�g�ň͂ނ悤�Ɏ������Ă��܂��B
set ORGDRIVE=N:
set ORGDIR=N:\tmp\gitbareTest
set TGTDRIVE=C:
set TGTDIRBASE=C:\tmp TMP �e���v

rem �o�b�N�A�b�v�擾��t�H���_����[yyyyMMddHHmmss_bkup]�Ƃ���B
set tmpDirName=%date:/=%%time: =0%
set tmpDirName=%tmpDirName::=%
set tmpDirName=%tmpDirName:~0,14%_bkup
set TGTDIR=%TGTDIRBASE%\%tmpDirName%

rem �ۑ����㐔
set GENNUM=10
rem �o�b�N�A�b�v�f�B���N�g�����K�\��(dos)
rem ��폜�h�~�ׁ̈A���G�ȏ����𐄏��B
set BKDIRREG=^[2-9][0-9][0-9][0-9][01][0-9][0-3][0-9][0-2][0-9][0-5][0-9][0-5][0-9]_bkup$
rem ��A���N�����̍폜�h�~�BDATEGUARD�����ȏ�O�̃o�b�N�A�b�v�����݂��Ȃ��ꍇ�͍폜�����ɓ���Ȃ��B
rem ��F�������s�z��ł����[GENNUM]-1��ݒ肷��B
set DATEGUARD=9
rem ----- ���ϐ� -----



rem #####git���|�W�g���o�b�N�A�b�v#####
rem [git clone --mirror]�Ŏ擾����B

rem <���X�g�A���@>
rem   1. original���|�W�g�������S�폜��ɓ���p�X�ɐV�Korigin���|�W�g���쐬�B
rem   2. �������Ŏ擾�����o�b�N�A�b�v���|�W�g���t�H���_��cd�B
rem   3. �R�}���h[git push origin]�����s�B

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



rem #####����Ǘ�#####
rem   1. [TGTDIRBASE]�Ɏw�肵���t�H���_�z����
rem   2. ���O�����K�\��[BKUPDIRREGEX]�ɊY������t�H���_��
rem   3. �ŐV[GENNUM]���c���č폜����B
rem   4. �A���A[DATEGUARD]�����ȏ�O�̃o�b�N�A�b�v�����݂��Ȃ��ꍇ�͍폜�����ɓ���Ȃ��B

%TGTDRIVE%
cd "%TGTDIRBASE%"
if not %ERRORLEVEL%==0 (exit /b 1)
for /f "delims=" %%c in ('cd') do set TMPCURDIR=%%c
if not "%TGTDIRBASE%"=="%TMPCURDIR%" (exit /b 1)

forfiles /d %DATEGUARD% > nul 2>&1
if not %ERRORLEVEL%==0 (exit /b 0)

for /f "delims= skip=%GENNUM%" %%d in ('dir /ad /b /o-d^|findstr /r %BKDIRREG%') do rd /s /q "%%d"
if not %ERRORLEVEL%==0 (exit /b 1)



