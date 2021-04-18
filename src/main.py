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

import wx
import wx.adv

from gimelstudio import ApplicationFrame

# Fix blurry text on Windows 10
import ctypes
try:
    ctypes.windll.shcore.SetProcessDpiAwareness(True)
except Exception:
    pass


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

        # Make sure only one instance is running
        self.name = "SingleApp-%s" % wx.GetUserId()
        self.instance = wx.SingleInstanceChecker(self.name)
        if self.instance.IsAnotherRunning():
            wx.MessageBox("Another instance of Gimel Studio is running.", "ERROR")
            return False

        # Splash screen
        #splash = StartupSplashScreen()
        #splash.CenterOnScreen(wx.BOTH)
        frame = ApplicationFrame()
        frame.Show()

        return True



if __name__ == '__main__':

    # Create the app and startup
    app = MainApp(redirect=False)
    app.MainLoop()
