# ----------------------------------------------------------------------------
# Gimel Studio Copyright 2019-2022 by Noah Rahm and contributors
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
import os.path


# Application
APP_FROZEN = getattr(sys, "frozen", False)
APP_DIR = os.path.dirname(os.path.abspath(sys.argv[0]))

APP_VERSION = "0.6.0"
APP_VERSION_TAG = " pre-alpha 2"
APP_VERSION_FULL = "{0}{1}".format(APP_VERSION, APP_VERSION_TAG)

APP_NAME = "Gimel Studio"
APP_DESCRIPTION = "Non-destructive, node-based 2D image graphics editor focused on simplicity, speed, elegance and usability"
APP_COPYRIGHT = "© 2019–2022 Noah Rahm and contributors"

APP_WEBSITE_URL = "https://gimelstudio.github.io"
APP_LICENSE_URL = "https://github.com/GimelStudio/GimelStudio/blob/master/LICENSE"
APP_GITHUB_URL = "https://github.com/GimelStudio/GimelStudio"
APP_CREDITS_URL = "https://github.com/GimelStudio/GimelStudio/graphs/contributors"
APP_DISCORD_URL = "https://discord.gg/Rqw-bDr-VDpK"  # Remove dashes when using this
APP_YOUTUBE_URL = "https://www.youtube.com/channel/UCP9CNtBPMPRwOR4jUiMMkhQ"

APP_FULL_TITLE = "{0} v{1}".format(APP_NAME, APP_VERSION_FULL)

APP_CONFIG_FILE = os.path.expanduser("~/.gimelstudio/pre-a2-config.json")

# File system
SUPPORTED_FT_OPEN_LIST = [
    ".jpg",
    ".jpeg",
    ".png",
    ".gif",
    ".bmp",
    ".exr",
    ".webp",
    ".tiff"
]
SUPPORTED_FT_OPEN_WILDCARD = \
    "All files (*.*)|*.*|" \
    "JPG file (*.jpg)|*.jpg|" \
    "JPEG file (*.jpeg)|*.jpeg|" \
    "PNG file (*.png)|*.png|" \
    "BMP file (*.bmp)|*.bmp|" \
    "GIF file (*.gif)|*.gif|" \
    "EXR file (*.exr)|*.exr|" \
    "WEBP file (*.webp)|*.webp|" \
    "TIFF file (*.tiff)|*.tiff"

SUPPORTED_FT_SAVE_LIST = [
    ".jpg",
    ".jpeg",
    ".png",
    ".gif",
    ".bmp",
    ".exr",
    ".webp",
    ".tiff"
]
SUPPORTED_FT_SAVE_WILDCARD = \
    "JPG file (*.jpg)|*.jpg|" \
    "JPEG file (*.jpeg)|*.jpeg|" \
    "PNG file (*.png)|*.png|" \
    "BMP file (*.bmp)|*.bmp|" \
    "GIF file (*.gif)|*.gif|" \
    "EXR file (*.exr)|*.exr|" \
    "WEBP file (*.webp)|*.webp|" \
    "TIFF file (*.tiff)|*.tiff|" \
    "All files (*.*)|*.*"

PROJECT_FILE_WILDCARD = "GIMEL file (*.gimel)|*.gimel"

# Colors
AREA_BG_COLOR = "#242528"
AREA_TOPBAR_COLOR = "#3f4146"

PROP_HEADER_COLOR = "#3f4146"
PROP_BG_COLOR = "#36383c"

ACCENT_COLOR = "#5173b5"
DARK_COLOR = "#1b1c1e"

TEXT_COLOR = "#dfdfdf"

ADD_NODE_MENU_BG = "#121314"
