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

import wx
import wx.stc
import wx.lib.newevent
from typing import List
from gswidgetkit import (CheckBox, DropDown, EVT_DROPDOWN,
                         NumberField, EVT_NUMBERFIELD_CHANGE,
                         NativeTextCtrl, TextCtrl, Button, EVT_BUTTON,
                         Label)

import gimelstudio.constants as const
from gimelstudio.config import AppConfiguration


class PreferencesPage(wx.Panel):
    def __init__(self, parent, category_name, app_config):
        wx.Panel.__init__(self, parent)

        self.parent = parent

        self._category_name = category_name
        self._app_config = app_config

        self.main_layout = wx.GridBagSizer(vgap=8, hgap=8)

        self.BuildUI()

    @property
    def category_name(self):
        return self._category_name

    @category_name.setter
    def category_name(self, value):
        self._category_name = value

    def BuildUI(self):
        self.SetBackgroundColour(const.PROP_BG_COLOR)
        self.LoadWidgets(self._category_name)
        self.SetSizer(self.main_layout)

    def LoadWidgets(self, category_name: str, orientation="Vertical", start_grid_num=0):
        # TODO: Add sub menus (fold panel bars)
        # TODO: Add an icon property to "_options"
        # TODO: Make the names in the ``config.json`` file more consistent (in other words, create guide to follow)
        # TODO: Should we add a switch widget (an alternative to a checkbox)?

        grid_num = start_grid_num
        new_widget = None
        for setting_name in self._app_config.Config(("Settings", category_name)):
            setting_val = self._app_config.Config(keys=("Settings", category_name, setting_name))
            if type(setting_val) == bool:
                new_widget = CheckBox(self, label=_(setting_name))
                new_widget.SetValue(setting_val)
                new_widget.Bind(wx.EVT_CHECKBOX,
                                lambda event, name=setting_name: self.OnWidgetChanged(event=event, setting_name=name))
            elif type(setting_val) == int or type(setting_val) == float:
                # TODO: Support floats separately (combined with integers for now)
                category_options = self._app_config.Config(keys=("Settings", category_name + "_options"), default=False)
                if category_options:
                    setting_options = self._app_config.Config(
                        keys=("Settings", category_name + "_options", setting_name), default=False)
                    if setting_options:
                        if setting_options["Display Widget"] == "Number Field":
                            new_widget = NumberField(self, default_value=setting_val, label=_(setting_name),
                                                     min_value=setting_options["Min Value"],
                                                     max_value=setting_options["Max Value"],
                                                     show_p=setting_options["Show Progress"],
                                                     suffix=setting_options["Suffix"])
                            new_widget.Bind(EVT_NUMBERFIELD_CHANGE,
                                            lambda event,
                                            name=setting_name: self.OnGSWidgetChanged(event=event,
                                                                                      setting_name=name))
                        else:
                            new_widget = NumberField(self, default_value=setting_val, label=_(setting_name))
                            new_widget.Bind(EVT_NUMBERFIELD_CHANGE,
                                            lambda event,
                                            name=setting_name: self.OnGSWidgetChanged(event=event,
                                                                                      setting_name=name))
                    else:
                        new_widget = NumberField(self, default_value=setting_val,
                                                 label=_(setting_name))
                        new_widget.Bind(EVT_NUMBERFIELD_CHANGE,
                                        lambda event,
                                        name=setting_name: self.OnGSWidgetChanged(event=event,
                                                                                  setting_name=name))
            elif type(setting_val == str):
                category_options = self._app_config.Config(keys=("Settings", category_name + "_options"),
                                                           default=False)
                if category_options:
                    setting_options = self._app_config.Config(
                        keys=("Settings", category_name + "_options", setting_name), default=False)
                    if setting_options:
                        if setting_options["Display Widget"] == "Drop Down":
                            new_widget = wx.BoxSizer(wx.HORIZONTAL)
                            label = Label(self, label=_(setting_name) + ":")
                            drop_down = DropDown(self, items=setting_options["Items"],
                                                 default=setting_val)
                            drop_down.Bind(EVT_DROPDOWN,
                                           lambda event,
                                           name=setting_name: self.OnGSWidgetChanged(event=event,
                                                                                     setting_name=name))
                            new_widget.Add(label, 0, wx.ALIGN_CENTRE_VERTICAL)
                            new_widget.AddSpacer(8)
                            new_widget.Add(drop_down, 1, wx.EXPAND)
                        elif setting_options["Display Widget"] == "Line Ctrl":
                            new_widget = wx.BoxSizer(wx.HORIZONTAL)
                            label = Label(self, label=_(setting_name) + ":")
                            text_ctrl = NativeTextCtrl(self, value=setting_val, style=wx.SIMPLE_BORDER)
                            text_ctrl.Bind(wx.EVT_TEXT,
                                           lambda event,
                                           name=setting_name: self.OnWidgetChanged(event=event,
                                                                                   setting_name=setting_name))
                            new_widget.Add(label, 0, wx.ALIGN_CENTRE_VERTICAL)
                            new_widget.AddSpacer(8)
                            new_widget.Add(text_ctrl, 1, wx.EXPAND)
                        elif setting_options["Display Widget"] == "Text Ctrl":
                            new_widget = wx.BoxSizer(wx.HORIZONTAL)
                            label = Label(self, label=_(setting_name) + ":")
                            text_ctrl = TextCtrl(self, default=setting_val)
                            text_ctrl.Bind(wx.stc.EVT_STC_CHANGE,
                                           lambda event,
                                           name=setting_name: self.OnWidgetChanged(event=event,
                                                                                   setting_name=name))
                            new_widget.Add(label, 0, wx.ALIGN_CENTRE_VERTICAL)
                            new_widget.AddSpacer(8)
                            new_widget.Add(text_ctrl, 1, wx.EXPAND)
                        else:
                            new_widget = wx.BoxSizer(wx.HORIZONTAL)
                            label = Label(self, label=_(setting_name) + ":")
                            text_ctrl = NativeTextCtrl(self, value=setting_val, style=wx.SIMPLE_BORDER)
                            text_ctrl.Bind(wx.EVT_TEXT,
                                           lambda event,
                                           name=setting_name: self.OnWidgetChanged(event=event,
                                                                                   setting_name=setting_name))
                            new_widget.Add(label, 0, wx.ALIGN_CENTRE_VERTICAL)
                            new_widget.AddSpacer(8)
                            new_widget.Add(text_ctrl, 1, wx.EXPAND)
                else:
                    new_widget = wx.BoxSizer(wx.HORIZONTAL)
                    label = Label(self, label=_(setting_name) + ":")
                    text_ctrl = NativeTextCtrl(self, value=setting_val, style=wx.SIMPLE_BORDER)
                    text_ctrl.Bind(wx.EVT_TEXT,
                                   lambda event,
                                   name=setting_name: self.OnWidgetChanged(event=event,
                                                                           setting_name=setting_name))
                    new_widget.Add(label, 0, wx.ALIGN_CENTRE_VERTICAL)
                    new_widget.AddSpacer(8)
                    new_widget.Add(text_ctrl, 1, wx.EXPAND)
            else:
                raise NotImplementedError("Unsupported preferences data type used in JSON config file")

            if new_widget is not None:
                self.main_layout.Add(new_widget, (grid_num, 0), flag=wx.EXPAND | wx.ALL, border=8)

            grid_num += 1

    def OnWidgetChanged(self, event, setting_name: str):
        widget = event.GetEventObject()
        self._app_config.Config(keys=("Settings", self._category_name, setting_name),
                                value=widget.GetValue())
        self._app_config.Save()

    def OnGSWidgetChanged(self, event, setting_name: str):
        # TODO: Change the widgets in GSWidgetKit to have events like the default wx widgets (so
        #  ``PreferencesPanel.OnWidgetChanged()`` can work for all widgets)
        self._app_config.Config(keys=("Settings", self._category_name, setting_name),
                                      value=event.value)
        self._app_config.Save()


