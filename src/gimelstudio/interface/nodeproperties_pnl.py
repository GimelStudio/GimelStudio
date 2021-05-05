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
import wx.lib.agw.foldpanelbar as fpb


class NodePropertiesPanel(wx.Panel):
    def __init__(self, parent, id=wx.ID_ANY, pos=wx.DefaultPosition, size=wx.DefaultSize,
                 style=wx.NO_BORDER | wx.TAB_TRAVERSAL):
        wx.Panel.__init__(self, parent, id, pos, size, style)

        self._parent = parent
        self._selectedNode = None

        self._mainSizer = wx.BoxSizer(wx.VERTICAL)

        self.SetSizer(self._mainSizer)
        self._mainSizer.Fit(self)

        self.SetBackgroundColour(wx.Colour("#464646"))

    @property
    def Parent(self):
        return self._parent

    @property
    def AUIManager(self):
        return self._parent._mgr

    def UpdatePanelContents(self, selected_node):
        self.DestroyChildren()

        if selected_node is not None:

            panel_bar = fpb.FoldPanelBar(self, agwStyle=fpb.FPB_VERTICAL)

            # Node Properties UI
            selected_node.NodePanelUI(self, panel_bar)

            self._mainSizer.Add(panel_bar, 1, wx.EXPAND | wx.ALL)
            
            style = fpb.CaptionBarStyle()
            style.SetCaptionFont(self.Parent.GetFont())
            style.SetCaptionColour(wx.Colour("#fff"))
            style.SetFirstColour(wx.Colour('#424242'))
            style.SetSecondColour(wx.Colour('#424242'))
            panel_bar.ApplyCaptionStyleAll(style)

            self._mainSizer.Layout()

        else:
            # Delete the window if the node is not selected
            self._mainSizer.Clear(delete_windows=True)

        self.AUIManager.Update()
        self.Parent.Refresh()
        self.Parent.Update()