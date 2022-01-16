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

import wx

from gswidgetkit import (Label, NumberField, EVT_NUMBERFIELD_CHANGE)
from gsnodegraph import (EVT_GSNODEGRAPH_NODESELECT,
                         EVT_GSNODEGRAPH_NODECONNECT,
                         EVT_GSNODEGRAPH_NODEDISCONNECT,
                         EVT_GSNODEGRAPH_MOUSEZOOM,
                         EVT_GSNODEGRAPH_ADDNODEBTN)
from gsnodegraph import NodeGraph as NodeGraphBase

import gimelstudio.constants as const
from gimelstudio.datafiles import (ICON_NODEGRAPH_PANEL, ICON_MOUSE_LMB_MOVEMENT, 
                                   ICON_MOUSE_LMB, ICON_KEY_CTRL, ICON_MOUSE_MMB_MOVEMENT,
                                   ICON_MOUSE_RMB)
from .addnode_menu import AddNodeMenu

ID_ADDNODEMENU = wx.NewIdRef()


class NodeGraph(NodeGraphBase):
    def __init__(self, parent, registry, *args, **kwds):
        NodeGraphBase.__init__(self, parent, registry, *args, **kwds)

    @property
    def GLSLRenderer(self):
        return self.parent.GLSLRenderer


class NodeGraphPanel(wx.Panel):
    def __init__(self, parent, *args, **kwargs):
        wx.Panel.__init__(self, parent, id=wx.ID_ANY, pos=wx.DefaultPosition,
                          size=wx.DefaultSize, style=wx.NO_BORDER | wx.TAB_TRAVERSAL)

        self.registry = kwargs["registry"]
        self.parent = parent

        self.SetBackgroundColour(const.AREA_BG_COLOR)

        self.BuildUI()

    def BuildUI(self):
        main_sizer = wx.BoxSizer(wx.VERTICAL)

        topbar = wx.Panel(self)
        topbar.SetBackgroundColour(const.AREA_TOPBAR_COLOR)

        topbar_sizer = wx.GridBagSizer(vgap=1, hgap=1)

        self.area_icon = wx.StaticBitmap(topbar, bitmap=ICON_NODEGRAPH_PANEL.GetBitmap())
        self.area_label = Label(topbar, label="", font_bold=False)

        self.zoom_field = NumberField(topbar, default_value=100, label=_("Zoom"),
                                      min_value=25, max_value=250, suffix="%",
                                      show_p=False, disable_precise=True)

        topbar_sizer.Add(self.area_icon, (0, 0), flag=wx.LEFT | wx.TOP | wx.BOTTOM, border=8)
        topbar_sizer.Add(self.area_label, (0, 1), flag=wx.ALL, border=8)
        topbar_sizer.Add(self.zoom_field, (0, 4), flag=wx.ALL, border=3)
        topbar_sizer.Add((10, 10), (0, 5), flag=wx.ALL, border=3)
        topbar_sizer.AddGrowableCol(2)

        topbar.SetSizer(topbar_sizer)

        self.nodegraph = NodeGraph(self, self.registry, size=(-1, self.Size[0]-20))

        # Here for testing
        if const.APP_FROZEN is False:
            self.nodegraph.AddNode('corenode_blur', pos=wx.Point(600, 200))
            self.nodegraph.AddNode('corenode_opacity', pos=wx.Point(310, 200))
            self.nodegraph.AddNode('corenode_flip', pos=wx.Point(500, 300))

        # Add default image and output node
        self.nodegraph.AddNode('corenode_image', pos=wx.Point(100, 250))
        self.nodegraph.AddNode('corenode_outputcomposite', pos=wx.Point(950, 250))

        main_sizer.Add(topbar, flag=wx.EXPAND | wx.LEFT | wx.RIGHT)
        main_sizer.Add(self.nodegraph, 1, flag=wx.EXPAND | wx.BOTH)

        self.SetSizer(main_sizer)

        self.nodegraph.Bind(EVT_GSNODEGRAPH_NODESELECT, self.UpdateNodePropertiesPnl)
        self.nodegraph.Bind(EVT_GSNODEGRAPH_NODECONNECT, self.NodeConnectEvent)
        self.nodegraph.Bind(EVT_GSNODEGRAPH_NODEDISCONNECT, self.NodeDisconnectEvent)
        self.nodegraph.Bind(EVT_GSNODEGRAPH_MOUSEZOOM, self.ZoomNodeGraph)
        self.nodegraph.Bind(EVT_GSNODEGRAPH_ADDNODEBTN, self.OnAddNodeMenuButton)
        self.nodegraph.Bind(wx.EVT_ENTER_WINDOW, self.OnAreaFocus)
        self.zoom_field.Bind(EVT_NUMBERFIELD_CHANGE, self.ChangeZoom)
        self.parent.Bind(wx.EVT_MENU, self.OnAddNodeMenu, id=ID_ADDNODEMENU)

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

    def AddNode(self, idname, nodeid, pos, location):
        return self.nodegraph.AddNode(idname, nodeid, pos, location)

    def UpdateNodegraph(self):
        self.nodegraph.UpdateNodeGraph()

    def UpdateNodePropertiesPnl(self, event):
        self.PropertiesPanel.UpdatePanelContents(event.value)

    def NodeConnectEvent(self, event):
        self.parent.Render()

    def NodeDisconnectEvent(self, event):
        pass

    def ChangeZoom(self, event):
        level = event.value / 100.0
        # print(level, " <---> ", event.value)
        # if event.value > 60 and event.value < 310:
        self.nodegraph.SetZoomLevel(level)

    def ZoomNodeGraph(self, event):
        self.zoom_field.SetValue(event.value)
        self.zoom_field.UpdateDrawing()
        self.zoom_field.Refresh()

    def PopupAddNodeMenu(self, pos):
        self.addnodemenu = AddNodeMenu(self, self.registry,
                                       size=wx.Size(250, self.Size[1] - 50))
        self.addnodemenu.Position(pos, (2, 2))
        self.addnodemenu.SetSize(250, 400)
        if self.addnodemenu.IsShown() is not True:
            self.addnodemenu.Show()


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
        pos = wx.GetMousePosition()
        pos = (pos[0]-125, pos[1]-100)
        self.PopupAddNodeMenu(pos)
        
    def OnAddNodeMenuButton(self, event):
        pos = (8, self.nodegraph.GetRect()[3]-310)
        self.PopupAddNodeMenu(pos)
