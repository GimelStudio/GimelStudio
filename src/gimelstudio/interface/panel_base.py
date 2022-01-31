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
import wx.lib.agw.flatmenu as flatmenu

from .utils import ComputeMenuPosAlignedLeft

ID_MENU_UNDOCKPANEL = wx.NewIdRef()
ID_MENU_HIDEPANEL = wx.NewIdRef()


class PanelBase(wx.Panel):
    """
    Base class for panels in the UI. Handles the panel dropdown menu
    with the necessary show/hide and undock logic.
    """
    def __init__(self, parent, idname, menu_item, *args, **kwargs):
        wx.Panel.__init__(self, parent, id=wx.ID_ANY, pos=wx.DefaultPosition,
                          size=wx.DefaultSize, style=wx.NO_BORDER | wx.TAB_TRAVERSAL)
        self.parent = parent
        self._idname = idname
        self._menu_item = menu_item

        self.Bind(wx.EVT_MENU, self.OnMenuUndockPanel, id=ID_MENU_UNDOCKPANEL)
        self.Bind(wx.EVT_MENU, self.OnMenuHidePanel, id=ID_MENU_HIDEPANEL)

    def OnAreaMenuButton(self, event):
        self.CreateAreaMenu()
        pos = ComputeMenuPosAlignedLeft(self.area_dropdownmenu, self.menu_button)
        self.area_dropdownmenu.Popup(pos, self)

    def OnMenuUndockPanel(self, event):
        self.UndockPanel()

    def OnMenuHidePanel(self, event):
        self.HidePanel()

    def UndockPanel(self):
        self.AUIManager.GetPane(self._idname).Float()
        self.AUIManager.Update()

    def ShowPanel(self):
        self.AUIManager.GetPane(self._idname).Show()
        self.AUIManager.Update()

        if self._menu_item is not None:
            self._menu_item.Check(True)

    def HidePanel(self):
        self.AUIManager.GetPane(self._idname).Hide()
        self.AUIManager.Update()

        if self._menu_item is not None:
            self._menu_item.Check(False)

    def CreateAreaMenu(self):
        self.area_dropdownmenu = flatmenu.FlatMenu()

        undockpanel_menuitem = flatmenu.FlatMenuItem(self.area_dropdownmenu,
                                                     ID_MENU_UNDOCKPANEL,
                                                     _("Undock panel"), "",
                                                     wx.ITEM_NORMAL)
        self.area_dropdownmenu.AppendItem(undockpanel_menuitem)

        hidepanel_menuitem = flatmenu.FlatMenuItem(self.area_dropdownmenu,
                                                   ID_MENU_HIDEPANEL,
                                                   _("Hide panel"), "",
                                                   wx.ITEM_NORMAL)
        self.area_dropdownmenu.AppendItem(hidepanel_menuitem)
