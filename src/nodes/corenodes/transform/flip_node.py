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


class FlipNode(api.Node):
    def __init__(self, nodegraph, id):
        api.Node.__init__(self, nodegraph, id)

    @property
    def NodeMeta(self):
        meta_info = {
            "label": "Flip",
            "author": "Gimel Studio",
            "version": (0, 5, 0),
            "category": "TRANSFORM",
            "description": "Flips the orientation of the image.",
        }
        return meta_info

    def NodeInitProps(self):
        image = api.ImageProp(
            idname="in_image",
        )
        flip_direction = api.ChoiceProp(
            idname="direction",
            default="Vertically",
            choices=["Vertically", "Horizontally", "Diagonally"],
            fpb_label="Orientation"
        )
        self.NodeAddProp(image)
        self.NodeAddProp(flip_direction)

    def NodeInitOutputs(self):
        self.outputs = {
            "image": api.Output(idname="image", datatype="IMAGE", label="Image"),
        }

    def MutedNodeEvaluation(self, eval_info):
        return self.EvalMutedNode(eval_info)

    def NodeEvaluation(self, eval_info):
        flip_direction = self.EvalProperty(eval_info, "direction")
        image1 = self.EvalProperty(eval_info, "in_image")

        render_image = api.Image()
        img = image1.GetImage()

        if flip_direction == "Vertically":
            output_img = np.flipud(img)
        elif flip_direction == "Horizontally":
            output_img = np.fliplr(img)
        elif flip_direction == "Diagonally":
            output_img = np.flipud(np.fliplr(img))

        render_image.SetAsImage(output_img)
        self.NodeUpdateThumb(render_image)
        return {
            "image": render_image
        }


api.RegisterNode(FlipNode, "corenode_flip")
