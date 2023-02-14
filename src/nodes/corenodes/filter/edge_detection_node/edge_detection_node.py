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


class EdgeDetectionNode(api.Node):
    def __init__(self, nodegraph, id):
        api.Node.__init__(self, nodegraph, id)

    @property
    def NodeMeta(self):
        meta_info = {
            "label": "Edge Detection",
            "author": "Gimel Studio",
            "version": (0, 6, 0),
            "category": "FILTER",
            "description": "Detect the edges in an image.",
        }
        return meta_info

    def NodeInitProps(self):
        image = api.ImageProp(
            idname="in_image",
        )
        self.NodeAddProp(image)

    def NodeInitOutputs(self):
        self.outputs = {
            "image": api.Output(idname="image", datatype="IMAGE", label="Image"),
        }

    def MutedNodeEvaluation(self, eval_info):
        return self.EvalMutedNode(eval_info)

    def NodeEvaluation(self, eval_info):
        image = self.EvalProperty(eval_info, "in_image")

        render_image = api.Image()
        props = {}
        shader_src = "nodes/corenodes/filter/edge_detection_node/edge_detection.glsl"
        result = self.RenderGLSL(shader_src, props, image)

        render_image.SetAsImage(result)
        self.NodeUpdateThumb(render_image)
        return {
            "image": render_image
        }


api.RegisterNode(EdgeDetectionNode, "corenode_edge_detection")
