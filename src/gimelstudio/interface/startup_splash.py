# ----------------------------------------------------------------------------
# Gimel Studio Copyright 2019-2023 by the Gimel Studio project contributors
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

from gimelstudio.datafiles import GIMEL_STUDIO_SPLASH


class StartupSplashScreen(wx.adv.SplashScreen):
    def __init__(self):
        _bmp = GIMEL_STUDIO_SPLASH.GetBitmap()
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
                                     5000, None, -1, wx.DefaultPosition, wx.DefaultSize,
                                     wx.BORDER_NONE)

        self.Bind(wx.EVT_CLOSE, self.OnClose)

    def OnClose(self, event):
        # Make sure the default handler runs too
        # so this window gets destroyed.
        event.Skip()
        self.Hide()