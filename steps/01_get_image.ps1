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
..\tools\skopeo.exe copy docker://docker.io/hpretl/iic-osic-tools:latest docker-archive:..\docker_archive.tar:iic-osic-tools:latest --insecure-policy --override-os linux
..\tools\undocker.exe ..\docker_archive.tar ..\rootfs.tar
Remove-Item ..\docker_archive.tar
Pop-Location