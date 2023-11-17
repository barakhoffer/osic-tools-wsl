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

# Based on: https://www.reddit.com/r/bashonubuntuonwindows/comments/t5d6l0/get_list_of_all_wsl_distributions_their_locations
function Get-Dist-Directory {
    param (
        $DistName
    )    
    Get-ChildItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\Lxss" -Recurse |
    ForEach-Object {
        $distro_name = ($_ | Get-ItemProperty -Name DistributionName).DistributionName
        $distro_dir =  ($_ | Get-ItemProperty -Name BasePath).BasePath
        
        $distro_dir = Switch ($PSVersionTable.PSEdition) {
          "Core" {
            $distro_dir -replace '^\\\\\?\\',''
          }
          "Desktop" {
            if ($distro_dir.StartsWith('\\?\')) {
                $distro_dir
            } else {
                '\\?\' + $distro_dir
            }
          }
        }
        if ($DistName -eq $distro_name) {
            Write-Output $($distro_dir -replace '\\\\\?\\','')
        }
    }
}
