﻿$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://download.cdn.viber.com/desktop/windows/ViberSetup.exe'
$checksum     = '54197D3FE35837CCFF2F6D9CC6EEDF6F30EF91E750CBF3402C78F59E79A50EA2'
$checksumType = 'sha256'
$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  softwareName   = "Viber*"
  silentArgs     = '/install /quiet /norestart'
  validExitCodes = @(0)
  destination   = $toolsDir
}

# silent install requires AutoHotKey
$ahkFile = Join-Path $toolsDir 'chocolateyInstall.ahk'
$ahkEXE = Get-ChildItem "$env:ChocolateyInstall\lib\autohotkey.portable" -Recurse -filter autohotkey.exe
$ahkProc = Start-Process -FilePath $ahkEXE.FullName -ArgumentList "$ahkFile" -PassThru
Write-Debug "AutoHotKey start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$($ahkProc.Id)"

Install-ChocolateyPackage @packageArgs

if (Get-Process -id $ahkProc.Id -ErrorAction SilentlyContinue) {Stop-Process -id $ahkProc.Id}
