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

from gswidgetkit import EVT_BUTTON, Button


class PreferencesSidebar(wx.Panel):
    def __init__(self, parent: wx.Dialog):
        wx.Panel.__init__(self, parent)

        self.parent = parent

        self.BuildUI()

    def BuildUI(self):
        self.SetBackgroundColour("#424242")

        main_layout = wx.BoxSizer(wx.VERTICAL)

        # ---

        main_layout.Add((self.GetSize()[0], 16), 0, wx.ALIGN_CENTER)

        # ---

        general_button = Button(self, label="General", flat=False, size=[128, 48])
        main_layout.Add(general_button, 0, wx.ALIGN_CENTER)

        main_layout.Add((self.GetSize()[0], 8), 0, wx.ALIGN_CENTER)

        interface_button = Button(self, label="Interface", flat=False, size=[128, 48])
        main_layout.Add(interface_button, 0, wx.ALIGN_CENTER)

        # ---

        main_layout.Add((self.GetSize()[0], 32), 0, wx.ALIGN_CENTER)

        # ---

        addons_button = Button(self, label="Addons", flat=False, size=[128, 48])
        main_layout.Add(addons_button, 0, wx.ALIGN_CENTER)

        main_layout.Add((self.GetSize()[0], 8), 0, wx.ALIGN_CENTER)

        nodes_button = Button(self, label="Nodes", flat=False, size=[128, 48])
        main_layout.Add(nodes_button, 0, wx.ALIGN_CENTER)

        main_layout.Add((self.GetSize()[0], 8), 0, wx.ALIGN_CENTER)

        templates_button = Button(self, label="Templates", flat=False, size=[128, 48])
        main_layout.Add(templates_button, 0, wx.ALIGN_CENTER)

        # ---

        main_layout.Add((self.GetSize()[0], 32), 0, wx.ALIGN_CENTER)

        # ---

        system_button = Button(self, label="System", flat=False, size=[128, 48])
        main_layout.Add(system_button, 0, wx.ALIGN_CENTER)

        main_layout.Add((self.GetSize()[0], 8), 0, wx.ALIGN_CENTER)

        file_paths_button = Button(self, label="File Paths", flat=False, size=[128, 48])
        main_layout.Add(file_paths_button, 0, wx.ALIGN_CENTER)

        # TODO: Add a Developers settings page?
        self.button_widgets = [general_button, interface_button, addons_button, nodes_button, templates_button,
                               system_button, file_paths_button]

        self.buttons = []
        for button_widget in self.button_widgets:
            button = {"widget": button_widget,
                      "index": self.button_widgets.index(button_widget)}
            self.buttons.append(button)

        self.SetSizer(main_layout)


class GeneralPage(wx.Panel):
    def __init__(self, parent):
        wx.Panel.__init__(self, parent)

        self.parent = parent

        self.BuildUI()

    def BuildUI(self):
        # TODO: Use wx.Colour() or a string?
        # TODO: Move certain methods to a new "BookPage" class?
        self.SetBackgroundColour("#464646")

        main_layout = wx.GridBagSizer(vgap=5, hgap=5)

        content_layout = wx.BoxSizer(wx.VERTICAL)

        title_text = wx.StaticText(self, label="General")
        title_text.SetForegroundColour("#FFFFFF")
        content_layout.Add(title_text, 1, wx.EXPAND)

        main_layout.Add(content_layout, (0, 0), flag=wx.ALL, border=16)

        self.SetSizer(main_layout)


class InterfacePage(wx.Panel):
    def __init__(self, parent):
        wx.Panel.__init__(self, parent)

        self.parent = parent

        self.BuildUI()

    def BuildUI(self):
        # TODO: Use wx.Colour() or a string?
        self.SetBackgroundColour("#464646")

        main_layout = wx.BoxSizer(wx.VERTICAL)

        title_text = wx.StaticText(self, label="Interface")
        title_text.SetForegroundColour("#FFFFFF")
        main_layout.Add(title_text, 1, wx.EXPAND)

        self.SetSizer(main_layout)


class AddonsPage(wx.Panel):
    def __init__(self, parent):
        wx.Panel.__init__(self, parent)

        self.parent = parent

        self.BuildUI()

    def BuildUI(self):
        # TODO: Use wx.Colour() or a string?
        self.SetBackgroundColour("#464646")

        main_layout = wx.BoxSizer(wx.VERTICAL)

        title_text = wx.StaticText(self, label="Addons")
        title_text.SetForegroundColour("#FFFFFF")
        main_layout.Add(title_text, 1, wx.EXPAND)

        self.SetSizer(main_layout)


