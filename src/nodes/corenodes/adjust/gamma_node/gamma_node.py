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

from gimelstudio import api


class GammaNode(api.Node):
    def __init__(self, nodegraph, id):
        api.Node.__init__(self, nodegraph, id)

    @property
    def NodeMeta(self):
        meta_info = {
            "label": "Gamma",
            "author": "Gimel Studio",
            "version": (0, 5, 0),
            "category": "COLOR",
            "description": "Adjust the gamma/exposure of an image.",
        }
        return meta_info

    def NodeInitProps(self):
        image = api.ImageProp(
            idname="in_image",
        )
        gamma_value = api.IntegerProp(
            idname="gamma_value",
            default=1,
            min_val=1,
            max_val=100,
            show_p=True,
            fpb_label="Gamma"
        )
        self.NodeAddProp(image)
        self.NodeAddProp(gamma_value)

    def NodeInitOutputs(self):
        self.outputs = {
            "image": api.Output(idname="image", datatype="IMAGE", label="Image"),
        }

    def MutedNodeEvaluation(self, eval_info):
        return self.EvalMutedNode(eval_info)

    def NodeEvaluation(self, eval_info):
        image1 = self.EvalProperty(eval_info, "in_image")
        gamma_value = self.EvalProperty(eval_info, "gamma_value")

        render_image = api.Image()

        # Make correction for slider range of 1-100
        gamma_value = (gamma_value * 0.1)

        props = {
            "gamma_value": gamma_value,
        }
        shader_src = "nodes/corenodes/adjust/gamma_node/gamma.glsl"
        result = self.RenderGLSL(shader_src, props, image1)

        render_image.SetAsImage(result)
        self.NodeUpdateThumb(render_image)
        return {
            "image": render_image
        }

api.RegisterNode(GammaNode, "corenode_gamma")
