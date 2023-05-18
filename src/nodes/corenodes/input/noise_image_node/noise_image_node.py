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

try:
    import OpenImageIO as oiio
except ImportError:
    print("""OpenImageIO is required! Get the python wheel for Windows at:
     https://www.lfd.uci.edu/~gohlke/pythonlibs/#openimageio""")

from gimelstudio import api
from gimelstudio.core import EvalInfo, Image


class NoiseImageNode(api.Node):
    def __init__(self, nodegraph, id):
        api.Node.__init__(self, nodegraph, id)

    @property
    def NodeMeta(self):
        meta_info = {
            "label": "Noise",
            "author": "Gimel Studio",
            "version": (0, 6, 0),
            "category": "INPUT",
            "description": "Creates a noise image."
        }
        return meta_info

    def NodeWidgetEventHook(self, idname, value):
        if idname == "noise_seed":
            image = self.NodeEvalSelf()
            self.NodeUpdateThumb(image)
            self.RefreshNodeGraph()

    def NodeDndEventHook(self):
        image = self.NodeEvalSelf()
        self.NodeUpdateThumb(image)
        self.RefreshNodeGraph()

    def NodeInitProps(self):
        width = api.IntegerProp(
            idname="width",
            default=512,
            min_val=1,
            max_val=10000,
            show_p=True,
            fpb_label="Width"
        )
        height = api.IntegerProp(
            idname="height",
            default=512,
            min_val=1,
            max_val=10000,
            show_p=True,
            fpb_label="Height"
        )
        self.NodeAddProp(width)
        self.NodeAddProp(height)

    def NodeInitOutputs(self):
        self.outputs = {
            "image": api.Output(idname="image", datatype="IMAGE", label="Image"),
        }

    def NodeEvaluation(self, eval_info):
        render_image = api.Image()
        image_width = self.EvalProperty(eval_info, "width")
        image_height = self.EvalProperty(eval_info, "height")
        props = {}
        shader_src = "nodes/corenodes/input/noise_image_node/noise_image_node.glsl"
        image = Image((image_width, image_height))
        result = self.RenderGLSL(shader_src, props, image)

        render_image.SetAsImage(result)
        self.NodeUpdateThumb(render_image)
        return {
            "image": render_image
        }


api.RegisterNode(NoiseImageNode, "corenode_noiseimage")
