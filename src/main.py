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
    ctypes.windll.shcore.SetProcessDpiAwareness(True)
except Exception:
    pass

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


class StartupSplashScreen(wx.adv.SplashScreen):
    """
    Create a splash screen widget.
    """
    def __init__(self):
        #_bmp = SPLASH_GIMEL_STUDIO.GetBitmap()
        _bmp = wx.Bitmap(name="logo.png", type=wx.BITMAP_TYPE_PNG)
        bmp = wx.Image.ConvertToBitmap(
            wx.Bitmap.ConvertToImage(_bmp).Scale(
                _bmp.GetWidth() / 2,
                _bmp.GetHeight() / 2,
                wx.IMAGE_QUALITY_HIGH
            )
        )
        wx.adv.SplashScreen.__init__(self, bmp,
                                     wx.adv.SPLASH_CENTRE_ON_SCREEN
                                     | wx.adv.SPLASH_NO_TIMEOUT,
                                     5000, None, -1)

        self.timer = wx.CallLater(100, self.ShowMainFrame)


        self.Bind(wx.EVT_CLOSE, self.OnClose)

    def OnClose(self, event):
        # Make sure the default handler runs too
        # so this window gets destroyed.
        event.Skip()
        self.Hide()

    def ShowMainFrame(self):

        if self.timer.IsRunning():
            # Stop the splash screen
            # timer and close it.
            self.Raise()

        # Create an instance of the MyFrame class.
        frame = ApplicationFrame()
        frame.Show()


class MainApp(wx.App):

    def OnInit(self):

        # Work around for Python stealing "_".
        sys.displayhook = _displayHook

        self.installDir = os.path.split(os.path.abspath(sys.argv[0]))[0]

        # Used to identify app in $HOME/
        self.SetAppName("GimelStudio")

        # Get Language from last run if set.
        # config = wx.GetApp().GetConfig()
        # language = config.Read("Language", "LANGUAGE_DEFAULT")
        self.language = "LANGUAGE_FRENCH"
        self.InitI18n()
        self.Setlang(self.language)

        # Splash screen
        #splash = StartupSplashScreen()
        #splash.CenterOnScreen(wx.BOTH)

        self.frame = ApplicationFrame()
        self.SetTopWindow(self.frame)
        self.frame.Show(True)

        return True

    def InitI18n(self):
        """ Setup locale for the app. """
        
        # Setup the Locale
        self.locale = wx.Locale(getattr(wx, self.language))
        path = os.path.abspath("./gimelstudio/locale") + os.path.sep
        self.locale.AddCatalogLookupPathPrefix(path)
        self.locale.AddCatalog(self.GetAppName())

    def Setlang(self, language):
        """ To get some language settings to display properly on Linux. """

        if language == "LANGUAGE_ENGLISH":
            if platform.system() == "Linux":
                try:
                    os.environ["LANGUAGE"] = "en"
                    
                except (ValueError, KeyError):
                    pass

        elif language == "LANGUAGE_FRENCH":
            if platform.system() == "Linux":
                try:
                    os.environ["LANGUAGE"] = "fr"
        
                except (ValueError, KeyError):
                    pass


if __name__ == '__main__':
    # Create the app and startup
    app = MainApp(redirect=False)
    app.MainLoop()
