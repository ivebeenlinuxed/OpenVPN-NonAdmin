# OpenVPN-NonAdmin
Scripts to install OpenVPN for use by users who aren't admins

To Install OpenVPN, just run the following command in Powershell "As Administrator":

Invoke-WebRequest -URI https://raw.githubusercontent.com/ivebeenlinuxed/OpenVPN-NonAdmin/master/RUNME.ps1 -UseBasicParsing | Invoke-Expression

That's it!

To uninstall

1) Delete the scheduled tasks
2) Uninstall OpenVPN

Patches Welcome
