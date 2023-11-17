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
New-Item -ItemType Directory -Force -Path ..\tools

if (-not(Test-Path -Path "..\tools\skopeo.exe" -PathType Leaf)) {
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest https://github.com/passcod/winskopeo/releases/latest/download/skopeo.exe -OutFile ..\tools\skopeo.exe   
}


if (-not(Test-Path -Path "..\tools\undocker.exe" -PathType Leaf)) {
    if ($null -eq (Get-Command "go.exe" -ErrorAction SilentlyContinue)) 
    { 
        Write-Host "Please download and install Go. See: https://go.dev/dl/"
        exit 1;
    }
    git clone https://git.jakstys.lt/motiejus/undocker ..\tools\undocker
    Push-Location ..\tools\undocker

    # Fix to compile with latest go on windows
    $file = 'rootfs\rootfs.go'
    $find = 'layers := make([]nameOffset, len(layerOffsets))'
    $replace = 'layers := make([]nameOffset, len(manifest[0].Layers))'

    (Get-Content $file).replace($find, $replace) | Set-Content $file
    go build -o ..\undocker.exe
    Pop-Location
    Remove-Item -recurse -force ..\tools\undocker
}

Pop-Location