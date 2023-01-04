# ----------------------------------------------------------------------------
# Gimel Studio Copyright 2019-2023 by the Gimel Studio project contributors
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
    def __init__(self, nodegraph, id):
        api.Node.__init__(self, nodegraph, id)

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
        image = api.ImageProp(
            idname="in_image",
        )
        rotation = api.ChoiceProp(
            idname="rotation",
            default="90°",
            fpb_label="Rotation",
            choices=["90°", "180°", "270°"]
        )
        self.NodeAddProp(image)
        self.NodeAddProp(rotation)

    def NodeInitOutputs(self):
        self.outputs = {
            "image": api.Output(idname="image", datatype="IMAGE", label="Image"),
        }

    def NodeEvaluation(self, eval_info):
        rotation = self.EvalProperty(eval_info, "rotation")
        image1 = self.EvalProperty(eval_info, "in_image")

        render_image = api.Image()
        img = image1.GetImage()

        if rotation == "90°":
            output_img = np.rot90(img, 1)
        elif rotation == "180°":
            output_img = np.rot90(img, 2)
        elif rotation == "270°":
            output_img = np.rot90(img, 3)

        render_image.SetAsImage(output_img)
        self.NodeUpdateThumb(render_image)
        return {
            "image": render_image
        }


api.RegisterNode(RotateNode, "corenode_rotate")