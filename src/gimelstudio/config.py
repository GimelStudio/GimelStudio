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
import json

import gimelstudio.constants as appconst


class AppData(object):
    def __init__(self):
        self.app_frozen = appconst.APP_FROZEN
        self.app_dir = appconst.APP_DIR
        self.app_name = appconst.APP_NAME
        self.app_website_url = appconst.APP_WEBSITE_URL
        self.app_description = appconst.APP_DESCRIPTION
        self.app_version = appconst.APP_VERSION
        self.app_version_tag = appconst.APP_VERSION_TAG
        self.app_version_full = appconst.APP_VERSION_FULL


class AppConfiguration(AppData):
    def __init__(self, app):
        AppData.__init__(self)
        self.app = app
        self.prefs = {}

    def Config(self, key=None, value=None):
        if value is not None and value is not None:
            self.prefs[key] = value
        else:
            return self.prefs[key]

    def Load(self):
        path = os.path.expanduser("~/.gimelstudio/config.json")
        try:
            os.makedirs(
                os.path.expanduser("~/.gimelstudio/"), exist_ok=True)
            with open(path, "r") as file:
                self.prefs = json.load(file)
        except IOError:
            pass  # Just use default

    def Save(self):
        # Add app version to file
        self.prefs['app_version'] = self.app_version

        path = "~/.gimelstudio/config.json"
        try:
            with open(
                os.path.expanduser(path), "w") as file:
                json.dump(self.prefs, file)
        except IOError:
            pass  # Not a big deal
