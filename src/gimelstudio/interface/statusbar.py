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

import gimelstudio.constants as const


class StatusBar(wx.Panel, wx.StatusBar):
    def __init__(self, parent, id=wx.ID_ANY, pos=wx.DefaultPosition, size=wx.DefaultSize,
                 style=wx.NO_BORDER | wx.TAB_TRAVERSAL):
        wx.Panel.__init__(self, parent, id, pos, size, style)

        self.SetBackgroundColour(const.AREA_BG_COLOR)

        self.info_message = ""
        self.context_hints = []

        self.main_sizer = wx.GridBagSizer(vgap=0, hgap=0)

        self.SetSizer(self.main_sizer)

    def PushContextHints(self, pos, mouseicon=None, keyicon=None, text="", clear=False):
        """ Updates the statusbar with the specified icons and text. """
        if clear is True:
            self.context_hints = []

        context_hint = {}

        # If the hint already exists, we delete it
        for hint in self.context_hints:
            if pos == hint["pos"]:
                del hint["pos"]
        context_hint["pos"] = pos

        # When there is a mouse and keyboard shortcut
        # icon, we add a "+" between them for clarity.
        if mouseicon is not None and keyicon is not None:
            context_hint["separator"] = "+"
        else:
            context_hint["separator"] = None

        context_hint["mouseicon"] = mouseicon
        context_hint["keyicon"] = keyicon
        context_hint["text"] = text

        self.context_hints.append(context_hint)

    def UpdateContextHints(self):
        """ Updates the context hints to show the elements that
        make up thespecified hints. """
        self.main_sizer.Clear(delete_windows=True)

        # Context hints area
        count = 0
        last_pos = None
        for hint in self.context_hints:
            if hint["mouseicon"] is not None:
                mouse_bmp = hint["mouseicon"].GetBitmap()
            else:
                mouse_bmp = wx.Bitmap(1, 1)

            if hint["keyicon"] is not None:
                key_bmp = hint["keyicon"].GetBitmap()
            else:
                key_bmp = wx.Bitmap(1, 1)

            mouse_icon = wx.StaticBitmap(self, bitmap=mouse_bmp)
            if hint["separator"] is not None:
                separator = wx.StaticText(self, label=hint["separator"])
                separator.SetForegroundColour("#ccc")
            key_icon = wx.StaticBitmap(self, bitmap=key_bmp)
            text = wx.StaticText(self, label=hint["text"])
            text.SetForegroundColour("#ccc")

            self.main_sizer.Add(mouse_icon, (0, hint["pos"] + count),
                                flag=wx.LEFT | wx.TOP | wx.BOTTOM,
                                border=4)
            count += 1
            if hint["separator"] is not None:
                self.main_sizer.Add(separator, (0, hint["pos"] + count),
                                    flag=wx.TOP | wx.BOTTOM,
                                    border=4)
                count += 1
            self.main_sizer.Add(key_icon, (0, hint["pos"] + count),
                                flag=wx.LEFT | wx.TOP | wx.BOTTOM,
                                border=4)
            count += 1
            self.main_sizer.Add(text, (0, hint["pos"] + count),
                                flag=wx.LEFT | wx.TOP | wx.BOTTOM, border=4)
            count += 1
            last_pos = hint["pos"] + count

        # Info message area
        if last_pos is not None:
            try:
                del self.message_area_lbl
            except Exception:
                pass

            self.message_area_lbl = wx.StaticText(self, label=self.info_message)
            self.message_area_lbl.SetForegroundColour("#ccc")

            statusbar_sep = wx.StaticText(self, label="|")
            statusbar_sep.SetForegroundColour("#ccc")

            self.main_sizer.Add(statusbar_sep, (0, last_pos+1), flag=wx.ALL, border=4)

            self.main_sizer.Add(self.message_area_lbl, (0, last_pos+2),  flag=wx.ALL, border=4)

    def PushMessage(self, message):
        """ Updates the statusbar info message area with the given message. """
        self.info_message = message

    def PushStatusText(self, message, null):
        """ Override method for menu item help messages. """
        self.info_message = _("Menu: ") + message
        self.UpdateStatusBar()

    def PopStatusText(self, null):
        """ Just a blank override method. """
        pass

    def UpdateStatusBar(self):
        """ Update the statusbar. """
        self.UpdateContextHints()
        self.Layout()
        self.Refresh()
