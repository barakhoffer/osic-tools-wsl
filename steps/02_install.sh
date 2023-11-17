#!/bin/bash
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
echo "Choose username:"
read NEW_USER
useradd -m -G sudo -s /bin/bash "$NEW_USER"
passwd "$NEW_USER"
chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo
tee /etc/wsl.conf <<_EOF
[boot]
systemd = true
[user]
default=${NEW_USER}
_EOF

echo export PDK_ROOT=/foss/pdks > /home/$NEW_USER/.bashrc
echo export TOOLS=/foss/tools >> /home/$NEW_USER/.bashrc
echo export DESIGNS=/foss/designs >> /home/$NEW_USER/.bashrc
cat /headless/.bashrc >> /home/$NEW_USER/.bashrc
cp -r /headless/.gaw /home/$NEW_USER
cp -r /headless/.klayout /home/$NEW_USER
cp -r /headless/.spiceinit /home/$NEW_USER