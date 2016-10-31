@ECHO OFF
CLS

REM Some Variables

REM Where to store the created XML-File
SET XML=%temp%\%RANDOM%_temp.xml

REM Name of the Network Configuration Operators group (without quotes)
SET NGROUP=Network Configuration Operators

REM What to start via the generated task
SET TOSTART=C:\Program Files\OpenVPN\bin\openvpn-gui.exe


REM We need to find the domain/computer and username of the user that is logging on
REM We run under a different user context so we need a trick to do that
REM Session to search, usually "console"
SET SESSION=console
REM Process to search, usually "explorer.exe"
SET PROCESS=explorer.exe
for /f "usebackq tokens=8,9 delims=\ " %%a IN (`tasklist /fi "SESSIONNAME eq %SESSION%" /FI "IMAGENAME eq %PROCESS%" /V /NH`) do (
  SET DOM=%%a
  SET USER=%%b
  SET ACCOUNT=%%a\%%b
)
echo The detected user was %USER% in domain/computer %DOM% .



ECHO ^<?xml version="1.0" encoding="UTF-16"?^> > "%XML%"

ECHO.  ^<Task version="1.3" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task"^> >> "%XML%"

ECHO. ^<Settings^> >> "%XML%"
ECHO.   ^<MultipleInstancesPolicy^>StopExisting^</MultipleInstancesPolicy^> >> "%XML%"
ECHO.   ^<DisallowStartIfOnBatteries^>false^</DisallowStartIfOnBatteries^> >> "%XML%"
ECHO.   ^<StopIfGoingOnBatteries^>false^</StopIfGoingOnBatteries^> >> "%XML%"
ECHO.   ^<AllowHardTerminate^>true^</AllowHardTerminate^> >> "%XML%"
ECHO.   ^<StartWhenAvailable^>false^</StartWhenAvailable^> >> "%XML%"
ECHO.   ^<RunOnlyIfNetworkAvailable^>false^</RunOnlyIfNetworkAvailable^> >> "%XML%"
ECHO.    ^<IdleSettings^> >> "%XML%"
ECHO.     ^<StopOnIdleEnd^>true^</StopOnIdleEnd^> >> "%XML%"
ECHO.     ^<RestartOnIdle^>false^</RestartOnIdle^> >> "%XML%"
ECHO.    ^</IdleSettings^> >> "%XML%"
ECHO.   ^<AllowStartOnDemand^>true^</AllowStartOnDemand^> >> "%XML%"
ECHO.   ^<Enabled^>true^</Enabled^> >> "%XML%"
ECHO.   ^<Hidden^>false^</Hidden^> >> "%XML%"
ECHO.   ^<RunOnlyIfIdle^>false^</RunOnlyIfIdle^> >> "%XML%"
ECHO.   ^<DisallowStartOnRemoteAppSession^>false^</DisallowStartOnRemoteAppSession^> >> "%XML%"
ECHO.   ^<UseUnifiedSchedulingEngine^>false^</UseUnifiedSchedulingEngine^> >> "%XML%"
ECHO.   ^<WakeToRun^>false^</WakeToRun^> >> "%XML%"
ECHO.   ^<ExecutionTimeLimit^>PT0S^</ExecutionTimeLimit^> >> "%XML%"
ECHO.   ^<Priority^>7^</Priority^> >> "%XML%"
ECHO.  ^</Settings^> >> "%XML%"

ECHO.  ^<Actions Context="Author"^> >> "%XML%"
ECHO.   ^<Exec^> >> "%XML%"
ECHO.   ^<Command^>"%TOSTART%"^</Command^> >> "%XML%"
ECHO.   ^</Exec^> >> "%XML%"
ECHO.  ^</Actions^> >> "%XML%"

ECHO.  ^<RegistrationInfo^> >> "%XML%"
ECHO.   ^<Date^>2013-07-11T11:39:44.2138665^</Date^> >> "%XML%"
ECHO.   ^<Author^>Der PCFreak^</Author^> >> "%XML%"
echo.   ^<Description^>This task will run when the user %ACCOUNT% logs on. It will then start OpenVPN-GUI with in the context of this user with highest privileges at logon of this user.^</Description^> >> "%XML%"
ECHO.  ^</RegistrationInfo^> >> "%XML%"

ECHO.  ^<Principals^> >> "%XML%"
ECHO.   ^<Principal id="Author"^> >> "%XML%"
ECHO.   ^<UserId^>%ACCOUNT%^</UserId^> >> "%XML%"
ECHO.   ^<LogonType^>InteractiveToken^</LogonType^> >> "%XML%"
ECHO.   ^<RunLevel^>HighestAvailable^</RunLevel^> >> "%XML%"
ECHO.   ^</Principal^> >> "%XML%"
ECHO.  ^</Principals^> >> "%XML%"

ECHO.  ^<Triggers^> >> "%XML%"
ECHO.   ^<LogonTrigger^> >> "%XML%"
ECHO.   ^<Enabled^>true^</Enabled^> >> "%XML%"
ECHO.   ^<UserId^>%ACCOUNT%^</UserId^> >> "%XML%"
ECHO.   ^</LogonTrigger^> >> "%XML%"
ECHO.  ^</Triggers^> >> "%XML%"

ECHO. ^</Task^> >> "%XML%"


REM Create the task using schtasks
REM do not use /f since we only want to create this task once!
%windir%\system32\schtasks.exe /create /xml "%XML%" /tn "%DOM%_%USER%_openvpn" /DELAY 0000:25


REM Add the user to the Network Configuration Operators group
net localgroup "%NGROUP%" %ACCOUNT% /add

REM Delete temporary XML FILE
DEL /Q "%XML%"
