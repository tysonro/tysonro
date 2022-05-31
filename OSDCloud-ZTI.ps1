<#
OSDCloud ZTI script. This script is pulled from github using its URL when 
OSDCloud starts within WinPE. This way the deployment is fully automated.

Adapted from: https://www.osdsune.com/home/blog/2021/osdcloud-zti-way

Credit: https://www.osdcloud.com/
#>

# Defaults
$OSBuild = '21H2'
$OSEdition = 'Pro'
$Interactive = $false

if ((Get-MyComputerModel) -match 'Virtual') {
    # Change Display Resolution for Virtual Machine
    Write-Host -ForegroundColor Green "Setting Display Resolution to 1600x"
    Set-DisRes 1600   
}

Write-Host "=========================================================================" -ForegroundColor Cyan
Write-Host "===================== Cloud Image Deployment Script =====================" -ForegroundColor Cyan
Write-Host "=========================================================================" -ForegroundColor Cyan
Write-Host "========================== Starting Imaging ZTI =========================" -ForegroundColor Cyan
Write-Host "============================== $OSBuild - $OSEdition ===============================" -ForegroundColor Cyan
Write-Host "=========================================================================" -ForegroundColor Cyan

Start-Sleep -Seconds 5
Write-Host  -ForegroundColor Yellow "Loading OSDCloud..."
Import-Module OSD -Force

if ($Interactive) {
    # Prompt for OS options
    Write-Host "1: Win10 20H2 | Pro" -ForegroundColor Yellow
    Write-Host "2: Win10 21H2 | Pro" -ForegroundColor Yellow
    Write-Host "3: Start-OSDCloud"-ForegroundColor Yellow
    Write-Host "4: Start-OSDCloudGUI"-ForegroundColor Yellow
    Write-Host "5: Exit`n"-ForegroundColor Yellow
    $input = Read-Host "Please make a selection"

    switch ($input) {
        # Switch based on user input; decides what command to run
        '1' {Start-OSDCloud -OSLanguage en-us -OSBuild 20H2 -OSEdition Pro -ZTI} 
        '2' {Start-OSDCloud -OSLanguage en-us -OSBuild 21H2 -OSEdition Pro -ZTI} 
        '3' {Start-OSDCloud}
        '4' {Start-OSDCloudGUI} 
        '5' {exit}
    }    
}
else {
    # non-interactive (ZTI) command
    Start-OSDCloud -OSLanguage en-us -OSBuild $OSBuild -OSEdition $OSEdition -ZTI
}

# Restart from WinPE
Write-Host  -ForegroundColor Cyan "Restarting in 10 seconds!"
Start-Sleep -Seconds 10
Restart-Computer -Force
