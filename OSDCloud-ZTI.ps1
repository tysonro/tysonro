# https://www.osdsune.com/home/blog/2021/osdcloud-zti-way
Write-Host "=========================================================================" -ForegroundColor Cyan
Write-Host "===================== Cloud Image Deployment Script =====================" -ForegroundColor Cyan
Write-Host "=========================================================================" -ForegroundColor Cyan
Write-Host "========================== Starting Imaging ZTI =========================" -ForegroundColor Cyan
Write-Host "============================= Edition - 20H2 ============================" -ForegroundColor Cyan
Write-Host "=========================================================================" -ForegroundColor Cyan

Start-Sleep -Seconds 5
$input = '1'
<#
Write-Host "1: Zero-Touch Win10 20H2 | English | Enterprise" -ForegroundColor Yellow
Write-Host "2: Manual"-ForegroundColor Yellow
Write-Host "3: Exit`n"-ForegroundColor Yellow
$input = Read-Host "Please make a selection"
#>

Write-Host  -ForegroundColor Yellow "Loading OSDCloud..."

#Install-Module OSD -Force
Import-Module OSD -Force

switch ($input)
{
    '1' { Start-OSDCloud -OSLanguage en-us -OSBuild 20H2 -OSEdition Enterprise -ZTI } 
    '2' { Start-OSDCloud	} 
    '3' { Exit }
}

#Write-Host "Can I upload the AP hardware hash here?"
#pause

#Restart from WinPE
Write-Host  -ForegroundColor Cyan "Restarting in 20 seconds!"
Start-Sleep -Seconds 20
wpeutil reboot
