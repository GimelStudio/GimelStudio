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

from gimelstudio import api


class BrightnessContrastNode(api.Node):
    def __init__(self, nodegraph, _id):
        api.Node.__init__(self, nodegraph, _id)

    @property
    def NodeMeta(self):
        meta_info = {
            "label": "Brightness/Contrast",
            "author": "Gimel Studio",
            "version": (0, 5, 0),
            "category": "COLOR",
            "description": "Adjust the brightness/contrast of an image.",
        }
        return meta_info

    def NodeInitProps(self):
        brightness_value = api.PositiveIntegerProp(
            idname="brightness_value",
            default=0,
            min_val=0,
            max_val=200,
            show_p=True,
            fpb_label="Brightness"
        )
        contrast_value = api.PositiveIntegerProp(
            idname="contrast_value",
            default=100,
            min_val=0,
            max_val=200,
            show_p=True,
            fpb_label="Contrast"
        )
        self.NodeAddProp(brightness_value)
        self.NodeAddProp(contrast_value)

    def NodeInitParams(self):
        image = api.RenderImageParam("image", "Image")
        self.NodeAddParam(image)

    def MutedNodeEvaluation(self, eval_info):
        return self.EvalMutedNode(eval_info)

    def NodeEvaluation(self, eval_info):
        image1 = self.EvalParameter(eval_info, "image")
        brightness_value = self.EvalProperty(eval_info, "brightness_value")
        contrast_value = self.EvalProperty(eval_info, "contrast_value")

        render_image = api.RenderImage()

        # Make correction for slider range of 1-100
        brightness_value = (brightness_value * 0.01)
        contrast_value = (contrast_value * 0.01)

        props = {
            "brightness_value": brightness_value,
            "contrast_value": contrast_value
        }
        shader_src = "nodes/corenodes/adjust/brightness_contrast_node/brightness_contrast.glsl"
        result = self.RenderGLSL(shader_src, props, image1)

        render_image.SetAsImage(result)
        self.NodeUpdateThumb(render_image)
        return render_image


api.RegisterNode(BrightnessContrastNode, "corenode_brightnesscontrast")
