# ----------------------------------------------------------------------------
# Gimel Studio Copyright 2019-2022 by Noah Rahm and contributors
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
import wx
from wx import stc
import gswidgetkit.foldpanelbar as fpbar
from gswidgetkit import (NumberField, EVT_NUMBERFIELD,
                         Button, EVT_BUTTON, TextCtrl,
                         Label, DropDown, EVT_DROPDOWN)

from gimelstudio.constants import (AREA_BG_COLOR, PROP_BG_COLOR, 
                                   SUPPORTED_FT_OPEN_LIST)
from gimelstudio.datafiles import ICON_ARROW_DOWN, ICON_ARROW_RIGHT


class Property(object):
    """
    The base node Property class.
    """
    def __init__(self, idname, default, fpb_label, expanded=True, visible=True):
        self.idname = idname
        self.value = default
        self.fpb_label = fpb_label
        self.visible = visible
        self.expanded = expanded
        self.widget_eventhook = None

    def _RunErrorCheck(self):
        """ 
        Add optional error checking to your Property by overriding this method. 
        """
        pass

    @property
    def IdName(self):
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
        return self.fpb_label

    def SetLabel(self, label):
        self.fpb_label = label

    def GetIsVisible(self):
        return self.visible

    def SetIsVisible(self, is_visible):
        self.visible = is_visible

    def SetWidgetEventHook(self, event_hook):
        self.widget_eventhook = event_hook

    def WidgetEventHook(self, idname, value, render):
        self.widget_eventhook(idname, value, render)

    def CreateFoldPanel(self, panel_bar, fpb_label=None):
        images = wx.ImageList(24, 24)
        images.Add(ICON_ARROW_DOWN.GetBitmap())
        images.Add(ICON_ARROW_RIGHT.GetBitmap())

        if fpb_label is None:
            lbl = self.GetLabel()
        else:
            lbl = fpb_label

        self.fpb = panel_bar.AddFoldPanel(lbl, foldIcons=images)
        self.fpb.SetBackgroundColour(wx.Colour(PROP_BG_COLOR))
        self.fpb.Bind(fpbar.EVT_CAPTIONBAR, self.OnToggleFoldPanelExpand)

        if self.expanded == True:
            self.fpb.Expand()
        else:
            self.fpb.Collapse()
        
        return self.fpb

    def AddToFoldPanel(self, panel_bar, fold_panel, item, spacing=15):
        # From https://discuss.wxpython.org/t/how-do-you-get-the-
        # captionbar-from-a-foldpanelbar/24795
        fold_panel._captionBar.SetSize(fold_panel._captionBar.DoGetBestSize())
        panel_bar.AddFoldPanelWindow(fold_panel, item, spacing=spacing)

        # Add this here just for 12px of spacing at the bottom
        item = wx.StaticText(fold_panel, size=(-1, 14))
        panel_bar.AddFoldPanelWindow(fold_panel, item, spacing=0)

    def OnToggleFoldPanelExpand(self, event):
        # Because the event gives us the last state, we flip the values 
        # to be the opposite of what it gives us.
        if event.GetFoldStatus():
            self.expanded = False
        else:
            self.expanded = True
        event.Skip()


class ThumbProp(Property):
    """ 
    Shows the current thumbnail image (used internally). 
    """
    def __init__(self, idname, default=None, fpb_label="", thumb_img=None, 
                 expanded=False, visible=True):
        Property.__init__(self, idname, default, fpb_label, expanded, visible)
        self.thumb_img = thumb_img

    def GetThumbImage(self):
        return self.thumb_img

    def CreateUI(self, parent, sizer):
        fold_panel = self.CreateFoldPanel(sizer)

        self.img = wx.StaticBitmap(fold_panel, bitmap=self.GetThumbImage(), size=(200, 200))

        self.AddToFoldPanel(sizer, fold_panel, self.img)


class PositiveIntegerProp(Property):
    """ 
    Allows the user to select a positive integer via a Number Field. 
    """
    def __init__(self, idname, default=0, lbl_suffix="", min_val=0, max_val=10, 
                 show_p=False, fpb_label="", expanded=True, visible=True):
        Property.__init__(self, idname, default, fpb_label, expanded, visible)
        self.min_value = min_val
        self.max_value = max_val
        self.lbl_suffix = lbl_suffix
        self.show_p = show_p

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

    def GetP(self):
        return self.show_p

    def CreateUI(self, parent, sizer):
        fold_panel = self.CreateFoldPanel(sizer)

        self.numberfield = NumberField(fold_panel,
                                       default_value=self.GetValue(),
                                       label=self.GetLabel(),
                                       min_value=self.GetMinValue(),
                                       max_value=self.GetMaxValue(),
                                       suffix=self.lbl_suffix, show_p=self.GetP(),
                                       size=(-1, 32))

        self.AddToFoldPanel(sizer, fold_panel, self.numberfield)

        self.numberfield.Bind(EVT_NUMBERFIELD, self.WidgetEvent)

    def WidgetEvent(self, event):
        self.SetValue(event.value)


