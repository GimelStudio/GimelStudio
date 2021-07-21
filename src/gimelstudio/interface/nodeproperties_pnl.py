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
import wx.html
import wx.lib.agw.flatmenu as flatmenu

from gswidgetkit import EVT_BUTTON, Button

from .utils import ComputeMenuPosAlignedLeft
import gimelstudio.interface.basewidgets.foldpanelbar as fpb
from gimelstudio.datafiles import (ICON_HELP, ICON_NODEPROPERTIES_PANEL,
                                   ICON_MORE_MENU_SMALL, ICON_MOUSE_LMB,
                                   ICON_MOUSE_MMB, ICON_MOUSE_RMB)

ID_MENU_UNDOCKPANEL = wx.NewIdRef()
ID_MENU_HIDEPANEL = wx.NewIdRef()


class NodePropertiesPanel(wx.Panel):
    def __init__(self, parent, id=wx.ID_ANY, pos=wx.DefaultPosition, size=wx.DefaultSize,
                 style=wx.NO_BORDER | wx.TAB_TRAVERSAL):
        wx.Panel.__init__(self, parent, id, pos, size, style)

        self.parent = parent

        self.SetBackgroundColour(wx.Colour("#464646"))

        self.BuildUI()

    @property
    def Parent(self):
        return self.parent

    @property
    def AUIManager(self):
        return self.parent._mgr

    @property
    def Statusbar(self):
        return self.parent.statusbar

    def BuildUI(self):
        main_sizer = wx.BoxSizer(wx.VERTICAL)

        topbar = wx.Panel(self)
        topbar.SetBackgroundColour("#424242")

        topbar_sizer = wx.GridBagSizer(vgap=1, hgap=1)

        self.area_icon = wx.StaticBitmap(topbar,
                                         bitmap=ICON_NODEPROPERTIES_PANEL.GetBitmap())
        self.area_label = wx.StaticText(topbar, label="")
        self.area_label.SetForegroundColour("#fff")
        self.area_label.SetFont(self.area_label.GetFont().Bold())

        self.menu_button = Button(topbar, label="", flat=True,
                                  bmp=(ICON_MORE_MENU_SMALL.GetBitmap(), 'left'))

        topbar_sizer.Add(self.area_icon, (0, 0), flag=wx.LEFT | wx.TOP | wx.BOTTOM,
                         border=8)
        topbar_sizer.Add(self.area_label, (0, 1), flag=wx.ALL, border=8)
        topbar_sizer.Add(self.menu_button, (0, 4), flag=wx.ALL, border=3)
        topbar_sizer.AddGrowableCol(2)

        topbar.SetSizer(topbar_sizer)

        self.main_panel = wx.Panel(self)
        self._mainsizer = wx.BoxSizer(wx.VERTICAL)
        self.main_panel.SetSizer(self._mainsizer)
        self._mainsizer.Fit(self.main_panel)

        main_sizer.Add(topbar, flag=wx.EXPAND | wx.LEFT | wx.RIGHT)
        main_sizer.Add(self.main_panel, 1, flag=wx.EXPAND | wx.BOTH)

        self.SetSizer(main_sizer)

        self.menu_button.Bind(EVT_BUTTON, self.OnAreaMenuButton)
        self.Bind(wx.EVT_MENU, self.OnMenuUndockPanel, id=ID_MENU_UNDOCKPANEL)
        self.Bind(wx.EVT_MENU, self.OnMenuHidePanel, id=ID_MENU_HIDEPANEL)
        self.main_panel.Bind(wx.EVT_ENTER_WINDOW, self.OnAreaFocus)

    def UpdatePanelContents(self, selected_node):
        self.main_panel.DestroyChildren()

        if selected_node is not None:

            # Node info
            nodeinfo_pnl = wx.Panel(self.main_panel, size=(-1, 50))
            nodeinfo_pnl.SetBackgroundColour("#464646")

            nodeinfo_pnl_sizer = wx.GridBagSizer(vgap=1, hgap=1)

            node_label = wx.StaticText(nodeinfo_pnl, label=selected_node._label)
            node_label.SetForegroundColour("#fff")
            node_label.SetFont(self.area_label.GetFont().Bold())

            self.help_button = Button(nodeinfo_pnl, label="", flat=True,
                                      bmp=(ICON_HELP.GetBitmap(), 'left'))

            nodeinfo_pnl_sizer.Add(node_label, (0, 1),
                                   flag=wx.TOP | wx.BOTTOM, border=6)
            nodeinfo_pnl_sizer.Add(self.help_button, (0, 4),
                                   flag=wx.TOP | wx.BOTTOM | wx.RIGHT, border=6)
            nodeinfo_pnl_sizer.AddGrowableCol(2)
            nodeinfo_pnl.SetSizer(nodeinfo_pnl_sizer)

            self._mainsizer.Add(nodeinfo_pnl, flag=wx.EXPAND)

            # Node Properties
            panel_bar = fpb.FoldPanelBar(self.main_panel, agwStyle=fpb.FPB_VERTICAL)

            selected_node.NodePanelUI(self.main_panel, panel_bar)

            style = fpb.CaptionBarStyle()
            style.SetCaptionFont(self.Parent.GetFont())
            style.SetCaptionColour(wx.Colour("#fff"))
            style.SetFirstColour(wx.Colour('#5c5c5c'))
            style.SetSecondColour(wx.Colour('#5c5c5c'))
            panel_bar.ApplyCaptionStyleAll(style)

            self._mainsizer.Add(panel_bar, 1, wx.EXPAND | wx.ALL)

            self._mainsizer.Layout()

            # Also bind the focus handler to the main panel and panel_bar
            nodeinfo_pnl.Bind(wx.EVT_ENTER_WINDOW, self.OnAreaFocus)
            panel_bar.Bind(wx.EVT_ENTER_WINDOW, self.OnAreaFocus)

        else:
            # Delete the window if the node is not selected
            self._mainsizer.Clear(delete_windows=True)

        self.AUIManager.Update()
        self.Parent.Refresh()
        self.Parent.Update()

    def OnAreaFocus(self, event):
        self.Statusbar.PushContextHints(2, mouseicon=ICON_MOUSE_LMB, text="",
                                        clear=True)
        self.Statusbar.PushContextHints(3, mouseicon=ICON_MOUSE_MMB, text="")
        self.Statusbar.PushContextHints(4, mouseicon=ICON_MOUSE_RMB, text="")
        self.Statusbar.PushMessage(_("Node Properties Area"))
        self.Statusbar.UpdateStatusBar()

    def OnAreaMenuButton(self, event):
        self.CreateAreaMenu()
        pos = ComputeMenuPosAlignedLeft(self.area_dropdownmenu, self.menu_button)
        self.area_dropdownmenu.Popup(pos, self)

    def OnMenuUndockPanel(self, event):
        self.AUIManager.GetPane("nodeproperties").Float()
        self.AUIManager.Update()

    def OnMenuHidePanel(self, event):
        self.AUIManager.GetPane("nodeproperties").Hide()
        self.AUIManager.Update()

    def CreateAreaMenu(self):
        self.area_dropdownmenu = flatmenu.FlatMenu()

        undockpanel_menuitem = flatmenu.FlatMenuItem(self.area_dropdownmenu,
                                                     ID_MENU_UNDOCKPANEL,
                                                     _("Undock panel"), "", wx.ITEM_NORMAL)
        self.area_dropdownmenu.AppendItem(undockpanel_menuitem)

        hidepanel_menuitem = flatmenu.FlatMenuItem(self.area_dropdownmenu,
                                                   ID_MENU_HIDEPANEL,
                                                   _("Hide panel"), "", wx.ITEM_NORMAL)
        self.area_dropdownmenu.AppendItem(hidepanel_menuitem)