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
mkdir -p $HOME/designs
if ! grep "LABEL=designs" /etc/fstab
then
    echo "LABEL=designs       $HOME/designs    ext4    defaults     0       2" | sudo tee -a /etc/fstab
fi
sudo mount -a
sudo chown -R $USER:$USER $HOME/designs