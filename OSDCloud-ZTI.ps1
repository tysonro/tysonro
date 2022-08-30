<#
OSDCloud ZTI script. This script is pulled from github using its URL when 
OSDCloud starts within WinPE. This way the deployment is fully automated.

Adapted from: https://www.osdsune.com/home/blog/2021/osdcloud-zti-way

Credit: https://www.osdcloud.com/
#>

# Defaults
$Interactive = $false
$DefaultOSName = 'Windows 10 21H2 x64'
$Defaults = @{
    OSEdition = 'Pro'
    OSLicense = 'Volume'
    OSLanguage = 'en-us'
    SkipAutopilot = $true
    Firmware = $true
    ZTI = $true    
}

# VIRTUAL MACHINES ONLY
$Model = Get-MyComputerModel
if ($Model -match 'virtual' -or $Model -match 'vmware') {
    if ($Model -match 'virtual') {
        # Set display resolution (hyper-v only)
        Set-DisRes 1920
    }    
    # VM's are for testing, force interactive mode to $true
    $Interactive = $true  
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
    Write-Host "2: Windows 11 21H2 x64" -ForegroundColor Yellow
    Write-Host "3: Start-OSDCloudGUI" -ForegroundColor Yellow
    Write-Host "4: Exit`n"-ForegroundColor Yellow

    $Selection = Read-Host "Please make a selection"

    switch ($Selection) {
        # Switch based on user input; decides what command to run
        '1' {Start-OSDCloud -OSName $DefaultOSName @Defaults} 
        '2' {Start-OSDCloud -OSName 'Windows 11 21H2 x64' @Defaults}
        '3' {Start-OSDCloudGUI} 
        '4' {exit}
    }    
}
else {
    # non-interactive (ZTI) command
    Start-OSDCloud -OSName $DefaultOSName @Defaults
}

### P15v Gen 1 (Type: 20QT) Ethernet Driver Workaround
# For some reason, OSDCloud has trouble installing the ethernet adapter driver for this particular model from Lenvovo's driver catalog
# However, manually installing them with pnputil.exe at the OOBE post imaging works.
# This workaround will copy the P15v ethernet driver and script wrapper to install the drivers to the empty partition on the USB drive
###
if ((Get-MyComputerModel) -eq 'ThinkPad P15v Gen 1') {
    Write-Warning "`nThinkPad P15v Gen 1 Detected...You will need to initiate a script to install extra drivers and flash the BIOS:"
    Write-Host "`nInstructions: " -ForegroundColor Cyan
    Write-Host "1. After the reboot at the OOBE, Open cmd: (fn)Shift + F10" -ForegroundColor Cyan
    Write-Host "2. Type: powershell" -ForegroundColor Cyan
    Write-Host "3. Type: Set-ExecutionPolicy RemoteSigned" -ForegroundColor Cyan
    Write-Host "4. Type: 'ls d:' or 'ls e:' to determine which drive letter to use (It should only return a folder and a .ps1 script)." -ForegroundColor Cyan
    Write-Host "5. Type: <driveLetter>:\Complete-P15vSetup.ps1" -ForegroundColor Cyan
    Write-Host "NOTE: This script will also upload the hardware hash to MEM too!"
    pause
    ""
}

# Restart from WinPE
Write-Host "Restarting in 10 seconds!" -ForegroundColor Green
Start-Sleep -Seconds 10
Restart-Computer -Force
