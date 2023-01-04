# ----------------------------------------------------------------------------
# Gimel Studio Copyright 2019-2023 by the Gimel Studio project contributors
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
from gsnodegraph import NodeGraphBase
from gsnodegraph.constants import SOCKET_OUTPUT

import gimelstudio.constants as const
from gimelstudio.datafiles import (ICON_NODEGRAPH_PANEL, ICON_MOUSE_LMB_MOVEMENT, 
                                   ICON_MOUSE_LMB, ICON_KEY_CTRL, ICON_MOUSE_MMB_MOVEMENT,
                                   ICON_MOUSE_RMB)
from .addnode_menu import AddNodeMenu

ID_ADDNODEMENU = wx.NewIdRef()


class NodeGraph(NodeGraphBase):
    def __init__(self, parent, registry, config, *args, **kwds):
        NodeGraphBase.__init__(self, parent, registry, config, *args, **kwds)

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

        # Setup the config with datatypes and node categories
        config = {
            "image_datatype": "IMAGE",
            "node_datatypes": {
                "IMAGE": "#C6C62D",  # Yellow
                "INTEGER": "#A0A0A0",  # Grey
                "FLOAT": "#A0A0A0",  # Grey
                "STRING": "#2DBCC6", # Blue
                "COLOR": "#D98B3D", # Orange
                "VECTOR": "#6E3DD9", # Purple
                "VALUE": "#A0A0A0",  # Depreciated!
            },
            "input_nodes_categories": ["INPUT"],
            "node_categories": {
                "INPUT": "#E64555",  # Burgendy
                "DRAW": "#AF4467",  # Pink
                "MASK": "#084D4D",  # Blue-green
                "CONVERT": "#564B7C",  # Purple
                "FILTER": "#558333",  # Green
                "BLEND": "#498DB8",  # Light blue
                "COLOR": "#C2AF3A",  # Yellow
                "TRANSFORM": "#6B8B8B", # Blue-grey
                "OUTPUT": "#B33641"  # Red
            }
        }

        self.nodegraph = NodeGraph(self, registry=self.registry, 
                                   config=config,
                                   size=(-1, self.Size[0]-20))

        # Add default image and output node
        image_node = self.nodegraph.AddNode('corenode_image', pos=wx.Point(150, 150))
        image_node.ToggleExpand()
        output_node = self.nodegraph.AddNode('corenode_outputcomposite', pos=wx.Point(1200, 250))

        # For testing during development
        if const.APP_FROZEN is False:
            self.nodegraph.AddNode('corenode_blur', pos=wx.Point(400, 200))
            self.nodegraph.AddNode('corenode_opacity', pos=wx.Point(650, 200))
            self.nodegraph.AddNode('corenode_flip', pos=wx.Point(900, 200))

        # Connect the nodes by default
        for socket in image_node.GetSockets():
            # We're assuming there is only one output
            if socket.direction == SOCKET_OUTPUT:
                src_socket = socket
        dst_socket = output_node.GetSockets()[0]
        self.nodegraph.ConnectNodes(src_socket, dst_socket)

        main_sizer.Add(topbar, flag=wx.EXPAND | wx.LEFT | wx.RIGHT)
        main_sizer.Add(self.nodegraph, 1, flag=wx.EXPAND | wx.BOTH)

        self.SetSizer(main_sizer)

        self.nodegraph.Bind(EVT_GSNODEGRAPH_NODESELECT, self.UpdateNodePropertiesPnl)
        self.nodegraph.Bind(EVT_GSNODEGRAPH_NODECONNECT, self.NodeConnectEvent)
        self.nodegraph.Bind(EVT_GSNODEGRAPH_NODEDISCONNECT, self.NodeDisconnectEvent)
        self.nodegraph.Bind(EVT_GSNODEGRAPH_MOUSEZOOM, self.ZoomNodeGraph)
        self.nodegraph.Bind(EVT_GSNODEGRAPH_ADDNODEBTN, self.OnAddNodeMenuButton)
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

    def OnAddNodeMenu(self, event):
        pos = wx.GetMousePosition()
        pos = (pos[0]-125, pos[1]-100)
        self.PopupAddNodeMenu(pos)
        
    def OnAddNodeMenuButton(self, event):
        pos = (8, self.nodegraph.GetRect()[3]-310)
        self.PopupAddNodeMenu(pos)
