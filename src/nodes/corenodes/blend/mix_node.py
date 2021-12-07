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

try:
    import OpenImageIO as oiio
except ImportError:
    print("""OpenImageIO is required! Get the python wheel for Windows at:
     https://www.lfd.uci.edu/~gohlke/pythonlibs/#openimageio""")

from gimelstudio import api


class MixNode(api.Node):
    def __init__(self, nodegraph, _id):
        api.Node.__init__(self, nodegraph, _id)

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
        p = api.ChoiceProp(
            idname="blend_mode",
            default="Multiply",
            fpb_label="Blend Mode",
            choices=[
                    "Add",
                    "Subtract",
                    "Multiply",
                    "Divide",
            ]
        )

        self.NodeAddProp(p)

    def NodeInitParams(self):
        p1 = api.RenderImageParam("image", "Image")
        p2 = api.RenderImageParam("overlay", "Overlay")

        self.NodeAddParam(p1)
        self.NodeAddParam(p2)

    def MutedNodeEvaluation(self, eval_info):
        return self.EvalMutedNode(eval_info)

    def NodeEvaluation(self, eval_info):
        image = self.EvalParameter(eval_info, "image")
        overlay = self.EvalParameter(eval_info, "overlay")
        blend_mode = self.EvalProperty(eval_info, "blend_mode")

        render_image = api.RenderImage()

        image1 = image.Image("oiio")
        image2 = overlay.Image("oiio")

        if blend_mode == "Add":
            image = oiio.ImageBufAlgo.add(image2, image1)
        elif blend_mode == "Subtract":
            image = oiio.ImageBufAlgo.sub(image2, image1)
        elif blend_mode == "Multiply":
            image = oiio.ImageBufAlgo.mul(image2, image1)
        elif blend_mode == "Divide":
            image = oiio.ImageBufAlgo.div(image2, image1)

        render_image.SetAsImage(image)
        self.NodeUpdateThumb(render_image)
        return render_image


api.RegisterNode(MixNode, "corenode_mix")
