@ECHO OFF
CLS

REM Detect current user (should be an administrator)
SET USER=%USERNAME%
SET DOM=%USERDOMAIN%
SET ACCOUNT=%DOM%\%USER%
SET TASKNAME=OpenVPN Logon Task Creator (main)

REM Where to store the created XML-File
SET XML=%temp%\%RANDOM%_temp.xml

REM What to start via the generated task
SET TOSTART=C:\ProgramData\OpenVPN\create_usertask.cmd

ECHO ^<?xml version="1.0" encoding="UTF-16"?^> > "%XML%"
ECHO ^<Task version="1.3" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task"^> >> "%XML%"
echo.   ^<RegistrationInfo^> >> "%XML%"
echo.     ^<Date^>2001-01-01T01:01:01.01^</Date^> >> "%XML%"
echo.     ^<Author^>Der PCFreak^</Author^> >> "%XML%"
echo.     ^<Description^>This task will be executed at logon of any user. The script will then determine the username and domain/computer of this user. The user will then added to the group "Network Configuration Operators" and additionally a new scheduled task with name "%DOM%_%USER%_openvpn" will be created. The automatically created task will be set up to only run when the specific, detected user logs on. This task will then start OpenVPN-GUI with highest privileges at logon.^</Description^> >> "%XML%"
echo.   ^</RegistrationInfo^> >> "%XML%"

echo.   ^<Triggers^> >> "%XML%"
echo.     ^<LogonTrigger^> >> "%XML%"
echo.       ^<StartBoundary^>2001-01-01T01:01:01^</StartBoundary^> >> "%XML%"
echo.       ^<Enabled^>true^</Enabled^> >> "%XML%"
echo.     ^</LogonTrigger^> >> "%XML%"
echo.   ^</Triggers^> >> "%XML%"

echo.   ^<Principals^> >> "%XML%"
echo.     ^<Principal id="Author"^> >> "%XML%"
echo.       ^<UserId^>%ACCOUNT%^</UserId^> >> "%XML%"
echo.       ^<LogonType^>Password^</LogonType^> >> "%XML%"
echo.       ^<RunLevel^>HighestAvailable^</RunLevel^> >> "%XML%"
echo.     ^</Principal^> >> "%XML%"
echo.   ^</Principals^> >> "%XML%"

echo.   ^<Settings^> >> "%XML%"
echo.     ^<MultipleInstancesPolicy^>IgnoreNew^</MultipleInstancesPolicy^> >> "%XML%"
echo.     ^<DisallowStartIfOnBatteries^>false^</DisallowStartIfOnBatteries^> >> "%XML%"
echo.     ^<StopIfGoingOnBatteries^>false^</StopIfGoingOnBatteries^> >> "%XML%"
echo.     ^<AllowHardTerminate^>true^</AllowHardTerminate^> >> "%XML%"
echo.     ^<StartWhenAvailable^>false^</StartWhenAvailable^> >> "%XML%"
echo.     ^<RunOnlyIfNetworkAvailable^>false^</RunOnlyIfNetworkAvailable^> >> "%XML%"
echo.     ^<IdleSettings^> >> "%XML%"
echo.       ^<StopOnIdleEnd^>true^</StopOnIdleEnd^> >> "%XML%"
echo.       ^<RestartOnIdle^>false^</RestartOnIdle^> >> "%XML%"
echo.     ^</IdleSettings^> >> "%XML%"
echo.     ^<AllowStartOnDemand^>true^</AllowStartOnDemand^> >> "%XML%"
echo.     ^<Enabled^>true^</Enabled^> >> "%XML%"
echo.     ^<Hidden^>false^</Hidden^> >> "%XML%"
echo.     ^<RunOnlyIfIdle^>false^</RunOnlyIfIdle^> >> "%XML%"
echo.     ^<WakeToRun^>false^</WakeToRun^> >> "%XML%"
echo.     ^<ExecutionTimeLimit^>P3D^</ExecutionTimeLimit^> >> "%XML%"
echo.     ^<Priority^>7^</Priority^> >> "%XML%"
echo.   ^</Settings^> >> "%XML%"

echo.   ^<Actions Context="Author"^> >> "%XML%"
echo.     ^<Exec^> >> "%XML%"
echo.       ^<Command^>"%TOSTART%"^</Command^> >> "%XML%"
echo.     ^</Exec^> >> "%XML%"
echo.   ^</Actions^> >> "%XML%"

echo ^</Task^> >> "%XML%"


REM Create the task using schtasks
REM use /f to make sure we can re-create this task on demand
%windir%\system32\schtasks.exe /create /TN "%TASKNAME%" /XML "%XML%" /RU %ACCOUNT% /RP "" /F

REM Delete temporary XML FILE
DEL /Q "%XML%"
