 if (-Not $(Test-Path C:\ProgramData\OpenVPN\create_usertask.cmd)) {
  New-Item C:\ProgramData\OpenVPN\ -ItemType Directory;
  Invoke-WebRequest https://raw.githubusercontent.com/ivebeenlinuxed/OpenVPN-NonAdmin/master/create_usertask.cmd -UseBasicParsing -OutFile C:\ProgramData\OpenVPN\create_usertask.cmd
}

Invoke-WebRequest https://raw.githubusercontent.com/ivebeenlinuxed/OpenVPN-NonAdmin/master/create_main_task_only_runonce.cmd -UseBasicParsing -OutFile $env:temp/create_main_task_only_runonce.cmd

powershell -Command "$env:temp/create_main_task_only_runonce.cmd"

Remove-Item $env:temp/create_main_task_only_runonce.cmd

Invoke-WebRequest https://swupdate.openvpn.org/community/releases/openvpn-install-2.3.12-I602-x86_64.exe -UseBasicParsing -OutFile $env:temp/openvpn-installer.exe

powershell -Command "$env:temp/openvpn-installer.exe /S"

Start-Process -FilePath "C:\Program Files\OpenVPN\bin\openvpn-gui.exe"
Get-Process openvpn-gui | stop-process

Invoke-WebRequest https://raw.githubusercontent.com/ivebeenlinuxed/OpenVPN-NonAdmin/master/reg_edits.reg -UseBasicParsing -OutFile $env:temp/openvpn_edits.reg

regedit $env:temp/openvpn_edits.reg
