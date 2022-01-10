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

import cv2
from gimelstudio import api


class BlurNode(api.Node):
    def __init__(self, nodegraph, _id):
        api.Node.__init__(self, nodegraph, _id)

    @property
    def NodeMeta(self):
        meta_info = {
            "label": "Blur",
            "author": "Gimel Studio",
            "version": (2, 5, 0),
            "category": "FILTER",
            "description": "Blurs the given image using the specified blur type and kernel.",
        }
        return meta_info

    def NodeInitProps(self):
        filter_type = api.ChoiceProp(
            idname="filter_type",
            default="Box",
            choices=["Box", "Gaussian"],
            fpb_label="Filter Type"
        )
        kernel = api.XYZProp(
            idname="kernel", 
            default=(5, 5, 0), 
            labels=("Kernel X", "Kernel Y"),
            min_vals=(1, 1, 0), 
            max_vals=(600, 600, 0),
            show_p=False, 
            fpb_label="Blur Kernel"
        )
        self.NodeAddProp(filter_type)
        self.NodeAddProp(kernel)

    def NodeInitParams(self):
        image = api.RenderImageParam("image", "Image")

        self.NodeAddParam(image)

    def MutedNodeEvaluation(self, eval_info):
        return self.EvalMutedNode(eval_info)

    def NodeEvaluation(self, eval_info):
        kernel = self.EvalProperty(eval_info, "kernel")
        filter_type = self.EvalProperty(eval_info, "filter_type")
        image1 = self.EvalParameter(eval_info, "image")

        render_image = api.RenderImage()
        img = image1.Image("numpy")

        if filter_type == "Box":
            output_img = cv2.boxFilter(img, -1, (kernel[0], kernel[1]))
        elif filter_type == "Gaussian":
            # Both values must be odd
            if (kernel[0] % 2) == 0 and (kernel[1] % 2) == 0:
                kernel[1] += 1
                kernel[0] += 1

            output_img = cv2.GaussianBlur(img, (0, 0), sigmaX=kernel[0], sigmaY=kernel[1])

        render_image.SetAsImage(output_img)
        self.NodeUpdateThumb(render_image)
        return render_image


api.RegisterNode(BlurNode, "corenode_blur")
