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

import os
import wx

import gimelstudio.constants as const


class NodeGraphDropTarget(wx.DropTarget):
    def __init__(self, window, *args, **kwargs):
        super(NodeGraphDropTarget, self).__init__(*args, **kwargs)
        self._window = window
        self._composite = wx.DataObjectComposite()
        self._textDropData = wx.TextDataObject()
        self._fileDropData = wx.FileDataObject()
        self._composite.Add(self._textDropData)
        self._composite.Add(self._fileDropData)
        self.SetDataObject(self._composite)

    def OnDrop(self, x, y):
        return True

    def OnData(self, x, y, result):
        self.GetData()
        formatType, formatId = self.GetReceivedFormatAndId()
        if formatType in (wx.DF_TEXT, wx.DF_UNICODETEXT):
            return self.OnTextDrop()
        elif formatType == wx.DF_FILENAME:
            return self.OnFileDrop()

    def GetReceivedFormatAndId(self):
        _format = self._composite.GetReceivedFormat()
        formatType = _format.GetType()
        try:
            formatId = _format.GetId()  # May throw exception on unknown formats
        except Exception:
            formatId = None
        return formatType, formatId

    def OnTextDrop(self):
        try:
            self._window.AddNode(self._textDropData.GetText(), nodeid=None, 
                                 pos=(0, 0), location="CURSOR")
            self._window.UpdateNodegraph()
        except Exception as error:
            self.ShowError(error)
        return wx.DragCopy

    def OnFileDrop(self):
        for filename in self._fileDropData.GetFilenames():
            try:
                filetype = os.path.splitext(filename)[1]
                
                if filetype.lower() in const.SUPPORTED_FT_SAVE_LIST:
                    if os.path.exists(filename) is True:
                        # Create Image node with path
                        node = self._window.AddNode("corenode_image", pos=(0, 0),
                                                    nodeid=None, location="CURSOR")
                        node.NodeEditProp(idname="file_path",
                                          value=filename, render=False)
                        node.ToggleExpand()
                        node.NodeDndEventHook()
                        self._window.UpdateNodegraph()

                    else:
                        self.ShowError()

                else:
                    dlg = wx.MessageDialog(None,
                                           _("That file type isn't currently supported!"),
                                           _("Cannot Open File!"), style=wx.ICON_EXCLAMATION)
                    dlg.ShowModal()
                    return False

            except Exception as error:
                self.ShowError(error)

        return wx.DragCopy

    def ShowError(self, error=""):
        dlg = wx.MessageDialog(None, "\n {}!".format(str(error)),
                               _("Error!"), style=wx.ICON_ERROR)
        dlg.ShowModal()
        return False
