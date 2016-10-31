if (-Not Test-Path C:\ProgramData\OpenVPN\create_usertask.cmd) {
  New-Item C:\ProgramData\OpenVPN\ -ItemType Directory;
  Invoke-WebRequest https://raw.githubusercontent.com/ivebeenlinuxed/OpenVPN-NonAdmin/master/create_usertask.cmd -OutFile C:\ProgramData\OpenVPN\create_usertask.cmd
}

Invoke-WebRequest https://github.com/ivebeenlinuxed/OpenVPN-NonAdmin/blob/master/create_main_task_only_runonce.cmd -OutFile $env:temp/create_main_task_only_runonce.cmd

$env:temp/create_main_task_only_runonce.cmd

Remove-Item $env:temp/create_main_task_only_runonce.cmd

Invoke-WebRequest https://swupdate.openvpn.org/community/releases/openvpn-install-2.3.12-I602-x86_64.exe -OutFile $env:temp/openvpn-installer.exe

$env:temp/openvpn-installer.exe /s

Start-Process -FilePath C:\Program Files\OpenVPN\bin\openvpn-gui.exe
Get-Process openvpn-gui | stop-process

HKEY_LOCAL_MACHINE\SOFTWARE\OpenVPN-GUI\log_dir

Invoke-WebRequest https://github.com/ivebeenlinuxed/OpenVPN-NonAdmin/blob/master/reg_edits.reg -OutFile $env:temp/openvpn_edits.reg

regedit $env:temp/openvpn_edits.reg
