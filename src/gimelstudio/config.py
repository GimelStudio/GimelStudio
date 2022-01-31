# ----------------------------------------------------------------------------
# Gimel Studio Copyright 2019-2022 by the Gimel Studio project contributors
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
import os.path

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
        self.app_config_file = appconst.APP_CONFIG_FILE


class AppConfiguration(AppData):
    def __init__(self, app):
        AppData.__init__(self)
        self.app = app
        self.prefs = {}

    def Config(self, key: str = None, keys: tuple = None, value=None, default=None):
        if key is not None:
            keys = (key)

        if value is not None:
            d_key = None
            for k in keys:
                if keys.index(k) == 0:
                    d_key = self.prefs[k]
                elif keys.index(k) == len(keys) - 1:
                    d_key[k] = value
                else:
                    d_key = d_key[k]
        else:
            try:
                d_key = None
                for k in keys:
                    if keys.index(k) == 0:
                        d_key = self.prefs[k]
                    elif keys.index(k) == len(keys) - 1:
                        return d_key[k]
                    else:
                        d_key = d_key[k]
            except KeyError:
                return default

    def Load(self):
        try:
            os.makedirs(os.path.expanduser("~/.gimelstudio/"),
                        exist_ok=True)

            if not os.path.exists(self.app_config_file):
                with open("gimelstudio/datafiles/default_config.json") as f:
                    default_config = f.read()

                with open(self.app_config_file, "w+") as f:
                    f.write(default_config)

            with open(self.app_config_file, "r") as file:
                self.prefs = json.load(file)
        except IOError:
            pass  # Just use default

    def Save(self):
        # Add app version to file
        self.prefs['app_version'] = self.app_version_full

        try:
            with open(self.app_config_file, "w") as file:
                json.dump(self.prefs, file, indent=4)
        except IOError:
            pass  # Not a big deal
