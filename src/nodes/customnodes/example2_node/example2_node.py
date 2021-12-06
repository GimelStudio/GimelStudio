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


from gimelstudio import api


class Example2Node(api.Node):
    def __init__(self, nodegraph, _id):
        api.Node.__init__(self, nodegraph, _id)

    @property
    def NodeMeta(self):
        meta_info = {
            "label": "Example Node 2",
            "author": "Gimel Studio",
            "version": (0, 0, 1),
            "category": "FILTER",
            "description": "Show an example node.",
        }
        return meta_info

    def NodeInitProps(self):
        self.value = api.PositiveIntegerProp(
            idname="opacity_value",
            default=25,
            min_val=0,
            max_val=100,
            show_p=True,
            label="Opacity"
        )
        self.NodeAddProp(self.value)

    def NodeInitParams(self):
        image = api.RenderImageParam("image", "Image")
        self.NodeAddParam(image)

    def MutedNodeEvaluation(self, eval_info):
        return self.EvalMutedNode(eval_info)

    def NodeEvaluation(self, eval_info):
        image1 = self.EvalParameter(eval_info, "image")
        opacity_value = self.EvalProperty(eval_info, "opacity_value")

        render_image = api.RenderImage()

        # Make correction for slider range of 1-100
        opacity_value = (opacity_value * 0.01)

        props = {
            "opacity_value": opacity_value
        }
        shader_src = "nodes/customnodes/example2_node/example2.glsl"
        result = self.RenderGLSL(shader_src, props, image1)

        render_image.SetAsImage(result)
        return render_image


api.RegisterNode(Example2Node, "node_example2")
