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


class AddTextNode(api.Node):
    def __init__(self, nodegraph, id):
        api.Node.__init__(self, nodegraph, id)

    @property
    def NodeMeta(self):
        meta_info = {
            "label": "Add Text",
            "author": "Gimel Studio",
            "version": (0, 5, 0),
            "category": "DRAW",
            "description": "Adds a text overlay to an image.",
        }
        return meta_info

    def NodeInitProps(self):
        font = api.ChoiceProp(
            idname="font",
            default="Arial",
            choices=["Arial", "Calibri"],
            fpb_label="Font"
        )
        font_size = api.IntegerProp(
            idname="font_size",
            default=100,
            min_val=1,
            max_val=1000,
            lbl_suffix="px",
            fpb_label="Font Size"
        )
        text = api.StringProp(
            idname="text",
            default="Gimel Studio",
            fpb_label="Text"
        )
        position = api.VectorProp(
            idname="position", 
            default=(25, 25, 0), 
            labels=("X", "Y"),
            min_vals=(0, 0, 0), 
            max_vals=(4000, 4000, 0),
            show_p=False, 
            fpb_label="Position"
        )
        align_x = api.ChoiceProp(
            idname="align_x",
            default="Left",
            choices=["Left", "Right", "Center"],
            fpb_label="Align X"
        )
        align_y = api.ChoiceProp(
            idname="align_y",
            default="Baseline",
            choices=["Baseline", "Top", "Bottom", "Center"],
            fpb_label="Align Y"
        )
        self.NodeAddProp(font)
        self.NodeAddProp(font_size)
        self.NodeAddProp(text)
        self.NodeAddProp(position)
        self.NodeAddProp(align_x)
        self.NodeAddProp(align_y)

    def NodeInitParams(self):
        image = api.ImageParam("image", "Image")

        self.NodeAddParam(image)

    def MutedNodeEvaluation(self, eval_info):
        return self.EvalMutedNode(eval_info)

    def NodeEvaluation(self, eval_info):
        font = self.EvalProperty(eval_info, "font")
        font_size = self.EvalProperty(eval_info, "font_size")
        text = self.EvalProperty(eval_info, "text")
        position = self.EvalProperty(eval_info, "position")
        align_x = self.EvalProperty(eval_info, "align_x")
        align_y = self.EvalProperty(eval_info, "align_y")
        image1 = self.EvalParameter(eval_info, "image")

        render_image = api.Image()
        img = image1.Image("oiio")

        spec = img.spec()
        txt = oiio.ImageBuf(oiio.ImageSpec(spec.width, spec.height, 4, oiio.INT16))
        oiio.ImageBufAlgo.render_text (txt, position[0], position[1], text,
                                       font_size, font, (255,255,255,1), alignx=align_x.lower(), 
                                       aligny=align_y.lower())
        dst = oiio.ImageBufAlgo.over(txt, img)

        render_image.SetAsImage(dst)
        self.NodeUpdateThumb(render_image)
        return render_image


api.RegisterNode(AddTextNode, "corenode_addtext")
