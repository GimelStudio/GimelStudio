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
import glob

import wx
from wx.lib import buttons
import wx.lib.agw.cubecolourdialog as CCD

from gswidgetkit import (NumberField, EVT_NUMBERFIELD, 
                         Button, EVT_BUTTON, TextCtrl)

from gimelstudio.datafiles import ICON_ARROW_DOWN, ICON_ARROW_RIGHT



# Enum-like constants for widgets
SLIDER_WIDGET = "slider"
SPINBOX_WIDGET = "spinbox"


class Property(object):
    def __init__(self, idname, default, label, visible=True):
        self.idname = idname
        self.value = default
        self.label = label
        self.visible = visible
        self.widget_eventhook = None

    def _RunErrorCheck(self):
        pass

    @property
    def IdName(self):  # name
        return self.idname

    def GetIdname(self):
        return self.idname

    def GetValue(self):
        return self.value

    def SetValue(self, value, render=True):
        """ Set the value of the node property.

        NOTE: This is only to be used to AFTER the node init.
        Use ``self.EditProperty`` for other cases, instead.
        """
        self.value = value
        self._RunErrorCheck()
        self.WidgetEventHook(self.idname, self.value, render)

    def GetLabel(self):
        return self.label

    def SetLabel(self, label):
        self.label = label

    def GetIsVisible(self):
        return self.visible

    def SetIsVisible(self, is_visible):
        self.visible = is_visible

    def SetWidgetEventHook(self, event_hook):
        self.widget_eventhook = event_hook

    def WidgetEventHook(self, idname, value, render):
        self.widget_eventhook(idname, value, render)


class PositiveIntegerProp(Property):
    """ Allows the user to select a positive integer. """

    def __init__(self, idname, default=0, min_val=0,
                 max_val=10, widget="slider", label="", visible=True):
        Property.__init__(self, idname, default, label, visible)
        self.min_value = min_val
        self.max_value = max_val
        self.widget = widget

        self._RunErrorCheck()

    def _RunErrorCheck(self):
        if self.value > self.max_value:
            raise TypeError(
                "PositiveIntegerField value must be set to an integer less than 'max_val'"
            )
        if self.value < self.min_value:
            raise TypeError(
                "PositiveIntegerField value must be set to an integer greater than 'min_val'"
            )

    def GetMinValue(self):
        return self.min_value

    def GetMaxValue(self):
        return self.max_value

    def CreateUI(self, parent, sizer):

        fold_panel = sizer.AddFoldPanel(self.GetLabel())

        if self.widget == "slider":
            self.slider = wx.Slider(
                fold_panel,
                id=wx.ID_ANY,
                value=self.GetValue(),
                minValue=self.GetMinValue(),
                maxValue=self.GetMaxValue(),
                style=wx.SL_HORIZONTAL | wx.SL_AUTOTICKS | wx.SL_LABELS
            )
            self.slider.SetForegroundColour("#fff")
            self.slider.SetTickFreq(10)

            sizer.AddFoldPanelWindow(fold_panel, self.slider)

            #sizer.Add(self.slider, flag=wx.EXPAND | wx.ALL, border=5)
            self.slider.Bind(
                wx.EVT_SCROLL,
                self.WidgetEvent
            )

        # elif self.widget == "number":
        #     self.number = NumberField(parent, default_value=self.GetValue(), label=self.GetLabel(),
        #     min_value=self.GetMinValue(), max_value=self.GetMaxValue(), suffix="px", show_p=False)
        #     sizer.Add(self.number, flag=wx.EXPAND | wx.LEFT | wx.RIGHT)

        #     self.number.Bind(EVT_NUMBERFIELD, self.WidgetEvent)

        elif self.widget == "spinbox":
            self.spinbox = wx.SpinCtrl(
                parent,
                id=wx.NewIdRef(),
                min=self.GetMinValue(),
                max=self.GetMaxValue(),
                initial=self.GetValue()
            )
            sizer.Add(self.spinbox, flag=wx.ALL | wx.EXPAND, border=5)
            self.spinbox.Bind(
                wx.EVT_SPINCTRL,
                self.WidgetEvent
            )
            self.spinbox.Bind(
                wx.EVT_TEXT,
                self.WidgetEvent
            )

        else:
            raise TypeError(
                "PositiveIntegerField 'widget' param must be either: 'spinbox' or 'slider'!"
            )

    def WidgetEvent(self, event):
        if self.widget == "slider":
            self.SetValue(self.slider.GetValue())
        elif self.widget == "spinbox":
            self.SetValue(self.spinbox.GetValue())
        # elif self.widget == "number":
        #     self.SetValue(event.value)


class ChoiceProp(Property):
    """ Allows the user to select from a list of choices. """

    def __init__(self, idname, default="", choices=[], label="", visible=True):
        Property.__init__(self, idname, default, label, visible)
        self.choices = choices

        self._RunErrorCheck()

    def GetChoices(self):
        return self.choices

    def SetChoices(self, choices=[]):
        self.choices = choices

    def CreateUI(self, parent, sizer):
        # label = wx.StaticText(parent, label=self.GetLabel())
        # label.SetForegroundColour("#fff")
        # sizer.Add(label, flag=wx.LEFT | wx.TOP, border=5)

        fold_panel = sizer.AddFoldPanel(self.GetLabel())

        self.combobox = wx.ComboBox(
            fold_panel,
            id=wx.ID_ANY,
            value=self.GetValue(),
            choices=self.GetChoices(),
            style=wx.CB_READONLY
        )
        sizer.AddFoldPanelWindow(fold_panel, self.combobox)
        #sizer.Add(self.combobox, flag=wx.EXPAND | wx.ALL, border=5)
        self.combobox.Bind(
            wx.EVT_COMBOBOX,
            self.WidgetEvent
        )

    def WidgetEvent(self, event):
        value = event.GetString()
        if not value:
            print("Value is null!")
        self.SetValue(value)



