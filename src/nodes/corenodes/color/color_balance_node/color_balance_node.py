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


class ColorBalanceNode(api.Node):
    def __init__(self, nodegraph, id):
        api.Node.__init__(self, nodegraph, id)

    @property
    def NodeMeta(self):
        meta_info = {
            "label": "Color Balance",
            "author": "Gimel Studio",
            "version": (0, 5, 0),
            "category": "FILTER",
            "description": "Adjust the colors of an image.",
        }
        return meta_info

    def NodeInitProps(self):
        image = api.ImageProp(
            idname="in_image",
        )
        red_value = api.IntegerProp(
            idname="red",
            default=100,
            min_val=-100,
            max_val=100,
            show_p=True,
            fpb_label="Red"
        )
        green_value = api.IntegerProp(
            idname="green",
            default=100,
            min_val=-100,
            max_val=100,
            show_p=True,
            fpb_label="Green"
        )
        blue_value = api.IntegerProp(
            idname="blue",
            default=100,
            min_val=-100,
            max_val=100,
            show_p=True,
            fpb_label="Blue"
        )
        self.NodeAddProp(image)
        self.NodeAddProp(red_value)
        self.NodeAddProp(green_value)
        self.NodeAddProp(blue_value)

    def NodeInitOutputs(self):
        self.outputs = {
            "image": api.Output(idname="image", datatype="IMAGE", label="Image"),
        }

    def MutedNodeEvaluation(self, eval_info):
        return self.EvalMutedNode(eval_info)

    def NodeEvaluation(self, eval_info):
        image1 = self.EvalProperty(eval_info, "in_image")
        red_value = self.EvalProperty(eval_info, "red")
        green_value = self.EvalProperty(eval_info, "green")
        blue_value = self.EvalProperty(eval_info, "blue")

        render_image = api.Image()
        
        # Make correction for slider range
        red_value = (red_value * 0.1)
        green_value = (green_value * 0.1)
        blue_value = (blue_value * 0.1)

        props = {
            "red": red_value,
            "green": green_value,
            "blue": blue_value
        }
        shader_src = "nodes/corenodes/color/color_balance_node/color_balance.glsl"
        result = self.RenderGLSL(shader_src, props, image1)

        render_image.SetAsImage(result)
        self.NodeUpdateThumb(render_image)
        return {
            "image": render_image
        }


api.RegisterNode(ColorBalanceNode, "corenode_colorbalance")