class NodesPage(wx.Panel):
    def __init__(self, parent):
        wx.Panel.__init__(self, parent)

        self.parent = parent

        self.BuildUI()

    def BuildUI(self):
        # TODO: Use wx.Colour() or a string?
        self.SetBackgroundColour("#464646")

        main_layout = wx.BoxSizer(wx.VERTICAL)

        title_text = wx.StaticText(self, label="Nodes")
        title_text.SetForegroundColour("#FFFFFF")
        main_layout.Add(title_text, 1, wx.EXPAND)

        self.SetSizer(main_layout)


class TemplatesPage(wx.Panel):
    def __init__(self, parent):
        wx.Panel.__init__(self, parent)

        self.parent = parent

        self.BuildUI()

    def BuildUI(self):
        # TODO: Use wx.Colour() or a string?
        self.SetBackgroundColour("#464646")

        main_layout = wx.BoxSizer(wx.VERTICAL)

        title_text = wx.StaticText(self, label="Templates")
        title_text.SetForegroundColour("#FFFFFF")
        main_layout.Add(title_text, 1, wx.EXPAND)

        self.SetSizer(main_layout)


class SystemPage(wx.Panel):
    def __init__(self, parent):
        wx.Panel.__init__(self, parent)

        self.parent = parent

        self.BuildUI()

    def BuildUI(self):
        # TODO: Use wx.Colour() or a string?
        self.SetBackgroundColour("#464646")

        main_layout = wx.BoxSizer(wx.VERTICAL)

        title_text = wx.StaticText(self, label="System")
        title_text.SetForegroundColour("#FFFFFF")
        main_layout.Add(title_text, 1, wx.EXPAND)

        self.SetSizer(main_layout)


class FilePathsPage(wx.Panel):
    def __init__(self, parent):
        wx.Panel.__init__(self, parent)

        self.parent = parent

        self.BuildUI()

    def BuildUI(self):
        # TODO: Use wx.Colour() or a string?
        self.SetBackgroundColour("#464646")

        main_layout = wx.BoxSizer(wx.VERTICAL)

        title_text = wx.StaticText(self, label="File Paths")
        title_text.SetForegroundColour("#FFFFFF")
        main_layout.Add(title_text, 1, wx.EXPAND)

        self.SetSizer(main_layout)


class PreferencesSimpleBook(wx.Simplebook):
    def __init__(self, parent):
        wx.Simplebook.__init__(self, parent)

        self.parent = parent

        self.BuildUI()

    def BuildUI(self):
        # General
        general_page = GeneralPage(self)
        self.AddPage(general_page, "General")

        # Interface
        interface_page = InterfacePage(self)
        self.AddPage(interface_page, "Interface")

        # Addons
        addons_page = AddonsPage(self)
        self.AddPage(addons_page, "Addons")

        # Nodes
        nodes_page = NodesPage(self)
        self.AddPage(nodes_page, "Nodes")

        # Templates
        templates_page = TemplatesPage(self)
        self.AddPage(templates_page, "Templates")

        # System
        system_page = InterfacePage(self)
        self.AddPage(system_page, "System")

        # File paths
        file_paths_page = InterfacePage(self)
        self.AddPage(file_paths_page, "File Paths")


class PreferencesDialog(wx.Dialog):
    def __init__(self, parent, title):
        wx.Dialog.__init__(self, parent, title=title, size=[800, 600])

        self.BuildUI()

    def BuildUI(self):
        # Main layout
        main_layout = wx.BoxSizer(wx.HORIZONTAL)
        
        # Side bar
        self.side_bar = PreferencesSidebar(self)
        main_layout.Add(self.side_bar, 1, wx.EXPAND)
        
        # The simplebook
        self.book = PreferencesSimpleBook(self)
        main_layout.Add(self.book, 3, wx.EXPAND)

        for button in self.side_bar.buttons:
            button["widget"].Bind(EVT_BUTTON, lambda event, index=button["index"]: self.OnButtonPressed(index))

        self.SetSizer(main_layout)

    def OnButtonPressed(self, index):
        self.book.ChangeSelection(index)