class ChoiceProp(Property):
    """ 
    Allows the user to select from a list of choices via a Drop-down widget. 
    """
    def __init__(self, idname, default="", choices=[], fpb_label="", 
                 expanded=True, visible=True):
        Property.__init__(self, idname, default, fpb_label, expanded, visible)
        self.choices = choices

    def GetChoices(self):
        return self.choices

    def SetChoices(self, choices=[]):
        self.choices = choices

    def CreateUI(self, parent, sizer):
        fold_panel = self.CreateFoldPanel(sizer)

        self.dropdown = DropDown(fold_panel, default=self.GetValue(),
                                 items=self.GetChoices(), size=(-1, 32))

        self.AddToFoldPanel(sizer, fold_panel, self.dropdown)
        self.dropdown.Bind(EVT_DROPDOWN, self.WidgetEvent)

    def WidgetEvent(self, event):
        value = event.value
        if not value:
            print("Value is null!")
        self.SetValue(value)


class OpenFileChooserProp(Property):
    """ Allows the user to select a file to open.

    (e.g: use this to open an .PNG, .JPG, .JPEG image, etc.)
    """
    def __init__(self, idname, default="", dlg_msg="Choose file...",
                 wildcard="All files (*.*)|*.*", btn_lbl="Choose...",
                 fpb_label="", expanded=True, visible=True):
        Property.__init__(self, idname, default, fpb_label, expanded, visible)
        self.dlg_msg = dlg_msg
        self.wildcard = wildcard
        self.btn_lbl = btn_lbl

        self._RunErrorCheck()

    def _RunErrorCheck(self):
        if type(self.value) != str:
            raise TypeError("Value must be a string!")

    def GetDlgMessage(self):
        return self.dlg_msg

    def GetWildcard(self):
        return self.wildcard

    def GetBtnLabel(self):
        return self.btn_lbl

    def CreateUI(self, parent, sizer):
        fold_panel = self.CreateFoldPanel(sizer)

        pnl = wx.Panel(fold_panel)
        pnl.SetBackgroundColour(wx.Colour(PROP_BG_COLOR))

        vbox = wx.BoxSizer(wx.VERTICAL)
        hbox = wx.BoxSizer(wx.HORIZONTAL)

        self.textcontrol = TextCtrl(pnl, default=self.GetValue(), size=(-1, 32))
        hbox.Add(self.textcontrol, proportion=1, flag=wx.EXPAND | wx.BOTH)

        self.button = Button(pnl, label=self.GetBtnLabel(), size=(-1, 32))
        hbox.Add(self.button, flag=wx.LEFT, border=5)
        self.button.Bind(EVT_BUTTON, self.WidgetEvent)

        vbox.Add(hbox, flag=wx.EXPAND | wx.BOTH)

        vbox.Fit(pnl)
        pnl.SetSizer(vbox)

        self.AddToFoldPanel(sizer, fold_panel, pnl)

    def WidgetEvent(self, event):
        style = wx.FD_OPEN | wx.FD_CHANGE_DIR | wx.FD_FILE_MUST_EXIST | wx.FD_PREVIEW
        dlg = wx.FileDialog(None, message=self.GetDlgMessage(), defaultDir=os.getcwd(),
                            defaultFile="", wildcard=self.GetWildcard(), style=style)

        if dlg.ShowModal() == wx.ID_OK:
            paths = dlg.GetPaths()
            filetype = os.path.splitext(paths[0])[1].lower()

            if filetype not in SUPPORTED_FT_OPEN_LIST:
                dlg = wx.MessageDialog(None, _("That file type isn't currently supported!"),
                                       _("Cannot Open Image!"), style=wx.ICON_EXCLAMATION)
                dlg.ShowModal()

            else:
                self.SetValue(paths[0])
                self.textcontrol.SetValue(self.GetValue())


