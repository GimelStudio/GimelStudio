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

import numpy as np
from gimelstudio import api


class ColorImageNode(api.Node):
    def __init__(self, nodegraph, _id):
        api.Node.__init__(self, nodegraph, _id)

    @property
    def NodeMeta(self):
        meta_info = {
            "label": "Color Image",
            "author": "Gimel Studio",
            "version": (0, 0, 5),
            "category": "INPUT",
            "description": "Creates a color image."
        }
        return meta_info

    def NodeWidgetEventHook(self, idname, value):
        if idname == "color":
            image = self.NodeEvalSelf()
            self.NodeUpdateThumb(image)
            self.RefreshPropertyPanel()
            self.RefreshNodeGraph()

    def NodeInitProps(self):
        image_size = api.XYZProp(
            idname="image_size", 
            default=(125, 125, 0), 
            labels=("Width", "Height"),
            min_vals=(0, 0, 0), 
            max_vals=(4000, 4000, 0),
            show_p=False, 
            fpb_label="Image Size"
        )
        # color = api.ColorProp(...)
        self.NodeAddProp(image_size)
        #self.NodeAddProp(color)

    def NodeEvaluation(self, eval_info):
        image_size = self.EvalProperty(eval_info, "image_size")

        render_image = api.RenderImage()

        img = np.zeros((image_size[0], image_size[1], 4), dtype=np.float32) + (255, 255, 255, 255)

        render_image.SetAsImage(img)
        self.NodeUpdateThumb(render_image)
        return render_image


api.RegisterNode(ColorImageNode, "corenode_colorimage")



