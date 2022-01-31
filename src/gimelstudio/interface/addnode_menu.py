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
import wx.adv
import wx.stc

import gimelstudio.constants as const


class NodesVListBox(wx.VListBox):
    def __init__(self, *args, **kw):
        self.parent = args[0]
        wx.VListBox.__init__(self, *args, **kw)

        self.SetBackgroundColour(const.ADD_NODE_MENU_BG)

        self.Bind(wx.EVT_MOTION, self.OnStartDrag)

    def GetItemText(self, item):
        return self.GetNodeObject(item).GetLabel()

    def GetItemColor(self, item):
        return self.GetNodeObject(item).GetLabel()

    def GetNodeObject(self, node_type):
        return self.NodeRegistry[self.NodeRegistryMap[node_type]](None, None)

    @property
    def NodeRegistryMap(self):
        return self.parent._nodeRegistryMapping

    @property
    def NodeRegistry(self):
        return self.parent._nodeRegistry

    def OnStartDrag(self, event):
        """ Start of drag n drop event handler. """
        if event.Dragging():
            selection = self.NodeRegistryMap[self.GetSelection()]
            data = wx.TextDataObject()
            data.SetText(selection)

            dropSource = wx.DropSource(self)
            dropSource.SetData(data)
            result = dropSource.DoDragDrop()

            # Reset the focus back to the search input so that
            # after a user dnd a node, they can search again straight-away.
            if result:
                # self.parent.search_bar.SetFocus()
                self.SetSelection(-1)

    # This method must be overridden.  When called it should draw the
    # n'th item on the dc within the rect.  How it is drawn, and what
    # is drawn is entirely up to you.
    def OnDrawItem(self, dc, rect, n):
        """ Draws the item itself. """
        # Monkey-patch some padding for the left side
        rect[0] += 16

        color = wx.Colour("#fff")

        # Draw item with node label
        if self.GetSelection() == n:
            dc.SetFont(self.GetFont().Bold())
        else:
            dc.SetFont(self.GetFont())
        dc.SetTextForeground(color)
        dc.SetBrush(wx.Brush(color, wx.SOLID))
        dc.DrawLabel(text=self.GetItemText(n), rect=rect,
                     alignment=wx.ALIGN_LEFT | wx.ALIGN_CENTER_VERTICAL)

        # Monkey-patch some padding for the right side
        rect[2] -= 18

    def OnMeasureItem(self, n):
        """ Returns the height required to draw the n'th item. """
        height = 0
        for line in self.GetItemText(n).split('\n'):
            w, h = self.GetTextExtent(line)
            height += h
        return height + 20

    def OnDrawBackground(self, dc, rect, n):
        """ Draws the item background. """
        if self.GetSelection() == n:
            color = wx.Colour(const.ACCENT_COLOR)
        else:
            color = wx.Colour(const.ADD_NODE_MENU_BG)

        dc.SetPen(wx.TRANSPARENT_PEN)
        dc.SetBrush(wx.Brush(color, wx.SOLID))
        dc.DrawRoundedRectangle(rect, 4)

    def SearchNodeRegistry(self, node_label, search_string):
        """ Returns whether or not the search string is in
        the label text or not.
        """
        label = node_label.lower()
        if search_string in label:
            return True
        else:
            return False

    def UpdateForSearch(self, search_string):
        """ Updates the listbox based on the search string. """
        # Reset mapping var
        self.parent._nodeRegistryMapping = {}

        i = 0
        for item in self.NodeRegistry:
            if item != "corenode_outputcomposite":
                lbl = self.NodeRegistry[item](None, None).GetLabel()
                if self.SearchNodeRegistry(lbl, search_string.lower()):
                    self.NodeRegistryMap[i] = item
                    i += 1

        # Deal with selection and update size
        size = len(self.NodeRegistryMap)
        if size == 1:
            self.SetSelection(0)
        else:
            self.SetSelection(-1)
        self.SetItemCount(size)

        # Refresh the window
        self.Refresh()


class AddNodeMenu(wx.PopupTransientWindow):
    def __init__(self, parent, node_registry, size,
                 style=wx.BORDER_NONE | wx.PU_CONTAINS_CONTROLS):
        wx.PopupTransientWindow.__init__(self, parent, style)

        self.parent = parent
        self._size = size
        self._nodeRegistry = node_registry
        self._nodeRegistryMapping = {}

        self.SetBackgroundColour(const.ADD_NODE_MENU_BG)

        self.InitRegistryMapping()
        self.InitAddNodeMenuUI()

    def InitRegistryMapping(self):
        i = 0
        for item in self._nodeRegistry:
            if item != "corenode_outputcomposite":
                self._nodeRegistryMapping[i] = item
                i += 1

    def InitAddNodeMenuUI(self):
        # Sizer
        main_sizer = wx.BoxSizer(wx.VERTICAL)

        # Label
        main_sizer.AddSpacer(5)
        header_lbl = wx.StaticText(self, wx.ID_ANY, _("Add Node"))
        header_lbl.SetForegroundColour(wx.Colour("#fff"))
        header_lbl.SetFont(self.GetFont().MakeBold())
        main_sizer.Add(header_lbl, flag=wx.EXPAND | wx.ALL, border=14)
        main_sizer.AddSpacer(5)

        # Search bar
        # self.search_bar = TextCtrl(self, #style=wx.BORDER_SIMPLE,
        #                            #placeholder=_("Search nodes…"), 
        #                            size=(-1, 26))
        # self.search_bar.SetFocus()

        # main_sizer.Add(self.search_bar, flag=wx.EXPAND | wx.ALL, border=5)
        main_sizer.AddSpacer(5)

        # Nodes list box
        self.nodes_listbox = NodesVListBox(self, size=self._size,
                                           style=wx.BORDER_NONE)
        self.nodes_listbox.SetItemCount(len(self._nodeRegistryMapping))
        main_sizer.Add(self.nodes_listbox, flag=wx.EXPAND | wx.ALL, border=5)

        self.SetSizer(main_sizer)

        # Bindings
        # self.Bind(wx.stc.EVT_STC_MODIFIED, self.OnDoSearch, self.search_bar)
        self.Bind(wx.EVT_LISTBOX_DCLICK, self.OnClickSelectItem, self.nodes_listbox)
        self.Bind(wx.EVT_LISTBOX, self.OnClickSelectItem, self.nodes_listbox)

    @property
    def NodeGraph(self):
        """ Get the Node Graph. """
        return self.parent

    def OnDoSearch(self, event):
        """ Event handler for when something is typed into the search bar, etc. """
        self.nodes_listbox.UpdateForSearch(event.GetString())

    def OnClickSelectItem(self, event):
        pass