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

try:
    import OpenImageIO as oiio
except ImportError:
    print("""OpenImageIO is required! Get the python wheel for Windows at:
     https://www.lfd.uci.edu/~gohlke/pythonlibs/#openimageio""")

from gimelstudio import api


class CheckeredImageNode(api.Node):
    def __init__(self, nodegraph, id):
        api.Node.__init__(self, nodegraph, id)

    @property
    def NodeMeta(self):
        meta_info = {
            "label": "Checkered",
            "author": "Gimel Studio",
            "version": (0, 2, 0),
            "category": "INPUT",
            "description": "Creates a checkered image."
        }
        return meta_info

    def NodeWidgetEventHook(self, idname, value):
        if idname == "checker_size":
            image = self.NodeEvalSelf()
            self.NodeUpdateThumb(image)
            self.RefreshNodeGraph()

    def NodeDndEventHook(self):
        image = self.NodeEvalSelf()
        self.NodeUpdateThumb(image)
        self.RefreshNodeGraph()

    def NodeInitProps(self):
        checker_size = api.PositiveIntegerProp(
            idname="checker_size",
            default=46,
            min_val=0,
            max_val=100,
            fpb_label="Checker Size"
        )
        offset = api.XYZProp(
            idname="offset", 
            default=(0, 0, 0), 
            labels=("X", "Y", "Z"),
            min_vals=(0, 0, 0), 
            max_vals=(200, 200, 200),
            show_p=False, 
            enable_z=True,
            fpb_label="Offset"
        )

        self.NodeAddProp(checker_size)
        self.NodeAddProp(offset)

    def NodeEvaluation(self, eval_info):
        checker_size = self.EvalProperty(eval_info, "checker_size")
        offset = self.EvalProperty(eval_info, "offset")

        render_image = api.Image()

        buf = oiio.ImageBuf(oiio.ImageSpec(1200, 1200, 4, oiio.FLOAT))
        oiio.ImageBufAlgo.checker(buf, checker_size, checker_size, 1, 
                                  color1=(0.1,0.1,0.1,255.0), color2=(0.4,0.4,0.4,255.0),
                                  xoffset=offset[0], yoffset=offset[1], 
                                  zoffset=offset[2])

        render_image.SetAsImage(buf)
        self.NodeUpdateThumb(render_image)
        return render_image


api.RegisterNode(CheckeredImageNode, "corenode_checkeredimage")
