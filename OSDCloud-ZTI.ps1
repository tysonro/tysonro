<#
OSDCloud ZTI script. This script is pulled from github using its URL when 
OSDCloud starts within WinPE. This way the deployment is fully automated.

Adapted from: https://www.osdsune.com/home/blog/2021/osdcloud-zti-way

Credit: https://www.osdcloud.com/
#>

# Defaults
$Interactive = $true
$DefaultOSName = 'Windows 10 21H2 x64'
$Defaults = @{
    OSEdition = 'Pro'
    OSLicense = 'Volume'
    OSLanguage = 'en-us'
    SkipAutopilot = $true
    Firmware = $true
    ZTI = $true    
}

# If running Hyper-V vm, change display resolution 
if ((Get-MyComputerModel) -match 'Virtual Machine') {
    Set-DisRes 1920
}

Write-Host "=========================================================================" -ForegroundColor Cyan
Write-Host "===================== Cloud Image Deployment Script =====================" -ForegroundColor Cyan
Write-Host "=========================================================================" -ForegroundColor Cyan
Write-Host "========================== Starting Imaging ZTI =========================" -ForegroundColor Cyan
Write-Host "=========================================================================" -ForegroundColor Cyan

Start-Sleep -Seconds 5
Write-Host  -ForegroundColor Yellow "Loading OSDCloud..."
Import-Module OSD -Force

if ($Interactive) {
    # Prompt for OS options
    Write-Host "1: Windows 10 21H2 x64" -ForegroundColor Yellow
    Write-Host "2: Windows 11 22H1 x64" -ForegroundColor Yellow
    Write-Host "3: Start-OSDCloudGUI" -ForegroundColor Yellow
    Write-Host "4: Exit`n"-ForegroundColor Yellow

    $Selection = Read-Host "Please make a selection"

    switch ($Selection) {
        # Switch based on user input; decides what command to run
        '1' {Start-OSDCloud -OSName $DefaultOSName @Defaults} 
        '2' {Start-OSDCloud -OSName 'Windows 11 22H1 x64' @Defaults}#-OSEdition 'Pro' -OSLanguage 'en-us' -Firmware -ZTI} 
        '3' {Start-OSDCloudGUI} 
        '4' {exit}
        # "-OSVERSION" is legacy now, update to use "OSName = Windows 10 21H2 x64"
        # Start-OSDCloud -Manufacturer 'Lenovo' -Product '20TQ' -Firmware -Restart -SkipAutopilot -SkipODT -OSName 'Windows 10 21H2 x64' -OSEdition 'Pro' -OSLanguage 'en-us' -OSLicense 'Volume'
    }    
}
else {
    # non-interactive (ZTI) command
    Start-OSDCloud -OSName $DefaultOSName @Defaults
    #Start-OSDCloud -OSVersion $OSVersion -OSBuild $OSBuild -OSEdition $OSEdition -OSLanguage 'en-us' -Firmware -ZTI
}

# Restart from WinPE
Write-Host  -ForegroundColor Cyan "Restarting in 10 seconds!"
Start-Sleep -Seconds 10
Restart-Computer -Force
