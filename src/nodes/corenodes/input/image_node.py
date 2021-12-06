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

from gimelstudio import api, constants


class ImageNode(api.Node):
    def __init__(self, nodegraph, _id):
        api.Node.__init__(self, nodegraph, _id)

        self.cached_path = ""
        self.cached_image = None

    @property
    def NodeMeta(self):
        meta_info = {
            "label": "Image",
            "author": "Gimel Studio",
            "version": (3, 0, 5),
            "category": "INPUT",
            "description": "Loads an image from the specified file path."
        }
        return meta_info

    def NodeWidgetEventHook(self, idname, value):
        if idname == "file_path":
            image = self.NodeEvalSelf()
            self.NodeUpdateThumb(image)
            self.RefreshNodeGraph()

    def NodeDndEventHook(self):
        image = self.NodeEvalSelf()
        self.NodeUpdateThumb(image)
        self.RefreshNodeGraph()

    def NodeInitProps(self):
        wildcard = constants.SUPPORTED_FT_OPEN_WILDCARD

        self.fp_prop = api.OpenFileChooserProp(
            idname="file_path",
            default="",
            dlg_msg="Choose image...",
            wildcard=wildcard,
            btn_lbl="Choose...",
            fpb_label="Image Path"
        )

        self.NodeAddProp(self.fp_prop)

    def NodeEvaluation(self, eval_info):
        path = self.EvalProperty(eval_info, "file_path")

        render_image = api.RenderImage(size=(200, 200))

        if path != "":
            if self.cached_path != path:
                try:
                    render_image.SetAsOpenedImage(path)
                    self.cached_path = path
                    self.cached_image = render_image
                except FileNotFoundError:
                    print("DEBUG: FILE NOT FOUND")
            else:
                render_image = self.cached_image

        self.NodeUpdateThumb(render_image)
        return render_image


api.RegisterNode(ImageNode, "corenode_image")
