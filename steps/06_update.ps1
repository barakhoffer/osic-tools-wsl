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

$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
Push-Location $scriptPath
. .\utils.ps1
$DistName = $args[0]
$TargetDir = Get-Dist-Directory -DistName $DistName
if ($null -eq $TargetDir)
{
    Write-Host "Error: dist name :$DistName not found.";
    exit 1;
}
Write-Host "This will delete the distribution and import the new image (the designs disk will not be deleted)"
$confirm = Read-Host -Prompt "Are you sure? (y/n)"
if ($confirm -eq "y") {
    wsl.exe --unregister $DistName
    wsl.exe --import $DistName $TargetDir ../rootfs.tar
    wsl.exe -d $DistName -e ./02_install.sh
    wsl.exe -t $DistName    
}

Pop-Location