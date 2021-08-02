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
import threading

import wx
import wx.stc as stc

from gimelstudio import constants
from gswidgetkit import (Button, EVT_BUTTON, NumberField, EVT_NUMBERFIELD,
                         TextCtrl, DropDown, EVT_DROPDOWN)


class ExportOptionsDialog(wx.Dialog):
    def __init__(self, parent, window):
        wx.Dialog.__init__(self, window)
        self.parent = parent
        self.title = _("Image Export Options")
        self.filetype = self.parent.Filetype
        self.filepath = self.parent.Filepath

        self.jpeg_quality = 90
        self.png_compression = 6
        self.pixel_datatype = "uint8"
        self.comment_meta = ""

        self.SetSize((400, 300))
        self.SetTitle("{} {}".format(self.filetype.upper(), self.title))
        self.SetBackgroundColour(wx.Colour("#464646"))
        self.Center()

        # Different settings for different filetypes
        if self.filetype.lower() == ".png":
            self.InitPngUI()
        elif self.filetype.lower() in [".jpg", ".jpeg"]:
            self.InitJpegUI()
        else:
            self.BypassUI()

    @property
    def Image(self):
        return self.parent.Image

    def BypassUI(self):
        """ Bypass the dialog. """
        self.OnExport(None)

    def InitPngUI(self):
        pnl = wx.Panel(self)
        pnl.SetBackgroundColour(wx.Colour("#464646"))

        vbox = wx.BoxSizer(wx.VERTICAL)
        inner_sizer = wx.BoxSizer(wx.VERTICAL)

        # Compression level
        self.png_compression_field = NumberField(pnl, default_value=self.png_compression,
                                                label=_("Compression Level"),
                                                min_value=0, max_value=9,
                                                suffix="")
        inner_sizer.Add(self.png_compression_field, flag=wx.EXPAND | wx.ALL, border=6)

        # Spacing
        inner_sizer.Add((0, 0), flag=wx.EXPAND | wx.ALL, border=6)

        # Pixel datatype
        px_datatype_lbl = wx.StaticText(pnl, label=_("Export pixel datatype:"))
        px_datatype_lbl.SetForegroundColour("#fff")

        self.px_datatype_dropdown = DropDown(pnl, items=["uint8", "uint16", "float"],
                                             default=self.pixel_datatype)

        hbox1 = wx.BoxSizer(wx.HORIZONTAL)
        hbox1.Add(px_datatype_lbl, flag=wx.EXPAND | wx.LEFT | wx.TOP | wx.RIGHT, border=6)
        hbox1.Add(self.px_datatype_dropdown, flag=wx.EXPAND | wx.LEFT | wx.RIGHT, border=6)
        inner_sizer.Add(hbox1)

        # Spacing
        inner_sizer.Add((0, 0), flag=wx.EXPAND | wx.ALL, border=6)

        pnl.SetSizer(inner_sizer)

        # Dialog buttons
        buttons_sizer = wx.BoxSizer(wx.HORIZONTAL)
        export_btn = Button(self, label=_("Export"))
        cancel_btn = Button(self, label=_("Cancel"))
        buttons_sizer.Add(export_btn)
        buttons_sizer.Add(cancel_btn, flag=wx.LEFT, border=5)

        vbox.Add(pnl, proportion=1, flag=wx.ALL|wx.EXPAND, border=5)
        vbox.Add(buttons_sizer, flag=wx.ALIGN_RIGHT|wx.TOP|wx.BOTTOM|wx.RIGHT, border=10)

        self.SetSizer(vbox)

        export_btn.Bind(EVT_BUTTON, self.OnExport)
        cancel_btn.Bind(EVT_BUTTON, self.OnCancel)
        self.png_compression_field.Bind(EVT_NUMBERFIELD, self.OnPngCompressionChange)
        self.px_datatype_dropdown.Bind(EVT_DROPDOWN, self.OnPixelDatatypeChange)

    def InitJpegUI(self):
        pnl = wx.Panel(self)
        pnl.SetBackgroundColour(wx.Colour("#464646"))

        vbox = wx.BoxSizer(wx.VERTICAL)
        inner_sizer = wx.BoxSizer(wx.VERTICAL)

        # Image Quality
        self.img_quality_field = NumberField(pnl, default_value=self.jpeg_quality,
                                             label=_("Image Quality"),
                                             min_value=0, max_value=100,
                                             suffix="%")
        inner_sizer.Add(self.img_quality_field, flag=wx.EXPAND | wx.ALL, border=6)

        # Spacing
        inner_sizer.Add((0, 0), flag=wx.EXPAND | wx.ALL, border=6)

        # Pixel datatype
        px_datatype_lbl = wx.StaticText(pnl, label=_("Export pixel datatype:"))
        px_datatype_lbl.SetForegroundColour("#fff")

        self.px_datatype_dropdown = DropDown(pnl, items=["uint8", "uint16", "float"],
                                             default=self.pixel_datatype)

        hbox1 = wx.BoxSizer(wx.HORIZONTAL)
        hbox1.Add(px_datatype_lbl, flag=wx.EXPAND | wx.LEFT | wx.TOP | wx.RIGHT, border=6)
        hbox1.Add(self.px_datatype_dropdown, flag=wx.EXPAND | wx.LEFT | wx.RIGHT, border=6)
        inner_sizer.Add(hbox1)

        # Spacing
        inner_sizer.Add((0, 0), flag=wx.EXPAND | wx.ALL, border=6)

        # Comment metadata
        comment_meta_lbl = wx.StaticText(pnl, label=_("Comment metadata:"))
        comment_meta_lbl.SetForegroundColour("#fff")
        comment_meta_lbl.SetFont(comment_meta_lbl.GetFont().Bold())
        inner_sizer.Add(comment_meta_lbl, flag=wx.EXPAND | wx.TOP | wx.LEFT | wx.RIGHT, border=6)

        self.comment_meta_txtctrl = TextCtrl(pnl, value=self.comment_meta,
                                             style=wx.BORDER_SIMPLE, placeholder="",
                                             size=(-1, 50))
        inner_sizer.Add(self.comment_meta_txtctrl, flag=wx.EXPAND | wx.ALL, border=6)

        pnl.SetSizer(inner_sizer)

        # Dialog buttons
        buttons_sizer = wx.BoxSizer(wx.HORIZONTAL)
        export_btn = Button(self, label=_("Export"))
        cancel_btn = Button(self, label=_("Cancel"))
        buttons_sizer.Add(export_btn)
        buttons_sizer.Add(cancel_btn, flag=wx.LEFT, border=5)

        vbox.Add(pnl, proportion=1, flag=wx.ALL|wx.EXPAND, border=5)
        vbox.Add(buttons_sizer, flag=wx.ALIGN_RIGHT|wx.TOP|wx.BOTTOM|wx.RIGHT, border=10)

        self.SetSizer(vbox)

        export_btn.Bind(EVT_BUTTON, self.OnExport)
        cancel_btn.Bind(EVT_BUTTON, self.OnCancel)
        self.img_quality_field.Bind(EVT_NUMBERFIELD, self.OnJPEGQualityChange)
        self.px_datatype_dropdown.Bind(EVT_DROPDOWN, self.OnPixelDatatypeChange)
        self.comment_meta_txtctrl.Bind(stc.EVT_STC_MODIFIED, self.OnCommentMetaChange)

    def OnExport(self, event):
        self.ExportImage()

    def ExportImage(self):
        # Export the image with the export options
        img = self.Image
        if self.filetype in [".jpg", ".jpeg"]:
            img.specmod().attribute("quality", self.jpeg_quality)
            img.specmod().attribute("ImageDescription", self.comment_meta)

        elif self.filetype in [".png"]:
            img.specmod().attribute("png:compressionLevel", self.png_compression)

        img.specmod().attribute("Software", "Gimel Studio")

        img.write(self.filepath, self.pixel_datatype)

        if img.has_error:
            print("Error writing image: ", img.geterror())

        # Destroy the dialog
        self.Destroy()

    def OnCancel(self, event):
        self.Destroy()

    def OnJPEGQualityChange(self, event):
        self.jpeg_quality = event.value

    def OnPixelDatatypeChange(self, event):
        self.pixel_datatype = event.value

    def OnCommentMetaChange(self, event):
        self.comment_meta = self.comment_meta_txtctrl.GetText()

    def OnPngCompressionChange(self, event):
        self.png_compression = event.value


