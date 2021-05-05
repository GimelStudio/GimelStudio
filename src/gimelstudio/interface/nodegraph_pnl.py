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

from gswidgetkit import Button, NumberField, EVT_NUMBERFIELD_CHANGE
from gsnodegraph import (NodeGraph, EVT_GSNODEGRAPH_NODESELECT,
                         EVT_GSNODEGRAPH_NODECONNECT,
                         EVT_GSNODEGRAPH_NODEDISCONNECT,
                         EVT_GSNODEGRAPH_MOUSEZOOM)
from gimelstudio.datafiles import ICON_NODEGRAPH_PANEL, ICON_MORE_MENU_SMALL


class NodeGraphPanel(wx.Panel):
    def __init__(self, parent, registry, id=wx.ID_ANY, pos=wx.DefaultPosition, 
                 size=wx.DefaultSize, style=wx.NO_BORDER | wx.TAB_TRAVERSAL):
        wx.Panel.__init__(self, parent, id, pos, size, style)

        self.parent = parent
        self.registry = registry

        self.SetBackgroundColour(wx.Colour("#464646"))

        self.BuildUI()

    def BuildUI(self):
        main_sizer = wx.BoxSizer(wx.VERTICAL)

        topbar = wx.Panel(self)
        topbar.SetBackgroundColour("#424242")

        topbar_sizer = wx.GridBagSizer(vgap=1, hgap=1)

        self.area_icon = wx.StaticBitmap(topbar, bitmap=ICON_NODEGRAPH_PANEL.GetBitmap())
        self.area_label = wx.StaticText(topbar, label="Node Graph")
        self.area_label.SetForegroundColour("#fff")
        self.area_label.SetFont(self.area_label.GetFont().Bold())

        self.zoom_field = NumberField(topbar, default_value=100, label="Zoom",
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
        self.nodegraph.AddNode('image_node', wx.Point(100, 10))
        self.nodegraph.AddNode('image_node', wx.Point(400, 100))
        self.nodegraph.AddNode('blur_node', wx.Point(600, 200))
        self.nodegraph.AddNode('mix_node', wx.Point(100, 200))
        self.nodegraph.AddNode('output_node', wx.Point(300, 270))

        main_sizer.Add(topbar, flag=wx.EXPAND | wx.LEFT | wx.RIGHT)
        main_sizer.Add(self.nodegraph, 1, flag=wx.EXPAND | wx.BOTH)

        self.SetSizer(main_sizer)

        self.nodegraph.Bind(EVT_GSNODEGRAPH_NODESELECT, self.UpdateNodePropertiesPnl)
        self.nodegraph.Bind(EVT_GSNODEGRAPH_NODECONNECT, self.NodeConnectEvent)
        self.nodegraph.Bind(EVT_GSNODEGRAPH_NODEDISCONNECT, self.NodeDisconnectEvent)
        self.nodegraph.Bind(EVT_GSNODEGRAPH_MOUSEZOOM, self.ZoomNodeGraph)
        self.zoom_field.Bind(EVT_NUMBERFIELD_CHANGE, self.ChangeZoom)

    @property
    def NodeGraph(self):
        return self.nodegraph

    @property
    def PropertiesPanel(self):
        return self.parent.prop_pnl

    @property
    def ImageViewport(self):
        return self.parent.imageviewport_pnl

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
