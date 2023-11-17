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

Write-Host "Checking Prerequisites"
.\steps\00_download_compile_undocker.ps1
Write-Host "Downloading latest image"
.\steps\01_get_image.ps1
Write-Host "Updating WSL distribution image"
$DistName = Read-Host -Prompt 'Enter name of WSL dist'
.\steps\06_update.ps1 $DistName
Remove-Item rootfs.tar
Write-Host "Installing additional tools in image"
.\steps\03_install_additional_images.ps1 $DistName
Write-Host "Mount designs disk"
.\steps\05_mount_designs.ps1 $DistName
Write-Host "Run"
wsl -d $DistName