class AddOnsPage(wx.Panel):
    def __init__(self, parent):
        wx.Panel.__init__(self, parent)

        self.parent = parent

        self.BuildUI()

    def BuildUI(self):
        self.SetBackgroundColour(const.PROP_BG_COLOR)

        main_layout = wx.BoxSizer(wx.VERTICAL)

        title_text = Label(self, label=_("Add-ons"))
        main_layout.Add(title_text, 1, wx.EXPAND)

        self.SetSizer(main_layout)


class TemplatesPage(wx.Panel):
    def __init__(self, parent):
        wx.Panel.__init__(self, parent)

        self.parent = parent

        self.BuildUI()

    def BuildUI(self):
        self.SetBackgroundColour(const.PROP_BG_COLOR)

        main_layout = wx.BoxSizer(wx.VERTICAL)

        title_text = Label(self, label=_("Templates"))
        main_layout.Add(title_text, 1, wx.EXPAND)

        self.SetSizer(main_layout)


class NodesPage(wx.Panel):
    def __init__(self, parent):
        wx.Panel.__init__(self, parent)

        self.parent = parent

        self.BuildUI()

    def BuildUI(self):
        self.SetBackgroundColour(const.PROP_BG_COLOR)

        main_layout = wx.BoxSizer(wx.VERTICAL)

        title_text = Label(self, label=_("Nodes"))
        main_layout.Add(title_text, 1, wx.EXPAND)

        self.SetSizer(main_layout)


