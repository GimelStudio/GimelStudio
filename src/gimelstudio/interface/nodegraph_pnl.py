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
import wx.lib.agw.flatmenu as flatmenu
from gswidgetkit import Button, EVT_BUTTON, NumberField, EVT_NUMBERFIELD_CHANGE
from gsnodegraph import (EVT_GSNODEGRAPH_NODESELECT,
                         EVT_GSNODEGRAPH_NODECONNECT,
                         EVT_GSNODEGRAPH_NODEDISCONNECT,
                         EVT_GSNODEGRAPH_MOUSEZOOM)
from gsnodegraph import NodeGraph as NodeGraphBase

import gimelstudio.constants as const
from gimelstudio.datafiles import (ICON_NODEGRAPH_PANEL, ICON_MORE_MENU_SMALL,
                                   ICON_MOUSE_LMB_MOVEMENT, ICON_MOUSE_LMB,
                                   ICON_KEY_CTRL, ICON_MOUSE_MMB_MOVEMENT,
                                   ICON_MOUSE_RMB)
from .utils import ComputeMenuPosAlignedLeft
from .addnode_menu import AddNodeMenu

ID_MENU_UNDOCKPANEL = wx.NewIdRef()
ID_MENU_HIDEPANEL = wx.NewIdRef()
ID_ADDNODEMENU = wx.NewIdRef()


class NodeGraph(NodeGraphBase):
    def __init__(self, parent, registry, *args, **kwds):
        NodeGraphBase.__init__(self, parent, registry, *args, **kwds)

    @property
    def GLSLRenderer(self):
        return self.parent.GLSLRenderer


