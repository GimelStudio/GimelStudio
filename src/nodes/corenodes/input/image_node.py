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

import os.path
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
            
            # Set image info
            # if value != "":
            #     buf = image.Image("oiio")
            #     spec = buf.spec()
            #     file_bytes = os.path.getsize(value)
            #     if file_bytes < (1024*1024):
            #         prefix = "MB"
            #         size = file_bytes / (1024*1024)
            #     else:
            #         prefix = "kB" 
            #         size = file_bytes / 1024
            #     info = "{0}x{1}px  |  {2}{3}".format(spec.width, spec.height, round(size, 3), prefix)
            #     self.img_info.SetValue(info)

            # self.NodeUpdateThumb(image)
            # self.RefreshPropertyPanel()
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
        self.img_info = api.LabelProp(
            idname="label",
            default="-",
            fpb_label="Image Info",
            expanded=False
        )

        self.NodeAddProp(self.fp_prop)
        self.NodeAddProp(self.img_info)

    def NodeEvaluation(self, eval_info):
        path = self.EvalProperty(eval_info, "file_path")

        render_image = api.RenderImage(size=(200, 200))

        # 
        #     if self.cached_path != path:
        #         try:
        #             render_image.SetAsOpenedImage(path)
        #             self.cached_path = path
        #             self.cached_image = render_image
        #         except FileNotFoundError:
        #             print("DEBUG: FILE NOT FOUND")
        #     else:
        #         render_image = self.cached_image
        if path != "":
            render_image.SetAsOpenedImage(path)

        self.NodeUpdateThumb(render_image)
        return render_image


api.RegisterNode(ImageNode, "corenode_image")
