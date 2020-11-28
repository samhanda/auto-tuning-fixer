#Checks to see if we're running as Admin so script runs properly
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}

Set-ExecutionPolicy RemoteSigned
$nl = [Environment]::NewLine

cls
sleep 1

#Finds auto-tuning level with netsh command
$at_level = netsh interface tcp show global | findstr -i "Auto-Tuning Level"  
$at_level = $at_level.Split(":")
$at_level = $at_level.Replace("Receive Window Auto-Tuning Level", "")
$at_level = $at_level.Trim()


sleep 1
Write-Host -ForegroundColor RED "Your current auto-tuning level is:", $at_level
sleep 1
$nl

#If level is normal, no more needs to be done and you can just exit
if ($at_level -eq "normal"){
Write-Host "Your auto-tuning level is already normal, lookin' cool!"
$nl
}

#Prompt if auto-tuning level should be changed or not
if ($at_level -ne "normal"){

Write-Host -ForegroundColor YELLOW "Your auto-tuning level is not normal!"
$nl
$choice = Read-Host -Prompt "Do you wish to change your auto-tuning level to normal? [Y/N]"
$choice = $choice.ToUpper()

if ($choice -eq "Y"){
Write-Host -ForegroundColor YELLOW "Setting autotuning level to normal..."
netsh int tcp set global autotuninglevel=normal
}

elseif ($choice -eq "N"){
Write-Host "Didn't change auto-tuning level!"
}

}

$end = Write-Host -ForegroundColor Green "Press any key to exit..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
