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


class DilateErodeNode(api.Node):
    def __init__(self, nodegraph, _id):
        api.Node.__init__(self, nodegraph, _id)

    @property
    def NodeMeta(self):
        meta_info = {
            "label": "Dilate/Erode",
            "author": "Gimel Studio",
            "version": (0, 6, 0),
            "category": "TRANSFORM",
            "description": "Applies a morphological operation like erosion, dilation, opening, closing etc.",
        }
        return meta_info

    def NodeWidgetEventHook(self, idname, value):
        if idname == "operation" and (value == "Dilate" or value == "Erode"):
            self.iterations.SetIsVisible(True)
            self.RefreshPropertyPanel()
        elif idname != "operation":
            pass
        else:
            self.iterations.SetIsVisible(False)
            self.RefreshPropertyPanel()

    def NodeInitProps(self):
        operation = api.ChoiceProp(
            idname="operation",
            default="Erode",
            choices=["Dilate", "Erode", "Opening", "Closing", "Top Hat", "Black Hat"],
            fpb_label="Operation"
        )

        kernel_shape = api.ChoiceProp(
            idname="kernel_shape",
            default="Rectangle",
            choices=["Rectangle", "Ellipse", "Cross"],
            fpb_label="Kernel Shape"
        )

        kernel_size = api.PositiveIntegerProp(
            idname="kernel_size",
            default=5,
            min_val=1,
            max_val=100,
            fpb_label="Kernel Size"
        )

        self.iterations = api.PositiveIntegerProp(
            idname="iterations",
            default=1,
            min_val=1,
            max_val=100,
            fpb_label="Iterations"
        )

        self.NodeAddProp(operation)
        self.NodeAddProp(kernel_shape)
        self.NodeAddProp(kernel_size)
        self.NodeAddProp(self.iterations)

    def NodeInitParams(self):
        image = api.RenderImageParam("image", "Image")

        self.NodeAddParam(image)

    def MutedNodeEvaluation(self, eval_info):
        return self.EvalMutedNode(eval_info)

    def NodeEvaluation(self, eval_info):
        input_image = self.EvalParameter(eval_info, "image")
        operation = self.EvalProperty(eval_info, "operation")
        kernel_shape = self.EvalProperty(eval_info, "kernel_shape")
        kernel_size = self.EvalProperty(eval_info, "kernel_size")
        iterations = self.EvalProperty(eval_info, "iterations")

        image = input_image.Image("numpy")

        if kernel_shape == "Rectangle":
            kshape = cv2.MORPH_RECT
        elif kernel_shape == "Ellipse":
            kshape = cv2.MORPH_ELLIPSE
        elif kernel_shape == "Cross":
            kshape = cv2.MORPH_CROSS

        kernel_image = cv2.getStructuringElement(kshape, (kernel_size, kernel_size))

        if operation == "Erode":
            output_image = cv2.erode(image, kernel_image, iterations=iterations)
        elif operation == "Dilate":
            output_image = cv2.dilate(image, kernel_image, iterations=iterations)
        elif operation == "Opening":
            output_image = cv2.morphologyEx(image, cv2.MORPH_OPEN, kernel_image)
        elif operation == "Closing":
            output_image = cv2.morphologyEx(image, cv2.MORPH_CLOSE, kernel_image)
        elif operation == "Top Hat":
            output_image = cv2.morphologyEx(image, cv2.MORPH_TOPHAT, kernel_image)
        elif operation == "Black Hat":
            output_image = cv2.morphologyEx(image, cv2.MORPH_BLACKHAT, kernel_image)

        render_image = api.RenderImage()
        render_image.SetAsImage(output_image)
        self.NodeUpdateThumb(render_image)
        return render_image


api.RegisterNode(DilateErodeNode, "corenode_dilate_erode")