class SystemPage(wx.Panel):
    def __init__(self, parent):
        wx.Panel.__init__(self, parent)

        self.parent = parent

        self.BuildUI()

    def BuildUI(self):
        self.SetBackgroundColour(const.PROP_BG_COLOR)

        main_layout = wx.BoxSizer(wx.VERTICAL)

        title_text = Label(self, label=_("System"))
        main_layout.Add(title_text, 1, wx.EXPAND)

        self.SetSizer(main_layout)


class SidebarPanel(wx.Panel):
    def __init__(self, parent, categories):
        wx.Panel.__init__(self, parent)

        self._categories = categories

        self.main_layout = wx.BoxSizer(wx.VERTICAL)
        self._buttons = []

        self.BuildUI()

    @property
    def buttons(self):
        return self._buttons

    @buttons.setter
    def buttons(self, value):
        self._buttons = value

    def BuildUI(self):
        self.SetBackgroundColour(const.PROP_BG_COLOR)

        self.main_layout.AddSpacer(16)

        # TODO: Need to create a visual gap between sections of buttons
        # (e.g. General, Interface | Add-ons, Nodes, Templates | System, File Paths)
        for category in self._categories:
            button = Button(self, label=category, flat=False, size=[128, 48])
            self.main_layout.Add(button, 0, wx.ALIGN_CENTER)
            self.main_layout.AddSpacer(8)
            self._buttons.append(button)

        self.SetSizer(self.main_layout)


class PreferencesDialog(wx.Dialog):
    def __init__(self, parent, title: str, app_config: AppConfiguration, categories: list):
        # TODO: Can we create our own title bar (instead of the default native one)?
        wx.Dialog.__init__(self, parent, title=title, size=(800, 600),
                           style=wx.DEFAULT_DIALOG_STYLE)

        self.SetBackgroundColour(const.PROP_BG_COLOR)

        self._app_config = app_config
        self._categories = categories

        # UI related stuff
        self.main_layout = wx.BoxSizer(wx.HORIZONTAL)
        self.sidebar_panel = SidebarPanel(self, self._categories)
        self.book = wx.Simplebook(self)

        self.BuildUI()

    @property
    def categories(self):
        return self._categories

    @categories.setter
    def categories(self, value):
        self._categories = value

    def BuildUI(self):
        for button in self.sidebar_panel.buttons:
            button.Bind(EVT_BUTTON,
                        lambda event,
                        index=self.sidebar_panel.buttons.index(button): self.OnCategoryButtonPressed(event, index))

        # Category pages
        for category in self._categories:
            # TODO: Finish the special pages like "Add-ons", "Nodes" and "Templates"
            category_page: List[PreferencesPage, AddOnsPage, NodesPage, TemplatesPage, SystemPage] = None
            if category == "Add-ons":
                category_page = AddOnsPage(self.book)
            elif category == "Nodes":
                category_page = NodesPage(self.book)
            elif category == "Templates":
                category_page = TemplatesPage(self.book)
            elif category == "System":
                category_page = SystemPage(self.book)
            else:
                category_page = PreferencesPage(self.book, category, self._app_config)

            if category_page is not None:
                self.book.AddPage(category_page, category)

        self.main_layout.Add(self.sidebar_panel, flag=wx.GROW | wx.ALL, border=6)
        self.main_layout.Add(self.book, 3, wx.EXPAND | wx.ALL, border=16)
        self.SetSizer(self.main_layout)

        # Highlight the "General" button by default
        self.sidebar_panel.buttons[0].SetHighlighted(True)

        self.Layout()
        self.Refresh()

    def OnCategoryButtonPressed(self, event, index):
        # TODO: The following should work (based on wxPython bindings)
        # pressed_button = event.GetEventObject()
        # pressed_button.SetHighlighted(True)
        # for button in self.buttons:
        #     if button.GetLabelText() != pressed_button.GetLabelText():
        #         button.SetHighlighted(False)

        # Temporary solution
        for button in self.sidebar_panel.buttons:
            if self.sidebar_panel.buttons.index(button) == index:
                button.SetHighlighted(True)
            else:
                button.SetHighlighted(False)

        self.book.ChangeSelection(index)
