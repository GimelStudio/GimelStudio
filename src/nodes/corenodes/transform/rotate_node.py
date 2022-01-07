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


class RotateNode(api.Node):
    def __init__(self, nodegraph, _id):
        api.Node.__init__(self, nodegraph, _id)

    @property
    def NodeMeta(self):
        meta_info = {
            "label": "Rotate",
            "author": "Gimel Studio",
            "version": (0, 5, 0),
            "category": "TRANSFORM",
            "description": "Rotates an image.",
        }
        return meta_info

    def NodeInitProps(self):
        rotation = api.ChoiceProp(
            idname="rotation",
            default="90°",
            fpb_label="Rotation",
            choices=["90°", "180°", "270°"]
        )
        self.NodeAddProp(rotation)

    def NodeInitParams(self):
        image = api.RenderImageParam("image", "Image")

        self.NodeAddParam(image)

    def NodeEvaluation(self, eval_info):
        rotation = self.EvalProperty(eval_info, "rotation")
        image1 = self.EvalParameter(eval_info, "image")

        render_image = api.RenderImage()
        img = image1.Image("numpy")

        if rotation == "90°":
            output_img = np.rot90(img, 1)
        elif rotation == "180°":
            output_img = np.rot90(img, 2)
        elif rotation == "270°":
            output_img = np.rot90(img, 3)

        render_image.SetAsImage(output_img)
        self.NodeUpdateThumb(render_image)
        return render_image


api.RegisterNode(RotateNode, "corenode_rotate")