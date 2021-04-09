# ----------------------------------------------------------------------------
# Gimel Studio Copyright 2019-2021 by Noah Rahm and contributors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ----------------------------------------------------------------------------

import os
import sys


APP_FROZEN = getattr(sys, "frozen", False)

if APP_FROZEN:
    APP_DIR = os.path.dirname(os.path.abspath(sys.argv[0]))
else:
    APP_DIR = os.path.join(os.path.dirname(os.path.abspath(sys.argv[0])), "..")

APP_NAME = "Gimel Studio"
APP_WEBSITE_URL = "https://gimelstudio.github.io"
APP_DESCRIPTION = "Non-destructive, node-based 2D image graphics editor focused on simplicity, speed, elegance and usability"

APP_VERSION = "0.6.0"
APP_VERSION_TAG = "alpha"
APP_VERSION_FULL = "{0} {1}".format(APP_VERSION, APP_VERSION_TAG)

APP_CORE_DEVELOPERS = [""]
APP_CONTRIBUTORS = [""]
APP_TRANSLATORS = [""]
