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

import webbrowser
import wx

from gswidgetkit import Label, Button, EVT_BUTTON

import gimelstudio.constants as const 
from gimelstudio.datafiles import ICON_GIMELSTUDIO_ICO, ICON_LICENSE
from gimelstudio.datafiles.icons import (ICON_CREDITS, ICON_GITHUB, 
                                         ICON_WEBSITE, ICON_YOUTUBE)
 

class AboutDialog(wx.Frame):
    def __init__(self, parent):
        wx.Frame.__init__(self, None, -1, style=wx.FRAME_SHAPED | wx.BORDER_SIMPLE)
    
        self.SetBackgroundColour(const.DARK_COLOR)

        self.parent = parent

        self.BuildUI()
        self.Center()

        self.Bind(wx.EVT_KILL_FOCUS, self.OnCloseDialog)

    def BuildUI(self):
        panel = wx.Panel(self)
        panel.SetBackgroundColour(const.DARK_COLOR)

        info_panel = wx.Panel(panel)
        info_panel.SetBackgroundColour(const.DARK_COLOR)

        info_sizer = wx.BoxSizer(wx.VERTICAL)

        app_name_lbl = Label(info_panel, label=const.APP_NAME, font_bold=True)
        app_name_lbl.SetFont(app_name_lbl.GetFont().Scale(2))
        info_sizer.Add(app_name_lbl, 0, flag=wx.LEFT|wx.EXPAND, border=8)

        app_version_lbl = Label(info_panel, label=const.APP_VERSION_FULL, font_bold=True)
        app_version_lbl.SetFont(app_version_lbl.GetFont())
        info_sizer.Add(app_version_lbl, 0, flag=wx.EXPAND|wx.LEFT, border=8)

        app_desc_lbl = Label(info_panel, label=const.APP_COPYRIGHT)
        app_desc_lbl.SetFont(app_desc_lbl.GetFont().Smaller())
        info_sizer.Add(app_desc_lbl, 0, flag=wx.LEFT|wx.TOP, border=8)

        app_c_lbl = Label(info_panel, label="All glory and praise to Yahweh, our Heavenly Father")
        app_c_lbl.SetFont(app_c_lbl.GetFont().Smaller())
        info_sizer.Add(app_c_lbl, 0, flag=wx.LEFT, border=8)

        info_panel.SetSizer(info_sizer)

        sizer = wx.GridBagSizer(1, 1)

        logo_bmp = wx.Image.ConvertToBitmap(ICON_GIMELSTUDIO_ICO.GetImage().Scale(70, 70))
        icon = wx.StaticBitmap(panel, bitmap=logo_bmp)
        sizer.Add(icon, pos=(1, 1), flag=wx.TOP|wx.LEFT|wx.ALIGN_LEFT, border=10)

        sizer.Add(info_panel, pos=(1, 2), flag=wx.TOP|wx.RIGHT|wx.LEFT|wx.BOTTOM, border=10)

        # Add buttons
        website_btn = Button(panel, label="Official website",
                             bmp=(ICON_WEBSITE.GetBitmap(), 'left'))
        sizer.Add(website_btn, pos=(3, 2), span=(1, 2), flag=wx.TOP|wx.RIGHT|wx.EXPAND, border=8)

        github_btn = Button(panel, label="Github repo",
                             bmp=(ICON_GITHUB.GetBitmap(), 'left'))
        sizer.Add(github_btn, pos=(4, 2), span=(1, 2), flag=wx.TOP|wx.RIGHT|wx.EXPAND, border=8)

        license_btn = Button(panel, label="Apache-2.0 License",
                             bmp=(ICON_LICENSE.GetBitmap(), 'left'))
        sizer.Add(license_btn, pos=(5, 2), span=(1, 2), flag=wx.TOP|wx.RIGHT|wx.EXPAND, border=8)

        credits_btn = Button(panel, label="Contributors",
                             bmp=(ICON_CREDITS.GetBitmap(), 'left'))
        sizer.Add(credits_btn, pos=(6, 2), span=(1, 2), flag=wx.TOP|wx.RIGHT|wx.EXPAND, border=8)

        youtube_btn = Button(panel, label="Youtube channel",
                             bmp=(ICON_YOUTUBE.GetBitmap(), 'left'))
        sizer.Add(youtube_btn, pos=(8, 2), span=(1, 2), flag=wx.TOP|wx.RIGHT|wx.EXPAND, border=8)

        # Add spacing
        sizer.Add((20, 20), pos=(10, 0))
        sizer.Add((10, 10), pos=(10, 5))
        sizer.Add((40, 30), pos=(10, 6))

        panel.SetSizer(sizer)
        sizer.Fit(self)
        self.SetFocus()

        # Bindings
        website_btn.Bind(EVT_BUTTON, self.OnWebsiteButton)
        github_btn.Bind(EVT_BUTTON, self.OnGithubButton)
        license_btn.Bind(EVT_BUTTON, self.OnLicenseButton)
        credits_btn.Bind(EVT_BUTTON, self.OnCreditsButton)
        youtube_btn.Bind(EVT_BUTTON, self.OnYoutubeButton)

    def OnCloseDialog(self, event):
        # Only close the dialog if the mouse is clicked outside of the window
        mouse = wx.GetMousePosition()
        pos = self.GetScreenPosition()
        size = self.GetSize()
        mouse_rect = wx.Rect(mouse[0], mouse[1], mouse[0]+1, mouse[1]+1)
        window_rect = wx.Rect(pos[0], pos[1], size[0], size[1])

        if mouse_rect.Intersects(window_rect) is True:
            self.SetFocus()
            self.Bind(wx.EVT_KILL_FOCUS, self.OnCloseDialog)
        else:
            self.Destroy()

    def OnWebsiteButton(self, event):
        webbrowser.open(const.APP_WEBSITE_URL)

    def OnGithubButton(self, event):
        webbrowser.open(const.APP_GITHUB_URL)

    def OnLicenseButton(self, event):
        webbrowser.open(const.APP_LICENSE_URL)

    def OnCreditsButton(self, event):
        webbrowser.open(const.APP_CREDITS_URL)

    def OnYoutubeButton(self, event):
        webbrowser.open(const.APP_YOUTUBE_URL)
