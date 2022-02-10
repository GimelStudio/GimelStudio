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
from gimelstudio import api
from gimelstudio.interface import ExportImageHandler


class OutputNode(api.Node):
    def __init__(self, nodegraph, _id):
        api.Node.__init__(self, nodegraph, _id)

    def IsOutputNode(self):
        return True

    @property
    def NodeMeta(self):
        meta_info = {
            "label": "Output",
            "author": "Gimel Studio",
            "version": (0, 1, 3),
            "category": "OUTPUT",
            "description": """The most important node of them all. :)
        This is registered here for the UI -the evaluation is handled elsewhere.
        This node should not be accessed by outside users.
        """
        }
        return meta_info

    def NodeInitProps(self):
        export_button = api.ActionProp(
            idname="export",
            fpb_label="Export",
            btn_label="Export Image",
            action=self.OnExportButtonPressed,
            can_be_exposed=False
        )
        image = api.ImageProp(
            idname="image",
        )
        self.NodeAddProp(export_button)
        self.NodeAddProp(image)

    def NodeEvaluation(self, eval_info):
        pass

    def OnExportButtonPressed(self, event):
        # TODO: This is messy. Need to find a cleaner solution to accessing the renderer
        app_frame = self.nodegraph.parent.parent
        image = app_frame.renderer.GetRender()
        try:
            export_handler = ExportImageHandler(app_frame, image.GetImage())
            export_handler.RunExport()
        except AttributeError:
            dlg = wx.MessageDialog(None,
               _("Please render an image before attempting to export!"),
               _("No Image to Export!"), style=wx.ICON_EXCLAMATION)
            dlg.ShowModal()


api.RegisterNode(OutputNode, "corenode_outputcomposite")
