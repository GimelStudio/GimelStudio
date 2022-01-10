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

try:
    import OpenImageIO as oiio
except ImportError:
    print("""OpenImageIO is required! Get the python wheel for Windows at:
     https://www.lfd.uci.edu/~gohlke/pythonlibs/#openimageio""")

from gimelstudio import api


class CircularShiftNode(api.Node):
    def __init__(self, nodegraph, _id):
        api.Node.__init__(self, nodegraph, _id)

    @property
    def NodeMeta(self):
        meta_info = {
            "label": "Circular Shift",
            "author": "Gimel Studio",
            "version": (0, 5, 0),
            "category": "TRANSFORM",
            "description": "Circularly shifts an image.",
        }
        return meta_info

    def NodeInitProps(self):
        shift = api.XYZProp(
            idname="shift", 
            default=(0, 0, 0), 
            labels=("X", "Y", "Z"),
            min_vals=(0, 0, 0), 
            max_vals=(800, 800, 800),
            show_p=False, 
            enable_z=True,
            fpb_label="Shift"
        )
        self.NodeAddProp(shift)

    def NodeInitParams(self):
        image = api.RenderImageParam("image", "Image")

        self.NodeAddParam(image)

    def MutedNodeEvaluation(self, eval_info):
        return self.EvalMutedNode(eval_info)

    def NodeEvaluation(self, eval_info):
        shifting = self.EvalProperty(eval_info, "shift")
        image1 = self.EvalParameter(eval_info, "image")

        render_image = api.RenderImage()
        img = image1.Image("oiio")

        output_img = oiio.ImageBufAlgo.circular_shift(img, shifting[0], 
                                                      shifting[1], shifting[2])

        render_image.SetAsImage(output_img)
        self.NodeUpdateThumb(render_image)
        return render_image


api.RegisterNode(CircularShiftNode, "corenode_circularshift")