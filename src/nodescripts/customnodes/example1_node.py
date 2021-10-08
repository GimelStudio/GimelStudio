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

import numpy as np

from gimelstudio import api


class Example1Node(api.Node):
    def __init__(self, nodegraph, _id):
        api.Node.__init__(self, nodegraph, _id)

    @property
    def NodeMeta(self):
        meta_info = {
            "label": "Example Node 1",
            "author": "Gimel Studio",
            "version": (0, 5, 0),
            "category": "TRANSFORM",
            "description": "Show an example node.",
        }
        return meta_info

    def NodeInitProps(self):
        self.direction = api.ChoiceProp(
            idname="Direction",
            default="Vertically",
            choices=["Vertically", "Horizontally"],
            label="Filter Type:"
        )
        self.NodeAddProp(self.direction)

    def NodeInitParams(self):
        image = api.RenderImageParam('Image')

        self.NodeAddParam(image)

    def NodeEvaluation(self, eval_info):
        flip_direction = self.EvalProperty(eval_info, 'Direction')
        image1 = self.EvalParameter(eval_info, 'Image')

        image = api.RenderImage()
        img = image1.Image("numpy")

        if flip_direction == "Vertically":
            output_img = np.flipud(img)
        elif flip_direction == "Horizontally":
            output_img = np.fliplr(img)

        image.SetAsImage(output_img)
        return image


api.RegisterNode(Example1Node, "node_example1")
