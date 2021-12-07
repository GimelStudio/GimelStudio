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


class AlphaOverNode(api.Node):
    def __init__(self, nodegraph, _id):
        api.Node.__init__(self, nodegraph, _id)

    @property
    def NodeMeta(self):
        meta_info = {
            "label": "Alpha Over",
            "author": "Gimel Studio",
            "version": (0, 0, 1),
            "category": "BLEND",
            "description": "Alpha over two images together based on the factor.",
        }
        return meta_info

    def NodeInitProps(self):
        self.value = api.PositiveIntegerProp(
            idname="factor",
            default=100,
            min_val=0,
            max_val=100,
            fpb_label="Factor"
        )
        self.NodeAddProp(self.value)

    def NodeInitParams(self):
        image1 = api.RenderImageParam("image 1", "Image")
        image2 = api.RenderImageParam('image 2', "Image")
        integer = api.IntegerParam("integer", "Factor")

        self.NodeAddParam(image1)
        self.NodeAddParam(image2)
        self.NodeAddParam(integer)

    def MutedNodeEvaluation(self, eval_info):
        return self.EvalMutedNode(eval_info)

    def NodeEvaluation(self, eval_info):
        image1 = self.EvalParameter(eval_info, "image 1")
        image2 = self.EvalParameter(eval_info, "image 2")

        # TODO: remove this as an integer input isn't needed here.
        # This is done more as a proof-of-concept for now.
        integer = self.EvalParameter(eval_info, "integer")
        if integer > 1:
            factor = integer
        else:
            factor = self.EvalProperty(eval_info, "factor")

        render_image = api.RenderImage()

        # Make correction for slider range of 1-100
        factor = (factor * 0.01)

        props = {
            "factor": factor
        }
        shader_src = "nodes/corenodes/blend/alpha_over_node/alpha_over.glsl"
        result = self.RenderGLSL(shader_src, props, image1, image2)

        render_image.SetAsImage(result)
        self.NodeUpdateThumb(render_image)
        return render_image


api.RegisterNode(AlphaOverNode, "corenode_alpha_over")