class NodeGraphPanel(wx.Panel):
    def __init__(self, parent, registry, id=wx.ID_ANY, pos=wx.DefaultPosition,
                 size=wx.DefaultSize, style=wx.NO_BORDER | wx.TAB_TRAVERSAL):
        wx.Panel.__init__(self, parent, id, pos, size, style)

        self.parent = parent
        self.registry = registry

        self.SetBackgroundColour(const.AREA_BG_COLOR)

        self.BuildUI()

    def BuildUI(self):
        main_sizer = wx.BoxSizer(wx.VERTICAL)

        topbar = wx.Panel(self)
        topbar.SetBackgroundColour(const.AREA_TOPBAR_COLOR)

        topbar_sizer = wx.GridBagSizer(vgap=1, hgap=1)

        self.area_icon = wx.StaticBitmap(topbar, bitmap=ICON_NODEGRAPH_PANEL.GetBitmap())
        self.area_label = wx.StaticText(topbar, label="")
        self.area_label.SetForegroundColour("#fff")
        self.area_label.SetFont(self.area_label.GetFont().Bold())

        self.zoom_field = NumberField(topbar, default_value=100, label=_("Zoom"),
                                      min_value=25, max_value=250, suffix="%",
                                      show_p=False)
        self.menu_button = Button(topbar, label="", flat=True,
                                  bmp=(ICON_MORE_MENU_SMALL.GetBitmap(), 'left'))

        topbar_sizer.Add(self.area_icon, (0, 0), flag=wx.LEFT | wx.TOP | wx.BOTTOM, border=8)
        topbar_sizer.Add(self.area_label, (0, 1), flag=wx.ALL, border=8)
        topbar_sizer.Add(self.zoom_field, (0, 3), flag=wx.ALL, border=3)
        topbar_sizer.Add(self.menu_button, (0, 4), flag=wx.ALL, border=3)
        topbar_sizer.AddGrowableCol(2)

        topbar.SetSizer(topbar_sizer)

        self.nodegraph = NodeGraph(self, self.registry, size=(-1, self.Size[0]-20))

        # here for testing
        self.nodegraph.AddNode('corenode_image', wx.Point(100, 30))
        self.nodegraph.AddNode('corenode_image', wx.Point(100, 200))
        self.nodegraph.AddNode('corenode_blur', wx.Point(600, 200))
        self.nodegraph.AddNode('corenode_opacity', wx.Point(300, 200))
        self.nodegraph.AddNode('corenode_outputcomposite', wx.Point(900, 270))
        self.nodegraph.AddNode('corenode_flip', wx.Point(500, 300))
        self.nodegraph.AddNode('corenode_alpha_over', wx.Point(300, 350))

        main_sizer.Add(topbar, flag=wx.EXPAND | wx.LEFT | wx.RIGHT)
        main_sizer.Add(self.nodegraph, 1, flag=wx.EXPAND | wx.BOTH)

        self.SetSizer(main_sizer)

        self.nodegraph.Bind(EVT_GSNODEGRAPH_NODESELECT, self.UpdateNodePropertiesPnl)
        self.nodegraph.Bind(EVT_GSNODEGRAPH_NODECONNECT, self.NodeConnectEvent)
        self.nodegraph.Bind(EVT_GSNODEGRAPH_NODEDISCONNECT, self.NodeDisconnectEvent)
        self.nodegraph.Bind(EVT_GSNODEGRAPH_MOUSEZOOM, self.ZoomNodeGraph)
        self.nodegraph.Bind(wx.EVT_ENTER_WINDOW, self.OnAreaFocus)
        self.zoom_field.Bind(EVT_NUMBERFIELD_CHANGE, self.ChangeZoom)
        self.menu_button.Bind(EVT_BUTTON, self.OnAreaMenuButton)
        self.parent.Bind(wx.EVT_MENU, self.OnAddNodeMenu, id=ID_ADDNODEMENU)
        self.Bind(wx.EVT_MENU, self.OnMenuUndockPanel, id=ID_MENU_UNDOCKPANEL)
        self.Bind(wx.EVT_MENU, self.OnMenuHidePanel, id=ID_MENU_HIDEPANEL)

        # Keyboard shortcut bindings
        self.accel_tbl = wx.AcceleratorTable([(wx.ACCEL_SHIFT, ord('A'),
                                               ID_ADDNODEMENU)])
        self.parent.SetAcceleratorTable(self.accel_tbl)

    @property
    def AUIManager(self):
        return self.parent._mgr

    @property
    def NodeGraph(self):
        return self.nodegraph

    @property
    def PropertiesPanel(self):
        return self.parent.prop_pnl

    @property
    def GLSLRenderer(self):
        return self.parent.glsl_renderer

    @property
    def Statusbar(self):
        return self.parent.statusbar

    @property
    def ImageViewport(self):
        return self.parent.imageviewport_pnl

    def AddNode(self, idname, pos, location):
        return self.nodegraph.AddNode(idname, pos, location)

    def UpdateNodegraph(self):
        self.nodegraph.UpdateDrawing()

    def UpdateNodePropertiesPnl(self, event):
        self.PropertiesPanel.UpdatePanelContents(event.value)

    def NodeConnectEvent(self, event):
        self.parent.Render()

    def NodeDisconnectEvent(self, event):
        pass

    def ChangeZoom(self, event):
        level = event.value / 100.0
        self.nodegraph.SetZoomLevel(level)

    def ZoomNodeGraph(self, event):
        self.zoom_field.SetValue(event.value)
        self.zoom_field.UpdateDrawing()
        self.zoom_field.Refresh()

    def OnAreaFocus(self, event):
        self.Statusbar.PushContextHints(2, mouseicon=ICON_MOUSE_LMB_MOVEMENT,
                                        text=_("Box Select Nodes"), clear=True)
        self.Statusbar.PushContextHints(3, mouseicon=ICON_MOUSE_LMB,
                                        text=_("Select Node"))
        self.Statusbar.PushContextHints(4, mouseicon=ICON_MOUSE_LMB,
                                        keyicon=ICON_KEY_CTRL,
                                        text=_("Connect Selected Node To Output"))
        self.Statusbar.PushContextHints(5, mouseicon=ICON_MOUSE_MMB_MOVEMENT,
                                        text=_("Pan Node Graph"))
        self.Statusbar.PushContextHints(6, mouseicon=ICON_MOUSE_RMB,
                                        text=_("Node Context Menu"))
        self.Statusbar.PushMessage(_("Node Graph Area"))
        self.Statusbar.UpdateStatusBar()

    def OnAddNodeMenu(self, event):
        """ Event handler to bring up the Add Node menu. """
        self.addnodemenu = AddNodeMenu(self, self.registry,
                                       size=wx.Size(250, self.Size[1] - 50))
        pos = wx.GetMousePosition()
        self.addnodemenu.Position((pos[0]-125, pos[1]-100), (2, 2))
        self.addnodemenu.SetSize(250, 400)
        if self.addnodemenu.IsShown() is not True:
            self.addnodemenu.Show()

    def OnLoseFocus(self, event):
        self.Dismiss()

    def OnAreaMenuButton(self, event):
        self.CreateAreaMenu()
        pos = ComputeMenuPosAlignedLeft(self.area_dropdownmenu, self.menu_button)
        self.area_dropdownmenu.Popup(pos, self)

    def OnMenuUndockPanel(self, event):
        self.AUIManager.GetPane("nodegraph").Float()
        self.AUIManager.Update()

    def OnMenuHidePanel(self, event):
        self.AUIManager.GetPane("nodegraph").Hide()
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
