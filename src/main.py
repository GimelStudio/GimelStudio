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
import platform

import wx
import wx.adv

from gimelstudio import ApplicationFrame

# Fix blurry text on Windows 10
import ctypes
try:
    ctypes.windll.shcore.SetProcessDpiAwareness(1)  # Global dpi aware
    ctypes.windll.shcore.SetProcessDpiAwareness(2)  # Per-monitor dpi aware
except Exception:
    pass  # Fail when not Windows

# Install a custom displayhook to keep Python from setting the global
# _ (underscore) to the value of the last evaluated expression.
# If we don't do this, our mapping of _ to gettext can get overwritten.
# This is useful/needed in interactive debugging with PyShell.
def _displayHook(obj):
    """ Custom display hook to prevent Python stealing '_'. """

    if obj is not None:
        print(repr(obj))

# Add translation macro to builtin similar to what gettext does.
import builtins
builtins.__dict__['_'] = wx.GetTranslation


class MainApp(wx.App):

    def OnInit(self):

        # Work-around for Python stealing "_".
        sys.displayhook = _displayHook
        self.installDir = os.path.split(os.path.abspath(sys.argv[0]))[0]

        # Used to identify app in $HOME/
        self.SetAppName("GimelStudio")

        # Controls the current interface language
        self.language = "LANGUAGE_ENGLISH"

        # Setup the Locale
        self.InitI18n()
        self.Setlang(self.language)

        # Show the application window
        self.frame = ApplicationFrame()
        self.SetTopWindow(self.frame)
        self.frame.Show(True)

        return True

    def InitI18n(self):
        self.locale = wx.Locale(getattr(wx, self.language))
        path = os.path.abspath("./gimelstudio/locale") + os.path.sep
        self.locale.AddCatalogLookupPathPrefix(path)
        self.locale.AddCatalog(self.GetAppName())

    def Setlang(self, language):
        supported_langs = {
            "LANGUAGE_ENGLISH": "en",
            "LANGUAGE_FRENCH": "fr",
            "LANGUAGE_GERMAN": "de",
        }

        # To get some language settings to display properly on Linux
        if platform.system() == "Linux":
            try:
                os.environ["LANGUAGE"] = supported_langs[language]
            except (ValueError, KeyError):
                pass


if __name__ == '__main__':
    # Create the app and startup
    app = MainApp(redirect=False)
    app.MainLoop()