class OpenFileChooserProp(Property):
    """ Allows the user to select a file to open.

    (e.g: use this to open an .PNG, .JPG, .JPEG image, etc.)
    """

    def __init__(self, idname, default="", dlg_msg="Choose file...",
                 wildcard="All files (*.*)|*.*", btn_lbl="Choose...",
                 label="", visible=True):
        Property.__init__(self, idname, default, label, visible)
        self.dlg_msg = dlg_msg
        self.wildcard = wildcard
        self.btn_lbl = btn_lbl

        self._RunErrorCheck()

    def _RunErrorCheck(self):
        if type(self.value) != str:
            raise TypeError("OpenFileChooserField value must be a string!")

    def GetDlgMessage(self):
        return self.dlg_msg

    def GetWildcard(self):
        return self.wildcard

    def GetBtnLabel(self):
        return self.btn_lbl

    def CreateUI(self, parent, sizer):

        images = wx.ImageList(24, 24)
        images.Add(ICON_ARROW_DOWN.GetBitmap())
        images.Add(ICON_ARROW_RIGHT.GetBitmap())

        fold_panel = sizer.AddFoldPanel(self.GetLabel(), foldIcons=images)

        pnl = wx.Panel(fold_panel)
        pnl.SetBackgroundColour(wx.Colour("#464646"))

        vbox = wx.BoxSizer(wx.VERTICAL)
        hbox = wx.BoxSizer(wx.HORIZONTAL)

        self.textcontrol = TextCtrl(pnl, 
                            value=self.GetValue(), style=wx.BORDER_SIMPLE,
                            placeholder="", size=(-1, 32))
        hbox.Add(self.textcontrol, proportion=1, flag=wx.EXPAND | wx.BOTH)

        self.button = Button(pnl, label=self.GetBtnLabel(), size=(-1, 32))
        hbox.Add(self.button, flag=wx.LEFT, border=5)
        self.button.Bind(
            EVT_BUTTON,
            self.WidgetEvent
        )

        vbox.Add(hbox, flag=wx.EXPAND | wx.BOTH | wx.ALL, border=6)

        vbox.Fit(pnl)
        pnl.SetSizer(vbox)

        # From https://discuss.wxpython.org/t/how-do-you-get-the-
        # captionbar-from-a-foldpanelbar/24795
        fold_panel._captionBar.SetSize(fold_panel._captionBar.DoGetBestSize())
        
        sizer.AddFoldPanelWindow(fold_panel, pnl,  spacing=10)

    def WidgetEvent(self, event):
        dlg = wx.FileDialog(
            None,
            message=self.GetDlgMessage(),
            defaultDir=os.getcwd(),
            defaultFile="",
            wildcard=self.GetWildcard(),
            style=wx.FD_OPEN | wx.FD_CHANGE_DIR | wx.FD_FILE_MUST_EXIST | wx.FD_PREVIEW
        )

        if dlg.ShowModal() == wx.ID_OK:
            paths = dlg.GetPaths()
            self.SetValue(paths[0])
            self.textcontrol.ChangeValue(self.GetValue())


class LabelProp(Property):
    """ Allows setting and resetting text on a label. """

    def __init__(self, idname, default="", label="", visible=True):
        Property.__init__(self, idname, default, label, visible)

        self._RunErrorCheck()

    def CreateUI(self, parent, sizer):
        label = wx.StaticText(parent, label=self.GetLabel())
        label.SetForegroundColour("#fff")
        sizer.Add(label, flag=wx.LEFT | wx.TOP, border=5)

        static_label = wx.StaticText(parent, label=self.GetValue())
        static_label.SetForegroundColour("#fff")
        sizer.Add(static_label, flag=wx.LEFT | wx.TOP, border=5)


class StringProp(Property):
    def __init__(self, idname, default="Text", dlg_msg="Edit text:",
                 dlg_title="Edit Text", label="", visible=True):
        Property.__init__(self, idname, default, label, visible)
        self.dlg_msg = dlg_msg
        self.dlg_title = dlg_title

        self._RunErrorCheck()

    def GetDlgMessage(self):
        return self.dlg_msg

    def GetDlgTitle(self):
        return self.dlg_title

    def CreateUI(self, parent, sizer):
        label = wx.StaticText(parent, label=self.GetLabel())
        label.SetForegroundColour("#fff")
        sizer.Add(label, flag=wx.LEFT | wx.TOP, border=5)

        vbox = wx.BoxSizer(wx.VERTICAL)
        hbox = wx.BoxSizer(wx.HORIZONTAL)

        self.textcontrol = wx.TextCtrl(
            parent,
            id=wx.ID_ANY,
            value=self.GetValue(),
            style=wx.TE_READONLY
        )
        hbox.Add(self.textcontrol, proportion=1)

        self.button = wx.Button(
            parent,
            id=wx.ID_ANY,
            label="Edit"
        )
        hbox.Add(self.button, flag=wx.LEFT, border=5)
        self.button.Bind(
            wx.EVT_BUTTON,
            self.WidgetEvent
        )

        vbox.Add(hbox, flag=wx.EXPAND)
        sizer.Add(vbox, flag=wx.ALL | wx.EXPAND, border=5)

    def WidgetEvent(self, event):
        dlg = wx.TextEntryDialog(None, self.GetDlgMessage(),
                                 self.GetDlgTitle(), self.GetValue())

        if dlg.ShowModal() == wx.ID_OK:
            value = dlg.GetValue()
            self.SetValue(value)
            self.textcontrol.ChangeValue(self.GetValue())