class XYZProp(Property):
    """ 
    Allows the user to select an (x, y, z) value via Number Fields.
    """
    def __init__(self, idname, default=(0, 0, 0), labels=("X", "Y", "Z"),
                 min_vals=(0, 0, 0), max_vals=(10, 10, 10), lbl_suffix="", show_p=False, 
                 enable_z=False, fpb_label="", expanded=True, visible=True):
        Property.__init__(self, idname, default, fpb_label, expanded, visible)
        self.min_values = min_vals
        self.max_values = max_vals
        self.lbl_suffix = lbl_suffix
        self.labels = labels
        self.show_p = show_p
        self.enable_z = enable_z

    def CreateUI(self, parent, sizer):
        fold_panel = self.CreateFoldPanel(sizer)

        pnl = wx.Panel(fold_panel)
        pnl.SetBackgroundColour(wx.Colour(PROP_BG_COLOR))

        vbox = wx.BoxSizer(wx.VERTICAL)

        self.numberfield_x = NumberField(pnl,
                                         default_value=self.value[0],
                                         label=self.labels[0],
                                         min_value=self.min_values[0],
                                         max_value=self.max_values[0],
                                         suffix=self.lbl_suffix, 
                                         show_p=self.show_p,
                                         size=(-1, 32))
        vbox.Add(self.numberfield_x, flag=wx.EXPAND | wx.BOTH | wx.ALL, border=1)

        self.numberfield_y = NumberField(pnl,
                                         default_value=self.value[1],
                                         label=self.labels[1],
                                         min_value=self.min_values[1],
                                         max_value=self.max_values[1],
                                         suffix=self.lbl_suffix, 
                                         show_p=self.show_p,
                                         size=(-1, 32))
        vbox.Add(self.numberfield_y, flag=wx.EXPAND | wx.BOTH | wx.ALL, border=1)

        if self.enable_z:
            self.numberfield_z = NumberField(pnl,
                                             default_value=self.value[2],
                                             label=self.labels[2],
                                             min_value=self.min_values[2],
                                             max_value=self.max_values[2],
                                             suffix=self.lbl_suffix, 
                                             show_p=self.show_p,
                                             size=(-1, 32))
            vbox.Add(self.numberfield_z, flag=wx.EXPAND | wx.BOTH | wx.ALL, border=1)

        vbox.Fit(pnl)
        pnl.SetSizer(vbox)

        self.AddToFoldPanel(sizer, fold_panel, pnl)

        self.numberfield_x.Bind(EVT_NUMBERFIELD, self.WidgetEventX)
        self.numberfield_y.Bind(EVT_NUMBERFIELD, self.WidgetEventY)
        if self.enable_z:
            self.numberfield_z.Bind(EVT_NUMBERFIELD, self.WidgetEventZ)

    def WidgetEventX(self, event):
        self.SetValue((event.value, self.value[1], self.value[2]))

    def WidgetEventY(self, event):
        self.SetValue((self.value[0], event.value, self.value[2]))

    def WidgetEventZ(self, event):
        self.SetValue((self.value[0], self.value[1], event.value))


class ActionProp(Property):
    """
    Allows the user to click a button to perform an action
    """
    def __init__(self, idname, default="", fpb_label="", btn_label="", flat=False, 
                 action=None, expanded=True, visible=True):
        Property.__init__(self, idname, default, btn_label, expanded, visible)
        self.btn_label = btn_label
        if fpb_label != "":
            self.fpb_label = fpb_label
        else:
            self.fpb_label = btn_label
        self.flat = flat
        self.action = action

    def CreateUI(self, parent, sizer):
        fold_panel = self.CreateFoldPanel(sizer, self.fpb_label)

        self.button = Button(fold_panel, label=_(self.btn_label), flat=self.flat, size=(-1, 30))
        self.AddToFoldPanel(sizer, fold_panel, self.button)
        self.button.Bind(EVT_BUTTON, self.action)


class LabelProp(Property):
    """
    Shows some text.
    """
    def __init__(self, idname, default="", fpb_label="", expanded=True, visible=True):
        Property.__init__(self, idname, default, fpb_label, expanded, visible)
        self.fpb_label = fpb_label

    def CreateUI(self, parent, sizer):
        fold_panel = self.CreateFoldPanel(sizer, self.fpb_label)
 
        pnl = wx.Panel(fold_panel)
        pnl.SetBackgroundColour(wx.Colour(AREA_BG_COLOR))

        vbox = wx.BoxSizer(wx.VERTICAL)

        value_label = Label(pnl, label=_(self.GetValue()), bg_color=AREA_BG_COLOR)
        vbox.Add(value_label, flag=wx.EXPAND | wx.BOTH | wx.ALL, border=10)

        vbox.Fit(pnl)
        pnl.SetSizer(vbox)

        self.AddToFoldPanel(sizer, fold_panel, pnl)


class TextProp(Property):
    """ 
    Allows the user to type text. 
    """
    def __init__(self, idname, default="", fpb_label="", expanded=True, visible=True):
        Property.__init__(self, idname, default, fpb_label, expanded, visible)

    def CreateUI(self, parent, sizer):
        fold_panel = self.CreateFoldPanel(sizer)

        self.textcontrol = TextCtrl(fold_panel, default=self.GetValue(), size=(-1, 32))

        self.AddToFoldPanel(sizer, fold_panel, self.textcontrol)
        self.textcontrol.textctrl.Bind(stc.EVT_STC_MODIFIED, self.WidgetEvent)

    def WidgetEvent(self, event):
        self.SetValue(self.textcontrol.textctrl.GetValue())
