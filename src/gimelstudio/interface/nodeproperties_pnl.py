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

# TODO: this is highly WIP

# text = """
# <html>
# <body style='background-color: #424242;'>
# <div>
# <span style='color: #E5E5E5;'>Blur Node</span>
# <p> <span style='color: #ADADAD;'>Blur the image pixels with the given filter type and blur radius.</span></p>
# </div>
# </body>
# </html>
# """


# class _PropertiesPanel(wx.Panel):
#     def __init__(self, parent, size=wx.DefaultSize):
#         wx.Panel.__init__(self, parent, wx.ID_ANY, size=size)
#         self._parent = parent
#         self._selectedNode = None

#         self._mainSizer = wx.BoxSizer(wx.VERTICAL)

#         self.SetSizer(self._mainSizer)
#         self._mainSizer.Fit(self)

#         self.SetBackgroundColour(wx.Colour("#404040"))

#     @property
#     def Parent(self):
#         return self._parent

#     @property
#     def AUIManager(self):
#         return self._parent._mgr

#     def UpdatePanelContents(self, selected_node):
#         self.DestroyChildren()

#         if selected_node != None:

#             scrollbar_size = wx.SystemSettings.GetMetric(wx.SYS_VSCROLL_X)
#             calc_size = wx.Size(self.Size[0] - scrollbar_size - 10, self.Size[1])

#             self.panel_staticbox = wx.Panel(self, id=wx.ID_ANY,
#                                             # label=selected_node.GetLabel(),
#                                             size=calc_size)

#             # This gets the recommended amount of border space to use for items
#             # within in the static box for the current platform.
#             #top_bd, other_bd = self.panel_staticbox.GetBordersForSizer()

#             staticbox_sizer = wx.BoxSizer(wx.VERTICAL)
#             staticbox_sizer.AddSpacer(8)

#             inner_sizer = wx.BoxSizer(wx.VERTICAL)

#             flagsExpand = wx.SizerFlags(1)
#             flagsExpand.Expand().Border(wx.ALL, 18)
#             staticbox_sizer.Add(inner_sizer, flagsExpand)

#             self.panel_staticbox.SetSizer(staticbox_sizer)

#             panel_sizer = wx.BoxSizer(wx.VERTICAL)
#             panel_sizer.Add(self.panel_staticbox, 1, wx.EXPAND | wx.ALL, 8)

#             # Node Properties UI
#             selected_node.NodePanelUI(self.panel_staticbox, inner_sizer)

#             self._mainSizer.Add(panel_sizer, wx.EXPAND | wx.ALL)

#         else:
#             # Delete the window if the node is not selected
#             self._mainSizer.Clear(delete_windows=True)

#         self.AUIManager.Update()
#         self.Parent.Refresh()
#         self.Parent.Update()


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

        if selected_node != None:

            panel_bar = fpb.FoldPanelBar(self, -1, agwStyle=fpb.FPB_VERTICAL)

            # fold_panel = panel_bar.AddFoldPanel(selected_node._label)
            # #thing = wx.TextCtrl(fold_panel, -1, size=(400, -1), style=wx.TE_MULTILINE)

            # selected_node

            
            # Node Properties UI
            selected_node.NodePanelUI(self, panel_bar)
            


            #thing2 = wx.TextCtrl(fold_panel2, -1, size=(400, -1), style=wx.TE_MULTILINE)

            

            
            #main_sizer.Add(st, flag=wx.EXPAND|wx.BOTH, border=20)
            #main_sizer.Add(panel_bar, 1, wx.EXPAND)

            self._mainSizer.Add(panel_bar, 1, wx.EXPAND | wx.ALL)
            

            style = fpb.CaptionBarStyle()
            style.SetCaptionFont(self.Parent.GetFont())
            style.SetCaptionColour(wx.Colour("#fff"))
            style.SetFirstColour(wx.Colour('#424242'))
            style.SetSecondColour(wx.Colour('#424242'))
            panel_bar.ApplyCaptionStyleAll(style)


        else:
            # Delete the window if the node is not selected
            self._mainSizer.Clear(delete_windows=True)

        self.AUIManager.Update()
        self.Parent.Refresh()
        self.Parent.Update()


        # sz = wx.BoxSizer(wx.VERTICAL)

        # ctrl1 = NumberField(self, default_value=70, label="Resolution X",
        #                     min_value=0, max_value=100, suffix="%")
        # ctrl2 = NumberField(self, default_value=10, label="Resolution Y",
        #                     min_value=0, max_value=100, suffix="%")

        # ctrl3 = wx.Button(self, label="hello")

        # sz.Add(ctrl1, flag=wx.EXPAND|wx.BOTH, border=20)
        # sz.Add(ctrl2, flag=wx.EXPAND|wx.BOTH, border=20)
        # sz.Add(ctrl3)
        # self.SetSizer(sz)

        # self.Bind(wx.EVT_BUTTON, self.OnC, ctrl3)
        # self.Bind(EVT_NUMBERFIELD, self.OnChange, ctrl1)

        # htmlwin = wx.html.HtmlWindow(self, size=(-1, 100))
        # htmlwin.SetPage(text)

        # st = htmlwin