class ExportImageHandler(object):
    def __init__(self, parent, image):
        self.parent = parent
        self.image = image
        self.filepath = ""
        self.filetype = ""

    @property
    def Image(self):
        return self.image

    @property
    def Filepath(self):
        return self.filepath

    @property
    def Filetype(self):
        return self.filetype

    def RunExport(self):
        self.SelectFilePathDialog()
        if self.filepath != "":
            self.ExportOptionsDialog()

    def SelectFilePathDialog(self):
        wildcard = constants.SUPPORTED_FT_SAVE_WILDCARD

        dlg = wx.FileDialog(
            self.parent,
            message=_("Export image as..."),
            defaultDir=os.getcwd(),
            defaultFile="untitled.png",
            wildcard=wildcard,
            style=wx.FD_SAVE | wx.FD_OVERWRITE_PROMPT
        )

        # This sets the default filter that the user will initially see.
        # Otherwise, the first filter in the list will be used by default.
        dlg.SetFilterIndex(11)

        if dlg.ShowModal() == wx.ID_OK:
            self.filepath = dlg.GetPath()
            self.filetype = os.path.splitext(self.filepath)[1]

            if self.filetype not in constants.SUPPORTED_FT_SAVE_LIST:
                dlg = wx.MessageDialog(
                    None,
                    _("That file type isn't currently supported!"),
                    _("Cannot Save Image!"),
                    style=wx.ICON_EXCLAMATION
                )
                dlg.ShowModal()

        dlg.Destroy()

    def ExportOptionsDialog(self):
        dlg = ExportOptionsDialog(self, self.parent)
        dlg.ShowModal()
