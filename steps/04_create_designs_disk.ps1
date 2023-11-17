# ========================================================================
#
# SPDX-FileCopyrightText: 2023 Barak Hoffer
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0
# ========================================================================

# using https://superuser.com/questions/108207/how-to-run-a-powershell-script-as-administrator
$DistName = $args[0]
$Elevated = $args[1]

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
    if ($Elevated -eq 'elevated') {
        # tried to elevate, did not work, aborting
        Write-Host "Error: Failed elevate."
        exit 1
    } else {
        Start-Process powershell.exe -Wait -Verb RunAs -ArgumentList ('-noprofile -file "{0}" {1} elevated' -f ($myinvocation.MyCommand.Definition, $DistName))
    }
    exit
}

$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
Push-Location $scriptPath
. .\utils.ps1

$TargetDir = Get-Dist-Directory -DistName $DistName
if ($null -eq $TargetDir)
{
    Write-Host "Error: dist name :$DistName not found.";
    exit 1;
}

New-VHD -Path $TargetDir\designs.vhdx -SizeBytes 16GB
$ACL = Get-ACL $TargetDir\designs.vhdx
$Group = New-Object System.Security.Principal.NTAccount($Env:UserName)
$ACL.SetOwner($Group)
Set-ACL -Path $TargetDir\designs.vhdx -AclObject $ACL

$disk = Mount-VHD -Path $TargetDir\designs.vhdx -PassThru | Get-Disk
$disk.UniqueId | Out-File -Encoding ASCII -FilePath .\diskid.txt
Dismount-VHD -Path $TargetDir\designs.vhdx
wsl.exe -d $DistName --mount --vhd $TargetDir\designs.vhdx --bare
wsl.exe -d $DistName -u root -e "./04_create_designs_disk.sh"
Remove-Item .\diskid.txt
wsl.exe -d $DistName --unmount
Pop-Location