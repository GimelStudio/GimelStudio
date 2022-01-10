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


class FitNode(api.Node):
    def __init__(self, nodegraph, _id):
        api.Node.__init__(self, nodegraph, _id)

    @property
    def NodeMeta(self):
        meta_info = {
            "label": "Fit",
            "author": "Gimel Studio",
            "version": (0, 5, 0),
            "category": "TRANSFORM",
            "description": "Fits the image into certain dimesions.",
        }
        return meta_info

    def NodeInitProps(self):
        fit_size = api.XYZProp(
            idname="fit_size", 
            default=(100, 100, 0), 
            labels=("X", "Y", "Z"),
            min_vals=(0, 0, 0), 
            max_vals=(8000, 8000, 0),
            show_p=False, 
            enable_z=False,
            fpb_label="Fit Size"
        )
        self.NodeAddProp(fit_size)

    def NodeInitParams(self):
        image = api.RenderImageParam("image", "Image")

        self.NodeAddParam(image)

    def MutedNodeEvaluation(self, eval_info):
        return self.EvalMutedNode(eval_info)

    def NodeEvaluation(self, eval_info):
        fit_size = self.EvalProperty(eval_info, "fit_size")
        image1 = self.EvalParameter(eval_info, "image")

        render_image = api.RenderImage()
        img = image1.Image("oiio")

        output_img = oiio.ImageBufAlgo.fit (img,
                                            roi=oiio.ROI(0,fit_size[0],0,fit_size[1],0,1,0,4))

        render_image.SetAsImage(output_img)
        self.NodeUpdateThumb(render_image)
        return render_image


api.RegisterNode(FitNode, "corenode_fit")
