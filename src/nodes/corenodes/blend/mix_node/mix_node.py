# ----------------------------------------------------------------------------
# Gimel Studio Copyright 2019-2022 by the Gimel Studio project contributors
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


class MixNode(api.Node):
    def __init__(self, nodegraph, id):
        api.Node.__init__(self, nodegraph, id)

    @property
    def NodeMeta(self):
        meta_info = {
            "label": "Mix",
            "author": "Gimel Studio",
            "version": (1, 8, 6),
            "category": "BLEND",
            "description": "Layers two images together using the specified blend type.",
        }
        return meta_info

    def NodeInitProps(self):
        image_1 = api.ImageProp(
            idname="in_image",
        )
        image_2 = api.ImageProp(
            idname="in_image_2",
        )
        blend_mode = api.ChoiceProp(
            idname="blend_mode",
            default="Multiply",
            fpb_label="Blend Mode",
            choices=[
                "Normal", "Darken", "Multiply", "Color Burn", 
                "Lighten", "Screen", "Color Dodge", "Add",
                "Overlay", "Soft Light", "Difference", "Subtract",
                "Divide", "Reflect", "Glow", "Average", "Exclusion"
                ]
        )
        opacity = api.IntegerProp(
            "opacity",
            default=100,
            lbl_suffix="%",
            min_val=0,
            max_val=100,
            fpb_label="Opacity"
        )

        self.NodeAddProp(image_1)
        self.NodeAddProp(image_2)
        self.NodeAddProp(blend_mode)
        self.NodeAddProp(opacity)

    def NodeInitOutputs(self):
        self.outputs = {
            "image": api.Output(idname="image", datatype="IMAGE", label="Image"),
        }

    def MutedNodeEvaluation(self, eval_info):
        return self.EvalMutedNode(eval_info)

    def NodeEvaluation(self, eval_info):
        image1 = self.EvalProperty(eval_info, "in_image")
        image2 = self.EvalProperty(eval_info, "in_image_2")
        blend_mode = self.EvalProperty(eval_info, "blend_mode")
        opacity = self.EvalProperty(eval_info, "opacity")

        render_image = api.Image()

        # Set a float value to represent each mode
        if blend_mode == "Normal":
            blend_mode = 1.0
        elif blend_mode == "Darken":
            blend_mode = 2.0
        elif blend_mode == "Multiply":
            blend_mode = 3.0
        elif blend_mode == "Color Burn":
            blend_mode = 4.0
        elif blend_mode == "Lighten":
            blend_mode = 5.0
        elif blend_mode == "Screen":
            blend_mode = 6.0
        elif blend_mode == "Color Dodge":
            blend_mode = 7.0
        elif blend_mode == "Add":
            blend_mode = 8.0
        elif blend_mode == "Overlay":
            blend_mode = 9.0
        elif blend_mode == "Soft Light":
            blend_mode = 10.0
        elif blend_mode == "Difference":
            blend_mode = 11.0
        elif blend_mode == "Subtract":
            blend_mode = 12.0
        elif blend_mode == "Divide":
            blend_mode = 13.0
        elif blend_mode == "Reflect":
            blend_mode = 14.0
        elif blend_mode == "Glow":
            blend_mode = 15.0
        elif blend_mode == "Average":
            blend_mode = 16.0
        elif blend_mode == "Exclusion":
            blend_mode = 17.0

        # Make correction for slider range of 1-100
        opacity_value = 255.0 #(opacity * 0.01) #* 255.0

        props = {
            "blend_mode": blend_mode,
            "opacity": opacity_value
        }
        shader_src = "nodes/corenodes/blend/mix_node/mix.glsl"
        result = self.RenderGLSL(shader_src, props, image1, image2)

        render_image.SetAsImage(result)
        self.NodeUpdateThumb(render_image)
        return {
            "image": render_image
        }


api.RegisterNode(MixNode, "corenode_mix")
